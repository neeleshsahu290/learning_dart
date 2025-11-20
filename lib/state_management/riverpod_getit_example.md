
# Riverpod + GetIt Example (Dependency Injection + State Management)

This example demonstrates using **Riverpod** for reactive state management and **GetIt** for dependency injection.

---

## 📌 1. Add Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0
  get_it: ^7.6.0
```

---

## 📌 2. Setup GetIt

`service_locator.dart`

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<CounterRepository>(() => CounterRepository());
}
```

---

## 📌 3. Create Repository

`counter_repository.dart`

```dart
class CounterRepository {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
  }

  void reset() {
    _value = 0;
  }
}
```

---

## 📌 4. Riverpod Providers (reading GetIt)

`counter_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_locator.dart';
import 'counter_repository.dart';

final counterProvider = StateNotifierProvider<CounterController, int>((ref) {
  final repo = getIt<CounterRepository>();       // DI from GetIt
  return CounterController(repo);
});

class CounterController extends StateNotifier<int> {
  final CounterRepository repository;

  CounterController(this.repository) : super(repository.value);

  void increment() {
    repository.increment();
    state = repository.value;
  }

  void reset() {
    repository.reset();
    state = repository.value;
  }
}
```

---

## 📌 5. Main Entry Point

`main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service_locator.dart';
import 'home_page.dart';

void main() {
  setupLocator();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
```

---

## 📌 6. UI Example

`home_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Riverpod + GetIt Example")),
      body: Center(
        child: Text(
          "Count: $count",
          style: TextStyle(fontSize: 26),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "inc",
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 15),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => ref.read(counterProvider.notifier).reset(),
            child: Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
```

---

## 🎉 Done!

This structure is clean & production-ready.

