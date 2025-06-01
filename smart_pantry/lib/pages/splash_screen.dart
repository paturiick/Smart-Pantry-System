import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:animated_background/animated_background.dart';
import 'package:smart_pantry/routes/routes.dart';
import 'package:smart_pantry/controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashScreenController _controller;

  @override
  void initState() {
    super.initState();

    _controller = SplashScreenController(vsync: this);
    _controller.mainController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, AppRoutes.HOMEPAGE);
    });

    for (final icon in _controller.icons) {
      icon.controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _controller.bgColor,
      body: Stack(
        children: [
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

          ..._controller.icons.map((icon) => icon.build(context)),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipperOne(reverse: true, flip: true),
              child: Container(
                height: 120,
                color: const Color(0xFFFFECB3).withOpacity(0.5),
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _controller.fadeAnimation,
              child: ScaleTransition(
                scale: _controller.scaleAnimation,
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
                      child: Image.asset(
                        'assets/icons/GrubGuard.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'GrubGuard',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: _controller.primaryColor,
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
