
# Theme Manager + SharedPreferences + GetIt + Provider  
### Complete Example with Theme Selection Screen

This document contains a full Flutter implementation of:

- ✅ Singleton `ThemeManager`
- ✅ GetIt Dependency Injection
- ✅ SharedPreferences theme persistence
- ✅ Provider (ChangeNotifier) for UI updates
- ✅ Theme selection screen with Light & Dark themes

---

## 📌 1. Add Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  get_it: ^7.6.0
  shared_preferences: ^2.2.0
```

---

## 📌 2. ThemeManager (Singleton + SharedPreferences)
**theme_manager.dart**

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  ThemeManager._private();

  static final ThemeManager _instance = ThemeManager._private();
  static ThemeManager get instance => _instance;

  bool isDarkMode = false;
  static const themeKey = "isDarkTheme";

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(themeKey) ?? false;
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, isDark);
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      );

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    await saveTheme(isDarkMode);
  }

  Future<void> setTheme(bool dark) async {
    isDarkMode = dark;
    await saveTheme(dark);
  }
}
```

---

## 📌 3. GetIt Setup
**service_locator.dart**

```dart
import 'package:get_it/get_it.dart';
import 'theme_manager.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton<ThemeManager>(() => ThemeManager.instance);
  await sl<ThemeManager>().loadTheme();
}
```

---

## 📌 4. ThemeNotifier (Provider)
**theme_notifier.dart**

```dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'theme_manager.dart';

class ThemeNotifier extends ChangeNotifier {
  final ThemeManager themeManager = GetIt.I<ThemeManager>();

  ThemeData get theme => themeManager.currentTheme;

  Future<void> selectLightTheme() async {
    await themeManager.setTheme(false);
    notifyListeners();
  }

  Future<void> selectDarkTheme() async {
    await themeManager.setTheme(true);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    await themeManager.toggleTheme();
    notifyListeners();
  }
}
```

---

## 📌 5. Main App File
**main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service_locator.dart';
import 'theme_notifier.dart';
import 'themes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.theme,
      home: const ThemesScreen(),
    );
  }
}
```

---

## 📌 6. Themes Screen  
**themes_screen.dart**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Theme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _themeCard(
              context: context,
              title: "Light Theme",
              icon: Icons.wb_sunny,
              isSelected: !isDark,
              onTap: () => themeNotifier.selectLightTheme(),
            ),
            const SizedBox(height: 20),
            _themeCard(
              context: context,
              title: "Dark Theme",
              icon: Icons.nightlight_round,
              isSelected: isDark,
              onTap: () => themeNotifier.selectDarkTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 20)),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 28),
          ],
        ),
      ),
    );
  }
}
```

---

# 🎉 DONE!

Your theme now:

✔ Saves using SharedPreferences  
✔ Loads on app start  
✔ Updates instantly using Provider  
✔ Managed with GetIt DI  
✔ Has a beautiful Light/Dark selection screen  

If you'd like a **PDF / DOCX / ZIP Flutter project**, tell me!

