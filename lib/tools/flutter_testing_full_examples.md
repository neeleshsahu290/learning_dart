
# Flutter Testing Guide  
Complete examples for:

- ✅ Unit Tests  
- ✅ Mockito Mocking  
- ✅ API Testing (Dio / HTTP)  
- ✅ Firebase Auth Testing  
- ✅ Bloc Testing (bloc_test)  
- ✅ Provider Testing  
- ✅ Riverpod Testing  
- ✅ Widget Tests  
- ✅ Golden Tests  
- ✅ Integration Tests  

This file contains **all test types** with runnable examples.

---

# 🧪 1. UNIT TEST EXAMPLES

## **lib/calculator.dart**
```dart
class Calculator {
  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;
  int multiply(int a, int b) => a * b;

  int divide(int a, int b) {
    if (b == 0) throw Exception("Division by zero");
    return a ~/ b;
  }
}
```

## **test/unit/calculator_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/calculator.dart';

void main() {
  late Calculator calculator;

  setUp(() { calculator = Calculator(); });

  test("Addition works", () { expect(calculator.add(2, 3), 5); });
  test("Subtraction works", () { expect(calculator.subtract(10, 3), 7); });
  test("Multiplication works", () { expect(calculator.multiply(4, 5), 20); });
  test("Division throws error", () {
    expect(() => calculator.divide(5, 0), throwsException);
  });
}
```

---

# 🧪 2. MOCKITO TESTING

## pubspec.yaml
```yaml
dev_dependencies:
  mockito: ^5.4.2
  build_runner:
```

## **lib/api_service.dart**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  ApiService(this.client);

  Future<String> fetchGreeting() async {
    final res = await client.get(Uri.parse("https://api.example.com/greet"));
    if (res.statusCode == 200) {
      return jsonDecode(res.body)["message"];
    }
    throw Exception("Failed");
  }
}
```

## **test/unit/api_service_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:your_app/api_service.dart';
import 'api_service_test.mocks.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  test("API returns greeting", () async {
    final client = MockClient();
    final service = ApiService(client);

    when(client.get(Uri.parse("https://api.example.com/greet")))
        .thenAnswer((_) async =>
            http.Response('{"message":"Hello"}', 200));

    final msg = await service.fetchGreeting();
    expect(msg, "Hello");
  });
}
```

---

# 🧪 3. API TESTING USING DIO

## **lib/dio_service.dart**
```dart
import 'package:dio/dio.dart';

class DioService {
  final Dio dio;
  DioService(this.dio);

  Future<int> getUserCount() async {
    final res = await dio.get("https://api.example.com/users");
    return res.data["count"];
  }
}
```

## **test/unit/dio_service_test.dart**
```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/dio_service.dart';

class MockDio extends Fake implements Dio {
  @override
  Future<Response> get(String path) async {
    return Response(
      data: {"count": 99},
      requestOptions: RequestOptions(path: path),
    );
  }
}

void main() {
  test("Dio returns user count", () async {
    final service = DioService(MockDio());
    expect(await service.getUserCount(), 99);
  });
}
```

---

# 🔐 4. FIREBASE AUTH TESTING

### pubspec.yaml
```yaml
dev_dependencies:
  firebase_auth_mocks: ^1.2.0
```

## **lib/auth_service.dart**
```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;
  AuthService(this.auth);

  Future<User?> login(String email, String pass) async {
    final cred = await auth.signInWithEmailAndPassword(
      email: email, password: pass);
    return cred.user;
  }
}
```

## **test/unit/auth_service_test.dart**
```dart
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/auth_service.dart';

void main() {
  test("Firebase login success", () async {
    final mockAuth = MockFirebaseAuth(
      signedIn: false,
      mockUser: MockUser(email: "test@example.com"),
    );

    final service = AuthService(mockAuth);
    final user = await service.login("test@example.com", "123456");

    expect(user?.email, "test@example.com");
  });
}
```

---

# 🔥 5. BLOC TESTING (bloc_test)

## **lib/bloc/counter_bloc.dart**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Cubit<int> {
  CounterBloc() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

## **test/bloc/counter_bloc_test.dart**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/bloc/counter_bloc.dart';

void main() {
  blocTest(
    "increments",
    build: () => CounterBloc(),
    act: (bloc) => bloc.increment(),
    expect: () => [1],
  );

  blocTest(
    "decrements",
    build: () => CounterBloc(),
    act: (bloc) => bloc.decrement(),
    expect: () => [-1],
  );
}
```

---

# 🟦 6. PROVIDER TESTING

## **lib/providers/counter_provider.dart**
```dart
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int value = 0;
  void increment() {
    value++;
    notifyListeners();
  }
}
```

## **test/provider/counter_provider_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/providers/counter_provider.dart';

void main() {
  test("Provider increments", () {
    final provider = CounterProvider();
    provider.increment();
    expect(provider.value, 1);
  });
}
```

---

# 🟩 7. RIVERPOD TESTING

## **lib/riverpod/counter_notifier.dart**
```dart
import 'package:riverpod/riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  void inc() => state++;
}

final counterProvider =
    StateNotifierProvider<CounterNotifier, int>((ref) => CounterNotifier());
```

## **test/riverpod/counter_riverpod_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_test/riverpod_test.dart';
import 'package:your_app/riverpod/counter_notifier.dart';

void main() {
  riverpodTest(
    "Riverpod increments",
    provider: counterProvider,
    build: () => CounterNotifier(),
    act: (notifier) => notifier.inc(),
    expect: () => [1],
  );
}
```

---

# ⭐ 8. WIDGET TEST EXAMPLE

## **lib/screens/counter_screen.dart**
```dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("$counter", key: const Key("counter_text")),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key("increment_button"),
        onPressed: () => setState(() => counter++),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## **test/widget/counter_screen_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:your_app/screens/counter_screen.dart';

void main() {
  testWidgets("Counter increments UI", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CounterScreen()));
    await tester.tap(find.byKey(const Key("increment_button")));
    await tester.pump();
    expect(find.text("1"), findsOneWidget);
  });
}
```

---

# 🌟 9. GOLDEN TEST

## pubspec.yaml
```yaml
dev_dependencies:
  golden_toolkit: ^0.15.0
```

## **test/widget/counter_screen_golden_test.dart**
```dart
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/screens/counter_screen.dart';

void main() {
  testGoldens("CounterScreen Snapshot", (tester) async {
    await tester.pumpWidgetBuilder(const CounterScreen());
    await screenMatchesGolden(tester, "counter_screen_default");
  });
}
```

---

# 🚀 10. INTEGRATION TEST

## **integration_test/app_test.dart**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Full app flow", (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text("1"), findsOneWidget);
  });
}
```

---

# 🎉 COMPLETE TESTING SUITE ADDED!

