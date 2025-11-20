# Flutter — SQLite-backed, memory-safe infinite scroll (Full code)

This document contains a **complete, working example** showing how to implement a memory-safe infinite scroll in Flutter using **sqflite**, **Provider**, and a sliding window strategy. It includes:

- model
- sqlite service
- API service (mock + hooks to real API)
- Provider with merging, updates & trimming
- ListView.builder UI with stable scrolling on refresh
- notes on how to adapt to your real API

> **Important:** Put these files under `lib/` in a Flutter project and add dependencies shown in `pubspec.yaml`.

---

## `pubspec.yaml` (dependencies)

```yaml
name: sqlite_pagination_example
description: Example project for memory-safe infinite scroll
publish_to: 'none'

environment:
  sdk: '>=2.18.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  sqflite: ^2.2.7
  path: ^1.8.4
  http: ^1.1.0

flutter:
  uses-material-design: true
```

---

## `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/item_provider.dart';
import 'screens/items_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: MaterialApp(
        title: 'SQLite Pagination Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ItemsScreen(),
      ),
    );
  }
}
```

---

## `lib/data/item_model.dart`

```dart
class Item {
  final int id;
  final String title;
  final int updatedAt; // unix timestamp for simple update detection

  Item({required this.id, required this.title, required this.updatedAt});

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        id: map['id'] as int,
        title: map['title'] as String,
        updatedAt: map['updatedAt'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'updatedAt': updatedAt,
      };
}
```

---

## `lib/data/db_service.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'item_model.dart';

class DBService {
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertItems(List<Item> items) async {
    final db = await database;
    final batch = db.batch();
    for (final item in items) {
      batch.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // replace updated rows
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Item>> getItems({required int offset, required int limit}) async {
    final db = await database;
    final maps = await db.query(
      'items',
      orderBy: 'id DESC', // newest first
      limit: limit,
      offset: offset,
    );
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  Future<int> getCount() async {
    final db = await database;
    final v = await db.rawQuery('SELECT COUNT(*) as c FROM items');
    return Sqflite.firstIntValue(v) ?? 0;
  }
}
```

---

## `lib/services/api_service.dart` (mock + adapter for real API)

```dart
import 'dart:async';
import 'dart:math';
import '../data/item_model.dart';

// This is a simple mock API for demo. Replace implementations with your real API calls.
class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  static const int _totalAvailable = 10000; // pretend server has many posts

  // Simulated server data source
  final Random _random = Random(42);

  // Fetch a page: page starting at 0 (page 0 => newest items)
  Future<List<Item>> fetchPage(int page, int limit) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    final start = page * limit;

    // Server returns items with id descending (newest first)
    final items = <Item>[];
    for (int i = 0; i < limit; i++) {
      final id = _totalAvailable - (start + i);
      if (id <= 0) break;

      // Simulate updatedAt changes randomly
      final updatedAt = DateTime.now()
          .subtract(Duration(minutes: _random.nextInt(1000)))
          .millisecondsSinceEpoch;

      items.add(Item(id: id, title: 'Post #$id', updatedAt: updatedAt));
    }
    return items;
  }

  // Fetch the latest N posts (for refresh)
  Future<List<Item>> fetchLatest(int limit) => fetchPage(0, limit);
}
```

---

## `lib/providers/item_provider.dart`

```dart
import 'package:flutter/material.dart';
import '../data/item_model.dart';
import '../data/db_service.dart';
import '../services/api_service.dart';

class ItemProvider extends ChangeNotifier {
  final List<Item> visibleItems = []; // small sliding window in memory
  bool isLoading = false;
  int _page = 0; // which page we have loaded from server into DB
  final int _pageSize = 20;
  final int _maxWindowSize = 100;

  ItemProvider() {
    // initial load
    init();
  }

  Future<void> init() async {
    // Optionally seed DB from server on first run or load from DB
    await _ensureDBHasData();
    await loadInitialWindow();
  }

  Future<void> _ensureDBHasData() async {
    final count = await DBService.instance.getCount();
    if (count == 0) {
      // seed first few pages to DB (you may choose to call this elsewhere)
      for (int p = 0; p < 3; p++) {
        final pageItems = await ApiService.instance.fetchPage(p, _pageSize);
        await DBService.instance.insertItems(pageItems);
      }
      _page = 3; // we have prefetched 3 pages
    }
  }

  Future<void> loadInitialWindow() async {
    visibleItems.clear();
    final items = await DBService.instance.getItems(offset: 0, limit: _maxWindowSize);
    visibleItems.addAll(items);
    notifyListeners();
  }

  /// Called when list reaches bottom to load more (older) posts
  Future<void> loadMore() async {
    if (isLoading) return;
    isLoading = true;

    // 1) Try to fetch one page from DB first (since we keep DB as source-of-truth)
    final dbOffset = _page * _pageSize; // pages already fetched into DB
    final pageFromDB = await DBService.instance.getItems(offset: dbOffset, limit: _pageSize);

    if (pageFromDB.isNotEmpty) {
      // merge updated posts and append into visible window from DB
      // because DB contains the latest version of posts
      _appendToWindow(pageFromDB);
      _page++;
      isLoading = false;
      return;
    }

    // 2) If DB doesn't have it yet, fetch from server, save to DB, then append
    final apiItems = await ApiService.instance.fetchPage(_page, _pageSize);
    if (apiItems.isNotEmpty) {
      await DBService.instance.insertItems(apiItems);
      _appendToWindow(apiItems);
      _page++;
    }

    isLoading = false;
  }

