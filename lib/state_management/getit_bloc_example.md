# GetIt + BLoC + Repository Example

This is a fully working minimal example demonstrating how to use
**GetIt**, **BLoC**, **Dio**, and a clean architecture style in Flutter.

------------------------------------------------------------------------

## 📌 1. pubspec.yaml

``` yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_bloc: ^8.1.3
  get_it: ^7.6.0
  dio: ^5.0.0
```

------------------------------------------------------------------------

## 📌 2. Service Locator - GetIt

**lib/service_locator.dart**

``` dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'repository/todo_repository.dart';
import 'bloc/todo_bloc.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static void init() {
    sl.registerLazySingleton<Dio>(() => Dio(
          BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com"),
        ));

    sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

    sl.registerFactory(() => TodoBloc(sl()));
  }
}
```

------------------------------------------------------------------------

## 📌 3. Repository Layer

**lib/repository/todo_repository.dart**

``` dart
import 'package:dio/dio.dart';

abstract class TodoRepository {
  Future<List<String>> getTodos();
}

class TodoRepositoryImpl implements TodoRepository {
  final Dio dio;

  TodoRepositoryImpl(this.dio);

  @override
  Future<List<String>> getTodos() async {
    final response = await dio.get("/todos");

    return (response.data as List)
        .map((e) => e["title"].toString())
        .toList();
  }
}
```

------------------------------------------------------------------------

## 📌 4. Bloc (Events, States, Bloc)

### **todo_event.dart**

``` dart
abstract class TodoEvent {}

class LoadTodosEvent extends TodoEvent {}
```

### **todo_state.dart**

``` dart
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<String> todos;

  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);
}
```

### **todo_bloc.dart**

``` dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'todo_event.dart';
import 'todo_state.dart';
import '../repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
  }

  Future<void> _onLoadTodos(
      LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final list = await repository.getTodos();
      emit(TodoLoaded(list));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
```

------------------------------------------------------------------------

## 📌 5. Main Entry

**main.dart**

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service_locator.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'todo_screen.dart';

void main() {
  ServiceLocator.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => sl<TodoBloc>()..add(LoadTodosEvent()),
        child: TodoScreen(),
      ),
    );
  }
}
```

------------------------------------------------------------------------

## 📌 6. UI Screen

**todo_screen.dart**

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/todo_state.dart';
import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos")),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (_, i) =>
                  ListTile(title: Text(state.todos[i])),
            );
          }

          if (state is TodoError) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => 
                context.read<TodoBloc>().add(LoadTodosEvent()),
              child: Text("Load Todos"),
            ),
          );
        },
      ),
    );
  }
}
```

------------------------------------------------------------------------

## 🎉 Summary

This example demonstrates: - Dependency Injection using GetIt\
- Clean repository structure\
- Bloc architecture\
- Auto disposal through BlocProvider\
- API integration using Dio

Perfect for learning or starting a clean Flutter architecture project!
