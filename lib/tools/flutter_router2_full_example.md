
# Flutter Router 2.0 – Complete Example  
### With Bottom Navigation + Tab Bar + Deep Linking

This file contains the **complete code** for a full navigation architecture using:

- Router 2.0  
- Bottom Navigation  
- TabBar inside Home  
- Login → Main → Details workflow  
- Deep linking  
- Nested routing  
- Back button support  

---

# 📁 Project Structure

```
lib/
 ├─ app_router.dart
 ├─ main.dart
 ├─ screens/
 │    ├─ login_screen.dart
 │    ├─ main_shell.dart
 │    ├─ home/
 │    │    ├─ home_screen.dart
 │    │    ├─ tab_one.dart
 │    │    └─ tab_two.dart
 │    ├─ profile_screen.dart
 │    ├─ settings_screen.dart
 │    ├─ about_screen.dart
 │    ├─ details_screen.dart
 │    └─ not_found_screen.dart
```

---

# 🧩 main.dart

```dart
import 'package:flutter/material.dart';
import 'app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: AppRouteParser(),
      routerDelegate: AppRouterDelegate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

# 🧩 app_router.dart

## AppRoutePath Model

```dart
class AppRoutePath {
  final bool isLogin;
  final int? detailsId;

  final int? bottomTabIndex; 
  final int? homeTabIndex;   

  AppRoutePath.login()
      : isLogin = true,
        detailsId = null,
        bottomTabIndex = null,
        homeTabIndex = null;

  AppRoutePath.home({this.homeTabIndex = 0})
      : isLogin = false,
        detailsId = null,
        bottomTabIndex = 0;

  AppRoutePath.profile()
      : isLogin = false,
        detailsId = null,
        bottomTabIndex = 1,
        homeTabIndex = null;

  AppRoutePath.settings()
      : isLogin = false,
        detailsId = null,
        bottomTabIndex = 2,
        homeTabIndex = null;

  AppRoutePath.about()
      : isLogin = false,
        detailsId = null,
        bottomTabIndex = 3,
        homeTabIndex = null;

  AppRoutePath.details(this.detailsId)
      : isLogin = false,
        bottomTabIndex = null,
        homeTabIndex = null;

  AppRoutePath.unknown()
      : isLogin = false,
        detailsId = null,
        bottomTabIndex = null,
        homeTabIndex = null;
}
```

---

## RouteInformationParser

```dart
class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInfo) async {
    final uri = Uri.parse(routeInfo.location ?? '');

    if (uri.pathSegments.isEmpty) return AppRoutePath.login();

    final path = uri.pathSegments;

    if (path[0] == "login") return AppRoutePath.login();

    if (path[0] == "home") {
      if (path.length == 2) {
        int tabIndex = int.tryParse(path[1].replaceAll("tab", "")) ?? 0;
        return AppRoutePath.home(homeTabIndex: tabIndex);
      }
      return AppRoutePath.home(homeTabIndex: 0);
    }

    if (path[0] == "profile") return AppRoutePath.profile();
    if (path[0] == "settings") return AppRoutePath.settings();
    if (path[0] == "about") return AppRoutePath.about();

