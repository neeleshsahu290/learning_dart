
# Flutter Background Execution — Complete Guide  
Includes full examples for:

- Isolate  
- compute()  
- Background Service  
- Notifications  
- Foreground Service  
- Background Geolocation  
- WorkManager background tasks  
- Uploading files in background  
- Background location tracking  
- Retries + Exponential Backoff  
- Data Sync Service  

---

## 1️⃣ ISOLATE — Manual Background Thread

```dart
import 'dart:isolate';

class HeavyTaskIsolate {
  static Future<int> run(int input) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_entryPoint, receivePort.sendPort);
    final sendPort = await receivePort.first as SendPort;

    final response = ReceivePort();
    sendPort.send([input, response.sendPort]);
    return await response.first as int;
  }

  static void _entryPoint(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((msg) {
      final number = msg[0] as int;
      final reply = msg[1] as SendPort;

      int result = 0;
      for (int i = 0; i < 50000000; i++) {
        result += number;
      }

      reply.send(result);
    });
  }
}
```

---

## 2️⃣ compute() — Simple Background Worker

```dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

List<dynamic> parseJson(String jsonStr) => jsonDecode(jsonStr);

final result = await compute(parseJson, '[1,2,3]');
```

---

## 3️⃣ Background Service (flutter_background_service)

```dart
import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.start();
}

void onStart(ServiceInstance service) {
  Timer.periodic(const Duration(seconds: 5), (_) {
    service.invoke("update", {"time": DateTime.now().toString()});
  });
}
```

---

## 4️⃣ Notifications (Flutter Local Notifications)

```dart
final FlutterLocalNotificationsPlugin notifications = 
    FlutterLocalNotificationsPlugin();

await notifications.initialize(
  InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  ),
);

await notifications.show(
  1,
  "Background Task",
  "Task completed",
  NotificationDetails(
    android: AndroidNotificationDetails('channel_1', 'Background'),
  ),
);
```

---

## 5️⃣ Foreground Service (Android)

```dart
AndroidConfiguration(
  onStart: onStart,
  autoStart: true,
  isForegroundMode: true,
  initialNotificationTitle: "Service Running",
  initialNotificationContent: "Tracking in background...",
)
```

---

## 6️⃣ Background Geolocation

```dart
import 'package:geolocator/geolocator.dart';

void trackLocation() {
  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ),
  ).listen((pos) {
    print("Lat: ${pos.latitude}, Lng: ${pos.longitude}");
  });
}
```

---

## 7️⃣ WorkManager Background Tasks (Android)

```yaml
workmanager: ^0.5.0
```

```dart
void callbackDispatcher() {
  Workmanager().executeTask((task, input) async {
    print("Background Task Running: $task");
    return Future.value(true);
  });
}

void main() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "syncTask",
    "dataSync",
    frequency: const Duration(minutes: 15),
  );
}
```

---

## 8️⃣ Uploading Files in the Background

```dart
import 'package:http/http.dart' as http;
import 'dart:io';

Future<void> uploadFile(String path) async {
  final file = File(path);
  final req = http.MultipartRequest(
    "POST",
    Uri.parse("https://api.example.com/upload"),
  );
  req.files.add(await http.MultipartFile.fromPath("file", path));
  await req.send();
}
```

---

## 9️⃣ Background Location Tracking + Upload

```dart
Geolocator.getPositionStream().listen((pos) async {
  await uploadLocation(pos.latitude, pos.longitude);
});
```

---

## 🔟 Retries + Exponential Backoff

```dart
Future<T> retry<T>(Future<T> Function() task,
    {int retries = 5}) async {
  int attempt = 0;

  while (attempt < retries) {
    try {
      return await task();
    } catch (e) {
      await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
      attempt++;
    }
  }
  throw Exception("Max retries reached");
}
```

---

## 1️⃣1️⃣ Data Sync Service

```dart
Future<void> syncData() async {
  final unsynced = await localDb.getUnsyncedRecords();

  for (final record of unsynced) {
    try {
      await api.upload(record);
      await localDb.markSynced(record.id);
    } catch (_) {}
  }
}
```

```dart
Workmanager().registerPeriodicTask(
  "dataSyncTask",
  "syncData",
  frequency: const Duration(minutes: 15),
);
```

---

# 🎉 COMPLETE GUIDE  
This `.md` contains full Flutter background execution examples.
