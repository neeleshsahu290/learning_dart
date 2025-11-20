# Provider + GetIt (Dependency Injection + State Management)

This example demonstrates how to combine **Provider** for state
management and **GetIt** for dependency injection in Flutter.

------------------------------------------------------------------------

## 📌 1. pubspec.yaml

``` yaml
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2
  get_it: ^7.6.0
  dio: ^5.0.0
```

------------------------------------------------------------------------

## 📌 2. Service Locator (GetIt)

**lib/service_locator.dart**

``` dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'repository/todo_repository.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    sl.registerLazySingleton<Dio>(() => Dio(
          BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com"),
        ));

    sl.registerLazySingleton<TodoRepository>(
      () => TodoRepositoryImpl(sl()),
    );
  }
}
```

------------------------------------------------------------------------

## 📌 3. Repository Layer

**lib/repository/todo_repository.dart**

``` dart
import 'package:dio/dio.dart';

abstract class TodoRepository {
  Future<List<String>> fetchTodos();
}

class TodoRepositoryImpl implements TodoRepository {
  final Dio dio;

  TodoRepositoryImpl(this.dio);

  @override
  Future<List<String>> fetchTodos() async {
    final response = await dio.get("/todos");

    return (response.data as List)
        .map((e) => e["title"].toString())
        .toList();
  }
}
```

------------------------------------------------------------------------

## 📌 4. Provider (ChangeNotifier)

**lib/providers/todo_provider.dart**

``` dart
import 'package:flutter/foundation.dart';
import '../repository/todo_repository.dart';

class TodoProvider extends ChangeNotifier {
  final TodoRepository repository;

  TodoProvider(this.repository);

  bool loading = false;
  List<String> todos = [];
  String? error;

  Future<void> loadTodos() async {
    loading = true;
    notifyListeners();

    try {
      todos = await repository.fetchTodos();
      error = null;
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
```

------------------------------------------------------------------------

## 📌 5. UI Screen

**lib/screens/todo_screen.dart**

``` dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Provider + GetIt Example")),

      body: Center(
        child: () {
          if (provider.loading) return CircularProgressIndicator();

          if (provider.error != null) {
            return Text("Error: ${provider.error}");
          }

          if (provider.todos.isEmpty) {
            return const Text("No items loaded");
          }

          return ListView.builder(
            itemCount: provider.todos.length,
            itemBuilder: (_, i) => ListTile(title: Text(provider.todos[i])),
          );
        }(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TodoProvider>().loadTodos(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

------------------------------------------------------------------------

## 📌 6. Main Entry (Provider + GetIt combined)

**lib/main.dart**

``` dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service_locator.dart';
import 'providers/todo_provider.dart';
import 'repository/todo_repository.dart';
import 'screens/todo_screen.dart';

void main() {
  ServiceLocator.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            sl<TodoRepository>(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(),
    );
  }
}
```

------------------------------------------------------------------------

## 🎉 Summary

This architecture provides:

-   Clean separation of concerns\
-   Dependency Injection using GetIt\
-   State management using Provider\
-   Simple async data loading\
-   Scalable structure

Perfect for small to medium apps or transitioning into MVVM.
