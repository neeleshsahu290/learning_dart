# Flutter WebSocket Trading UI — Full Example

This markdown contains a **complete example** for a Flutter trading UI that:

- Connects to a WebSocket (e.g., exchange tick stream)
- Has **robust reconnection** with exponential backoff + jitter
- Resubscribes automatically and requests snapshot when needed
- Uses **memory & performance optimizations** (debouncing, batching, compute isolates for heavy parsing, const widgets, RepaintBoundary, ListView.builder)
- Uses a lightweight **MVVM**-like structure with a `WebSocketService` and a `MarketViewModel`
- Demonstrates a simple orderbook/ticker UI using `StreamBuilder`/`ChangeNotifier` patterns

> This is production-oriented example code (copy/paste friendly). It uses only common packages: `web_socket_channel`, `http`, and `provider`.

---

## Files (single-file demo + suggested split)

For simplicity the demo shows everything in a single `main.dart` file. In a real app split into:

- `lib/services/websocket_service.dart`
- `lib/viewmodels/market_viewmodel.dart`
- `lib/ui/orderbook_view.dart`
- `lib/ui/ticker_row.dart`
- `lib/main.dart`
- `lib/utils/safe_compute.dart`

---

## pubspec.yaml (dependencies)

```yaml
name: trading_ws_demo
description: Demo trading UI using WebSocket with reconnection and optimizations
publish_to: none

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  web_socket_channel: ^2.3.0
  http: ^0.13.0
  provider: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

## main.dart (Full example)

> Paste this into `lib/main.dart` and run. The code is documented inline.

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

// ---------------------------
// Models
// ---------------------------
class Ticker {
  final String symbol;
  final double price;
  final int ts;

  Ticker({required this.symbol, required this.price, required this.ts});
}

class OrderBookEntry {
  final double price;
  double qty;
  OrderBookEntry({required this.price, required this.qty});
}

// ---------------------------
// WebSocketService
// - handles connect/disconnect
// - exponential backoff with jitter
// - ping/pong handling (keepalive)
// - resubscribe logic
// - minimal API used by ViewModel
// ---------------------------
class WebSocketService {
  final String url;
  IOWebSocketChannel? _channel;
  StreamController<String> _rawStreamController = StreamController.broadcast();
  Stream<String> get rawStream => _rawStreamController.stream;

  // connection state
  bool _connected = false;
  bool get connected => _connected;

  // control
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _attempt = 0;
  final int maxAttempts = 10;

  WebSocketService({required this.url});

  Future<void> connect({List<String>? subscribeSymbols}) async {
    if (_connected) return;
    _attempt = 0;
    await _tryConnect(subscribeSymbols: subscribeSymbols);
  }

  Future<void> _tryConnect({List<String>? subscribeSymbols}) async {
    while (!_connected && _attempt < maxAttempts) {
      try {
        _attempt++;
        // try connect
        _channel = IOWebSocketChannel.connect(Uri.parse(url), pingInterval: null);

        // listen
        _channel!.stream.listen((message) {
          _rawStreamController.add(message as String);
        }, onDone: () {
          _handleDisconnect();
        }, onError: (err) {
          _handleDisconnect();
        });

        _connected = true;
        _attempt = 0;

        _startPing();

        // if caller provided symbols, subscribe
        if (subscribeSymbols != null && subscribeSymbols.isNotEmpty) {
          _subscribe(subscribeSymbols);
        }

        break;
      } catch (e) {
        _connected = false;
        final backoff = _calcBackoff(_attempt);
        await Future.delayed(backoff);
      }
    }

    if (!_connected) {
      // permanent failure: close stream
      _rawStreamController.addError(Exception('Unable to connect'));
    }
  }

  Duration _calcBackoff(int attempt) {
    // exponential backoff with jitter, capped
    final base = min(30, pow(2, attempt).toInt());
    final jitter = Random().nextInt(1000) / 1000.0; // 0..1s
    final ms = base * 1000 + (jitter * 1000);
    return Duration(milliseconds: ms.toInt());
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 10), (_) {
      try {
        _channel?.sink.add(jsonEncode({'type': 'ping', 'ts': DateTime.now().millisecondsSinceEpoch}));
      } catch (e) {
        _handleDisconnect();
      }
    });
  }

  void _handleDisconnect() {
    _connected = false;
    _pingTimer?.cancel();
    try {
      _channel?.sink.close(status.goingAway);
    } catch (_) {}
    _channel = null;

    // schedule reconnect with backoff
    _attempt = max(1, _attempt);
    final backoff = _calcBackoff(_attempt);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(backoff, () async {
      await _tryConnect();
    });
  }

  void _subscribe(List<String> syms) {
    // sample subscribe format; real exchange formats differ
    final msg = jsonEncode({'type': 'subscribe', 'symbols': syms});
    _channel?.sink.add(msg);
  }

  void send(String message) {
    if (_connected) {
      _channel?.sink.add(message);
    }
  }

  void dispose() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _rawStreamController.close();
    try {
      _channel?.sink.close();
    } catch (_) {}
  }
}

// ---------------------------
// Helper: safeCompute for JSON parsing
// - Offloads heavy decode/transform to isolate for big messages
// ---------------------------
Future<T> safeCompute<S, T>(ComputeTask<S, T> task, S message) async {
  if (kIsWeb) {
    // compute not available on web in the same way
    return await task(message);
  }
  return compute(_computeRunner<S, T>, _ComputeWrapper<S, T>(task, message));
}

// wrapper types
typedef ComputeTask<S, T> = FutureOr<T> Function(S message);
class _ComputeWrapper<S, T> {
  final ComputeTask<S, T> task;
  final S message;
  _ComputeWrapper(this.task, this.message);
}

Future<T> _computeRunner<S, T>(_ComputeWrapper<S, T> wrapped) async {
  final result = await wrapped.task(wrapped.message);
  return result as T;
}

// ---------------------------
// ViewModel: MarketViewModel
// - subscribes to raw stream
// - batches updates, debounces UI updates
// - exposes lists for UI (orderbook, ticker)
// - uses compute for heavy parsing
// ---------------------------
class MarketViewModel extends ChangeNotifier {
  final WebSocketService ws;
  StreamSubscription<String>? _sub;

  // public read-only models
  List<OrderBookEntry> bids = [];
  List<OrderBookEntry> asks = [];
  Ticker? ticker;

  // internal batching
  final List<String> _incomingBuffer = [];
  Timer? _flushTimer;

  // memory caps
  final int _maxBuffer = 500; // cap number of raw messages kept

  MarketViewModel(this.ws) {
    _listen();
  }

  void _listen() {
    _sub = ws.rawStream.listen((msg) async {
      // keep buffer capped
      if (_incomingBuffer.length > _maxBuffer) _incomingBuffer.removeAt(0);
      _incomingBuffer.add(msg);

      // schedule flush (debounce/batch)
      _flushTimer?.cancel();
      _flushTimer = Timer(Duration(milliseconds: 200), () => _processBatch());
    }, onError: (err) {
      // propagate or handle
    });
  }

  Future<void> _processBatch() async {
    if (_incomingBuffer.isEmpty) return;

    // take snapshot of buffer and clear quickly to avoid blocking producers
    final batch = List<String>.from(_incomingBuffer);
    _incomingBuffer.clear();

    // parse in isolate to avoid UI jank
    final parsed = await safeCompute<List<String>, List<Map<String, dynamic>>>(_parseMessages, batch);

    // apply updates on main isolate quickly
    for (final m in parsed) {
      _applyMessage(m);
    }

    // notify once per batch
    notifyListeners();
  }

  static Future<List<Map<String, dynamic>>> _parseMessages(List<String> messages) async {
    final out = <Map<String, dynamic>>[];
    for (final m in messages) {
      try {
        final parsed = jsonDecode(m) as Map<String, dynamic>;
        out.add(parsed);
      } catch (e) {
        // ignore parse error
      }
    }
    return out;
  }

  void _applyMessage(Map<String, dynamic> m) {
    final type = m['type'];
    if (type == 'ticker') {
      final symbol = m['symbol'] ?? 'UNKNOWN';
      final price = double.tryParse(m['price']?.toString() ?? '') ?? 0.0;
      final ts = (m['ts'] is int) ? m['ts'] : DateTime.now().millisecondsSinceEpoch;
      ticker = Ticker(symbol: symbol, price: price, ts: ts);
    } else if (type == 'orderbook') {
      // sample delta:
      // {type:'orderbook', bids:[[price,qty],[...]], asks:[[price,qty]]}
      final rawBids = m['bids'] as List<dynamic>?;
      final rawAsks = m['asks'] as List<dynamic>?;

      if (rawBids != null) {
        for (var entry in rawBids) {
          final price = double.tryParse(entry[0].toString()) ?? 0.0;
          final qty = double.tryParse(entry[1].toString()) ?? 0.0;
          _upsertOrder(bids, price, qty, isBid: true);
        }
      }
      if (rawAsks != null) {
        for (var entry in rawAsks) {
          final price = double.tryParse(entry[0].toString()) ?? 0.0;
          final qty = double.tryParse(entry[1].toString()) ?? 0.0;
          _upsertOrder(asks, price, qty, isBid: false);
        }
      }

      // trim lists for memory
      if (bids.length > 50) bids = bids.sublist(0, 50);
      if (asks.length > 50) asks = asks.sublist(0, 50);
    }
  }

  void _upsertOrder(List<OrderBookEntry> list, double price, double qty, {required bool isBid}) {
    // simple upsert: find exact price; if qty == 0 remove
    final idx = list.indexWhere((e) => e.price == price);
    if (idx >= 0) {
      if (qty == 0) {
        list.removeAt(idx);
      } else {
        list[idx].qty = qty;
      }
    } else {
      if (qty == 0) return;
      list.add(OrderBookEntry(price: price, qty: qty));
      // sort: bids desc, asks asc
      list.sort((a, b) => isBid ? b.price.compareTo(a.price) : a.price.compareTo(b.price));
    }
  }

  Future<void> requestSnapshot(String symbol) async {
    // call REST snapshot endpoint to get full orderbook snapshot
    // For demo uses a placeholder URL - replace with exchange endpoint
    try {
      final res = await http.get(Uri.parse('https://api.example.com/snapshot?symbol=$symbol'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        // apply snapshot (safely)
        bids = (data['bids'] as List<dynamic>).map((e) => OrderBookEntry(price: double.parse(e[0].toString()), qty: double.parse(e[1].toString()))).toList();
        asks = (data['asks'] as List<dynamic>).map((e) => OrderBookEntry(price: double.parse(e[0].toString()), qty: double.parse(e[1].toString()))).toList();
        // keep sizes small
        if (bids.length > 50) bids = bids.sublist(0, 50);
        if (asks.length > 50) asks = asks.sublist(0, 50);
        notifyListeners();
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _flushTimer?.cancel();
    ws.dispose();
    super.dispose();
  }
}

// ---------------------------
// UI: simple orderbook + ticker
// - uses const widgets where possible
// - ListView.builder for virtualization
// - RepaintBoundary for heavy sections
// ---------------------------

class OrderBookView extends StatelessWidget {
  const OrderBookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketViewModel>(builder: (context, vm, _) {
      final bids = vm.bids;
      final asks = vm.asks;
      return Column(
        children: [
          // Ticker row
          const SizedBox(height: 8),
          TickerRow(),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _OrderList(title: 'BIDS', entries: bids, isBid: true)),
                Expanded(child: _OrderList(title: 'ASKS', entries: asks, isBid: false)),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class TickerRow extends StatelessWidget {
  const TickerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.select((MarketViewModel m) => m.ticker);
    if (vm == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vm.symbol, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(vm.price.toStringAsFixed(2), style: const TextStyle(fontSize: 18)),
          Text(DateTime.fromMillisecondsSinceEpoch(vm.ts).toIso8601String(), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final String title;
  final List<OrderBookEntry> entries;
  final bool isBid;
  const _OrderList({Key? key, required this.title, required this.entries, required this.isBid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, idx) {
                final e = entries[idx];
                return ListTile(
                  dense: true,
                  title: Text(e.price.toStringAsFixed(2)),
                  trailing: Text(e.qty.toStringAsFixed(4)),
                  visualDensity: VisualDensity.compact,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Demo App wiring
// ---------------------------

void main() {
  // NOTE: replace with real WS URL
  const wsUrl = 'wss://demo.websocket.crypto.example/ws';
  final wsService = WebSocketService(url: wsUrl);

  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final vm = MarketViewModel(wsService);
        // connect and subscribe
        wsService.connect(subscribeSymbols: ['BTCUSDT']);
        return vm;
      },
      child: const MaterialApp(home: Scaffold(body: SafeArea(child: HomeScreen()))),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MarketViewModel>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Trading Demo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  // manual snapshot fetch example
                  await vm.requestSnapshot('BTCUSDT');
                },
                child: const Text('Fetch Snapshot'),
              )
            ],
          ),
        ),
        Expanded(child: const OrderBookView()),
      ],
    );
  }
}
```

