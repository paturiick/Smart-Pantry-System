import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:animated_background/animated_background.dart';
import 'package:smart_pantry/constants/colors.dart';
import 'package:smart_pantry/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late List<_FloatingIcon> icons;

  final Color primaryColor = const Color(0xFF00695C); // More vivid teal
  final Color bgColor = const Color(0xFFE0F2F1); // Modern minty background

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.HOMEPAGE);
    });

    icons = List.generate(10, (index) => _FloatingIcon(vsync: this));
    for (final icon in icons) {
      icon.controller.forward();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    for (final icon in icons) {
      icon.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Particle background
          Positioned.fill(
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                options: ParticleOptions(
                  baseColor: Colors.tealAccent.shade400,
                  spawnOpacity: 0.15,
                  opacityChangeRate: 0.01,
                  minOpacity: 0.05,
                  maxOpacity: 0.25,
                  spawnMinSpeed: 3.0,
                  spawnMaxSpeed: 8.0,
                  spawnMinRadius: 4.0,
                  spawnMaxRadius: 12.0,
                  particleCount: 40,
                ),
              ),
              vsync: this,
              child: const SizedBox.expand(),
            ),
          ),

          // Floating icons
          ...icons.map((icon) => icon.build(context)),

          // Decorative wave
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipperOne(reverse: true, flip: true),
              child: Container(
                height: 120,
                color: const Color(0xFFFFECB3).withOpacity(0.5), // soft gold
              ),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB2DFDB),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: primaryColor,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Smart Pantry System',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  AppColors.Mint
];