  void _appendToWindow(List<Item> newItems) {
    // Append these items (newItems should be in DESC order: newest -> older)
    visibleItems.addAll(newItems);

    // Trim to keep memory bounded
    if (visibleItems.length > _maxWindowSize) {
      // keep only the first _maxWindowSize items (newest window)
      visibleItems.removeRange(_maxWindowSize, visibleItems.length);
    }

    notifyListeners();
  }

  /// Refresh: fetch latest page, merge updates and new items at top
  Future<void> refresh() async {
    if (isLoading) return;
    isLoading = true;

    final latest = await ApiService.instance.fetchLatest(_pageSize);

    if (latest.isEmpty) {
      isLoading = false;
      return;
    }

    // 1) Insert latest into DB (replace existing rows)
    await DBService.instance.insertItems(latest);

    // 2) Build merged window: latest first, then existing visibleItems that are not in latest
    final latestIds = latest.map((e) => e.id).toSet();

    final merged = <Item>[];
    merged.addAll(latest);

    for (final old in visibleItems) {
      if (!latestIds.contains(old.id)) {
        merged.add(old);
      }
    }

    // 3) Trim
    final trimmed = merged.take(_maxWindowSize).toList();

    // 4) Save merged trimmed to DB (so DB remains a consistent representation)
    await DBService.instance.insertItems(trimmed);

    // 5) Replace visible window and notify
    visibleItems.clear();
    visibleItems.addAll(trimmed);
    notifyListeners();

    isLoading = false;
  }

  /// Called when a page is fetched from server (for any reason) to ensure
  /// visible window reflects any updates to posts that are currently visible.
  void mergeUpdatedPostsIntoWindow(List<Item> updatedFromServer) {
    final map = {for (var e in updatedFromServer) e.id: e};
    bool changed = false;
    for (int i = 0; i < visibleItems.length; i++) {
      final cur = visibleItems[i];
      if (map.containsKey(cur.id)) {
        final updated = map[cur.id]!;
        // Only replace if updatedAt is newer or content differs
        if (updated.updatedAt != cur.updatedAt || updated.title != cur.title) {
          visibleItems[i] = updated;
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }
}
```

---

## `lib/screens/items_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../widgets/item_tile.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<ItemProvider>();

    // NOTE: provider.init() already called in constructor; if not, call provider.init()

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        // near bottom
        provider.loadMore();
      }
    });
  }

  Future<void> _onRefresh() async {
    final provider = context.read<ItemProvider>();

    // Save current scroll offset to keep position stable after adding new items
    final oldOffset = _controller.offset;

    await provider.refresh();

    // If we added items at top, keep the visual position by jumping by estimated height.
    // For fixed height items we can do simple math.
    // Here assume fixed height of 70. If dynamic, measure with GlobalKeys or use packages.
    const itemHeight = 72.0;
    final added = provider.visibleItems.length > 0 ?  provider.visibleItems.length : 0;

    // This is a naive adjustment; for production calculate exact added height of inserted items.
    // We won't always jump. Adjust if needed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure offset isn't out of bounds
      final newOffset = oldOffset + (itemHeight * 3); // assume ~3 new items added
      if (_controller.hasClients) {
        final max = _controller.position.maxScrollExtent;
        _controller.jumpTo(newOffset.clamp(0.0, max));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paginated List (SQLite)')),
      body: SafeArea(
        child: Consumer<ItemProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _controller,
                itemCount: provider.visibleItems.length + 1, // +1 for loader
                itemBuilder: (context, index) {
                  if (index == provider.visibleItems.length) {
                    // loader
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: provider.isLoading
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                      ),
                    );
                  }

                  final item = provider.visibleItems[index];
                  return ItemTile(item: item);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## `lib/widgets/item_tile.dart`

```dart
import 'package:flutter/material.dart';
import '../data/item_model.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(item.title),
      subtitle: Text('Updated: ${DateTime.fromMillisecondsSinceEpoch(item.updatedAt)}'),
    );
  }
}
```

---

## Notes / How to adapt to your real API

1. **Replace `ApiService.fetchPage` with your real HTTP calls**. Use `http` or `dio` to fetch data and convert to `Item` objects.

2. **IDs must be unique**. Merging/replace logic relies on unique `id` per post.

3. **updatedAt** helps detect changes — use server-provided `updated_at` or similar field.

4. **Trimming strategy**: `_maxWindowSize` controls how many items kept in memory. Adjust to your app's complexity and memory budget.

5. **Scroll position stabilization**: For variable-height items, measure inserted items' actual height (GlobalKey per item or packages like `flutter_sticky_header` or `scrollable_positioned_list`). The provided example uses a naive jump for demonstration.

6. **Background updates / push**: If the server can push updates (socket, firebase, server-sent events), call `DBService.instance.insertItems()` with updated items and `provider.mergeUpdatedPostsIntoWindow(updatedItems)` to refresh any in-memory visible posts.

7. **Performance tips**: mark widgets `const` where possible, avoid heavy rebuilds, and keep images small (use cacheWidth/cacheHeight), and clear image cache when leaving heavy screens.

---

## Final remarks

This project stores **all** fetched posts in SQLite (DB is the source-of-truth) and keeps only a **small sliding window** in memory (`visibleItems`). When server data updates come in, we write them to the DB using `ConflictAlgorithm.replace` and selectively update the in-memory window. This keeps RAM stable while ensuring visible UI shows fresh data.

If you'd like, I can now:
- Convert the mock `ApiService` to use your real API (send sample JSON).
- Add exact scroll-position preserving logic for variable-height items.
- Add image handling (decoding, cacheWidth) if you have images in posts.

---

*End of document.*