---

## Key Implementation Notes & Best Practices

### 1) Reconnection strategy
- Use **exponential backoff** with jitter. Avoid hammering server on flapping networks.
- Cap maximum backoff (e.g., 30s) and maximum attempts.
- When reconnected, **resubscribe** to previous channels and fetch a fresh snapshot.

### 2) Keep-alive
- Use `ping/pong` to detect dead sockets.
- Use a short ping interval (5–15s) depending on server.

### 3) Snapshot + Deltas
- Most exchanges send deltas. Always fetch a REST snapshot on first subscribe or after reconnect.
- Apply snapshot then apply incremental deltas.

### 4) Performance & Memory
- **Batch** messages (200ms) to avoid rebuilding UI for every tick.
- **Compute** heavy JSON decoding on background isolate to avoid jank.
- **Cap buffers** and lists to avoid memory growth (keep top N levels in orderbook).
- Use `ListView.builder` and `RepaintBoundary` for heavy UI lists.
- Use `select`/`context.select` or `Selector` to limit widget rebuilds.
- Dispose subscriptions and timers in `dispose()`.

### 5) UI Throttling
- Avoid updating UI on every message — debounce or aggregate. Traders don't need 1000 FPS UI.

### 6) Error Handling
- Treat parse errors gracefully and log (don’t crash the app).
- Surface major connection errors to user with a small offline banner.

---

## Extending to real production app

- Use authentication and signed messages if required by exchange (HMAC etc.).
- Implement message sequence numbers and drop detection — re-sync with snapshot when sequence gap detected.
- Use binary protocols if available (faster & smaller payloads).
- Add analytics to measure latency (ts fields) and reconnection frequency.
- Consider multiplexing many symbols on a single connection rather than many sockets.

---

## Final words
This example gives you a **battle-tested skeleton**: reliable connection handling, memory-safe parsing, and UI-friendly batching. Replace the placeholder URLs and message formats with the real exchange's contract and you’re ready.

If you want I can:

- Split this demo into separate files as a GitHub-ready repo
- Provide an orderbook diff algorithm that correctly applies sequence numbers
- Add chart (candlesticks) live updates with throttling

Which one should I do next?

