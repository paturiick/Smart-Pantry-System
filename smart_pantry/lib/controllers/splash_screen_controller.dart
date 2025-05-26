import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_pantry/constants/colors.dart';

class SplashScreenController {
  final AnimationController mainController;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final List<_FloatingIcon> icons;

  // ✅ Define these so SplashScreen can access them
  final Color primaryColor = const Color(0xFF00695C);
  final Color bgColor = const Color(0xFFE0F2F1);

  SplashScreenController({required TickerProvider vsync})
      : mainController = AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 1500),
        ),
        scaleAnimation = CurvedAnimation(
          parent: AnimationController(
            vsync: vsync,
            duration: const Duration(milliseconds: 1500),
          )..forward(),
          curve: Curves.elasticOut,
        ),
        fadeAnimation = CurvedAnimation(
          parent: AnimationController(
            vsync: vsync,
            duration: const Duration(milliseconds: 1500),
          )..forward(),
          curve: Curves.easeIn,
        ),
        icons = List.generate(10, (index) => _FloatingIcon(vsync: vsync)) {
    mainController.forward();
  }

  void dispose() {
    mainController.dispose();
    for (final icon in icons) {
      icon.controller.dispose();
    }
  }
}

// Floating icon class (can be in a separate file if reused)
class _FloatingIcon {
  final AnimationController controller;
  final Animation<double> animation;
  final double left;
  final IconData icon;
  final double size;
  final Color color;

  _FloatingIcon({required TickerProvider vsync})
      : controller = AnimationController(
          vsync: vsync,
          duration: Duration(milliseconds: 4000 + Random().nextInt(3000)),
        ),
        left = Random().nextDouble() * 300,
        icon = _icons[Random().nextInt(_icons.length)],
        size = 24 + Random().nextDouble() * 20,
        color = _iconColors[Random().nextInt(_iconColors.length)],
        animation = Tween<double>(begin: 1.2, end: -0.2).animate(
          CurvedAnimation(
            parent: AnimationController(
              vsync: vsync,
              duration: Duration(milliseconds: 4000 + Random().nextInt(3000)),
            ),
            curve: Curves.easeInOut,
          ),
        ) {
    controller.repeat(reverse: false);
  }

  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Positioned(
          top: MediaQuery.of(context).size.height * animation.value,
          left: left,
          child: Opacity(
            opacity: 0.2,
            child: Icon(icon, size: size, color: color),
          ),
        );
      },
    );
  }
}

const List<IconData> _icons = [
  Icons.fastfood,
  Icons.local_grocery_store,
  Icons.rice_bowl,
  Icons.kitchen,
  Icons.eco,
  Icons.cookie,
];

const List<Color> _iconColors = [
  AppColors.Aqua,
  AppColors.SoftCoral,
  AppColors.Teal,
  AppColors.YellowAccent,
  AppColors.Mint,
];