    if (path[0] == "details" && path.length == 2) {
      return AppRoutePath.details(int.tryParse(path[1]));
    }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath config) {
    if (config.isLogin) return const RouteInformation(location: '/login');

    if (config.bottomTabIndex == 0) {
      return RouteInformation(location: "/home/tab${config.homeTabIndex ?? 0}");
    }
    if (config.bottomTabIndex == 1) return const RouteInformation(location: '/profile');
    if (config.bottomTabIndex == 2) return const RouteInformation(location: '/settings');
    if (config.bottomTabIndex == 3) return const RouteInformation(location: '/about');

    if (config.detailsId != null) {
      return RouteInformation(location: '/details/${config.detailsId}');
    }

    return const RouteInformation(location: '/404');
  }
}
```

---

## RouterDelegate

```dart
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  bool loggedIn = false;

  int bottomIndex = 0;
  int homeTabIndex = 0;
  int? detailsId;
  bool is404 = false;

  @override
  AppRoutePath get currentConfiguration {
    if (!loggedIn) return AppRoutePath.login();
    if (detailsId != null) return AppRoutePath.details(detailsId);
    if (is404) return AppRoutePath.unknown();

    switch (bottomIndex) {
      case 0:
        return AppRoutePath.home(homeTabIndex: homeTabIndex);
      case 1:
        return AppRoutePath.profile();
      case 2:
        return AppRoutePath.settings();
      case 3:
        return AppRoutePath.about();
    }
    return AppRoutePath.unknown();
  }

  @override
  Widget build(BuildContext context) {
    List<Page> stack = [];

    if (!loggedIn) {
      stack.add(MaterialPage(
        child: LoginScreen(onLogin: () {
          loggedIn = true;
          notifyListeners();
        }),
      ));
    } else {
      stack.add(MaterialPage(
        key: const ValueKey("MainShell"),
        child: MainShell(
          currentIndex: bottomIndex,
          homeTabIndex: homeTabIndex,
          onSelectTab: (i) {
            bottomIndex = i;
            notifyListeners();
          },
          onSelectHomeTab: (i) {
            homeTabIndex = i;
            notifyListeners();
          },
          onSelectItem: (id) {
            detailsId = id;
            notifyListeners();
          },
        ),
      ));

      if (detailsId != null) {
        stack.add(MaterialPage(
          child: DetailsScreen(
            id: detailsId!,
            onBack: () {
              detailsId = null;
              notifyListeners();
            },
          ),
        ));
      }

      if (is404) {
        stack.add(const MaterialPage(child: NotFoundScreen()));
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        detailsId = null;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath config) async {
    if (config.isLogin) {
      loggedIn = false;
      detailsId = null;
      return;
    }

    loggedIn = true;

    if (config.detailsId != null) {
      detailsId = config.detailsId;
      return;
    }

    if (config.bottomTabIndex != null) {
      bottomIndex = config.bottomTabIndex!;
      homeTabIndex = config.homeTabIndex ?? 0;
      detailsId = null;
      return;
    }

    is404 = true;
  }
}
```

---

# 🧩 main_shell.dart  
### Bottom Navigation + Routing

```dart
class MainShell extends StatelessWidget {
  final int currentIndex;
  final int homeTabIndex;
  final Function(int) onSelectTab;
  final Function(int) onSelectHomeTab;
  final Function(int) onSelectItem;

  const MainShell({
    super.key,
    required this.currentIndex,
    required this.homeTabIndex,
    required this.onSelectTab,
    required this.onSelectHomeTab,
    required this.onSelectItem,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (currentIndex) {
      case 0:
        body = HomeScreen(
          tabIndex: homeTabIndex,
          onTabChange: onSelectHomeTab,
          onItemSelected: onSelectItem,
        );
        break;
      case 1:
        body = const ProfileScreen();
        break;
      case 2:
        body = const SettingsScreen();
        break;
      case 3:
        body = const AboutScreen();
        break;
      default:
        body = const NotFoundScreen();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onSelectTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}
```

---

# 🧩 Home with TabBar — home_screen.dart

```dart
class HomeScreen extends StatelessWidget {
  final int tabIndex;
  final Function(int) onTabChange;
  final Function(int) onItemSelected;

  const HomeScreen({
    super.key,
    required this.tabIndex,
    required this.onTabChange,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          bottom: TabBar(
            onTap: onTabChange,
            tabs: const [
              Tab(text: "Tab 1"),
              Tab(text: "Tab 2"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TabOne(onItemSelected: onItemSelected),
            const TabTwo(),
          ],
        ),
      ),
    );
  }
}
```

---

# 🧩 tab_one.dart

```dart
class TabOne extends StatelessWidget {
  final Function(int) onItemSelected;

  const TabOne({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text("Item ${index + 1}"),
          onTap: () => onItemSelected(index + 1),
        );
      },
    );
  }
}
```

---

# 🧩 tab_two.dart

```dart
class TabTwo extends StatelessWidget {
  const TabTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Tab Two Content"));
  }
}
```

---

# 🧩 login_screen.dart

```dart
class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: onLogin,
          child: const Text("Login"),
        ),
      ),
    );
  }
}
```

---

# 🧩 profile_screen.dart

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Profile Screen")),
    );
  }
}
```

---

# 🧩 settings_screen.dart

```dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Settings Screen")),
    );
  }
}
```

---

# 🧩 about_screen.dart

```dart
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("About Screen")),
    );
  }
}
```

---

# 🧩 details_screen.dart

```dart
class DetailsScreen extends StatelessWidget {
  final int id;
  final VoidCallback onBack;

  const DetailsScreen({super.key, required this.id, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details $id"),
        leading: BackButton(onPressed: onBack),
      ),
      body: Center(
        child: Text(
          "Details for item $id",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
```

---

# 🧩 not_found_screen.dart

```dart
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("404 - Page not found", style: TextStyle(color: Colors.red, fontSize: 24)),
      ),
    );
  }
}
```

---

# 🔗 Deep Link Examples

| URL | Opens |
|------|--------|
| `/login` | Login Screen |
| `/home/tab0` | Home → Tab 1 |
| `/home/tab1` | Home → Tab 2 |
| `/profile` | Profile Screen |
| `/settings` | Settings Screen |
| `/about` | About Screen |
| `/details/5` | Details for item 5 |

---

# 🎉 COMPLETE!

This `.md` file contains the **entire Router 2.0 architecture** including:

- Bottom Navigation  
- TabBar  
- Nested Routing  
- Deep Linking  
- Login Flow  
- Details Overlay  
- 404 Support  

---

If you want, I can also generate:

📦 **A full ZIP Flutter project**  
📘 **A diagram of the navigation tree**  
🧭 **A GoRouter or Beamer version**  
