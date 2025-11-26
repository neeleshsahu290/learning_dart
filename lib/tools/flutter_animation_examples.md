
# Flutter Animation Examples  
Complete reference for these animations:

- Rotation Animation  
- Scale Animation  
- Opacity Animation  
- Color Tween  
- Multi-Tween  
- Lottie + AnimationController  
- Slide Transition  
- Hero Animation  

---

# 1️⃣ Rotation Animation

```dart
import 'package:flutter/material.dart';

class RotationAnimationExample extends StatefulWidget {
  const RotationAnimationExample({super.key});

  @override
  State<RotationAnimationExample> createState() =>
      _RotationAnimationExampleState();
}

class _RotationAnimationExampleState extends State<RotationAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _rotation = Tween<double>(begin: 0, end: 6.28).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rotation Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: _rotation,
          builder: (_, child) {
            return Transform.rotate(
              angle: _rotation.value,
              child: child,
            );
          },
          child: const Icon(Icons.refresh, size: 100, color: Colors.blue),
        ),
      ),
    );
  }
}
```

---

# 2️⃣ Scale Animation

```dart
import 'package:flutter/material.dart';

class ScaleAnimationExample extends StatefulWidget {
  const ScaleAnimationExample({super.key});

  @override
  State<ScaleAnimationExample> createState() => _ScaleAnimationExampleState();
}

class _ScaleAnimationExampleState extends State<ScaleAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _scale = Tween<double>(begin: 0.2, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scale Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) {
            return Transform.scale(
              scale: _scale.value,
              child: child,
            );
          },
          child: const FlutterLogo(size: 120),
        ),
      ),
    );
  }
}
```

---

# 3️⃣ Opacity Animation

```dart
import 'package:flutter/material.dart';

class OpacityAnimationExample extends StatefulWidget {
  const OpacityAnimationExample({super.key});

  @override
  State<OpacityAnimationExample> createState() =>
      _OpacityAnimationExampleState();
}

class _OpacityAnimationExampleState extends State<OpacityAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Opacity Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: _opacity,
          builder: (_, child) {
            return Opacity(
              opacity: _opacity.value,
              child: child,
            );
          },
          child: const Text("Hello Flutter!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
```

---

# 4️⃣ Color Tween Animation

```dart
import 'package:flutter/material.dart';

class ColorTweenExample extends StatefulWidget {
  const ColorTweenExample({super.key});

  @override
  State<ColorTweenExample> createState() => _ColorTweenExampleState();
}

class _ColorTweenExampleState extends State<ColorTweenExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _colorAnim =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Color Tween Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: _colorAnim,
          builder: (_, child) {
            return Container(
              width: 150,
              height: 150,
              color: _colorAnim.value,
            );
          },
        ),
      ),
    );
  }
}
```

---

# 5️⃣ Multi Tween Animations

```dart
import 'package:flutter/material.dart';

class MultiTweenExample extends StatefulWidget {
  const MultiTweenExample({super.key});

  @override
  State<MultiTweenExample> createState() => _MultiTweenExampleState();
}

class _MultiTweenExampleState extends State<MultiTweenExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> rotateAnim;
  late Animation<double> scaleAnim;
  late Animation<double> opacityAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    rotateAnim = Tween<double>(begin: 0, end: 6.28).animate(_controller);
    scaleAnim = Tween<double>(begin: 0.3, end: 1).animate(_controller);
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multi-Tween Animation")),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Opacity(
              opacity: opacityAnim.value,
              child: Transform.scale(
                scale: scaleAnim.value,
                child: Transform.rotate(
                  angle: rotateAnim.value,
                  child: child,
                ),
              ),
            );
          },
          child: const Icon(Icons.star, size: 100, color: Colors.orange),
        ),
      ),
    );
  }
}
```

---

# 6️⃣ Lottie + AnimationController

```dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationExample extends StatefulWidget {
  const LottieAnimationExample({super.key});

  @override
  State<LottieAnimationExample> createState() => _LottieAnimationExampleState();
}

class _LottieAnimationExampleState extends State<LottieAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lottie + AnimationController")),
      body: Center(
        child: Lottie.asset(
          'assets/animation.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
      ),
    );
  }
}
```

---

# 7️⃣ Slide Transition Animation

```dart
import 'package:flutter/material.dart';

class SlideTransitionExample extends StatefulWidget {
  const SlideTransitionExample({super.key});

  @override
  State<SlideTransitionExample> createState() => _SlideTransitionExampleState();
}

class _SlideTransitionExampleState extends State<SlideTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    slideAnim = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Slide Transition")),
      body: Center(
        child: SlideTransition(
          position: slideAnim,
          child: Container(
            width: 150,
            height: 150,
            color: Colors.purple,
            child: const Center(
                child: Text("Sliding",
                    style: TextStyle(color: Colors.white, fontSize: 20))),
          ),
        ),
      ),
    );
  }
}
```

---

# 8️⃣ Hero Animation

### Page 1

```dart
import 'package:flutter/material.dart';

class HeroPage1 extends StatelessWidget {
  const HeroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero Page 1")),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HeroPage2()));
          },
          child: Hero(
            tag: "hero-image",
            child: Image.asset("assets/image.png", width: 120),
          ),
        ),
      ),
    );
  }
}
```

---

### Page 2

```dart
import 'package:flutter/material.dart';

class HeroPage2 extends StatelessWidget {
  const HeroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero Page 2")),
      body: Center(
        child: Hero(
          tag: "hero-image",
          child: Image.asset("assets/image.png", width: 250),
        ),
      ),
    );
  }
}
```

---

# 🎉 Completed  
This file contains **all 8 animation examples** with clean formatting.

