import 'dart:async';

import 'package:flutter/material.dart';

import 'sign_in_screen.dart';

class OneTimeSplashScreen extends StatefulWidget {
  const OneTimeSplashScreen({super.key});

  @override
  State<OneTimeSplashScreen> createState() => _OneTimeSplashScreenState();
}

class _OneTimeSplashScreenState extends State<OneTimeSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;

  late Animation<double> _crimsonDotY;
  late Animation<double> _offWhiteDotY;
  late Animation<double> _dotOpacity;

  late Animation<double> _logoScale;

  late Animation<double> _logoSlideX;
  late Animation<double> _textOpacity;

  Timer? _navigationTimer;

  static const double _finalLogoScale = 0.45;
  static const double _finalLogoSlideX = -0.25;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _crimsonDotY = Tween<double>(begin: -1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    _offWhiteDotY = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );

    _dotOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 65),
    ]).animate(_masterController);

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 25),

      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.50,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),

      TweenSequenceItem(
        tween: Tween(
          begin: 0.50,
          end: _finalLogoScale,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 15,
      ),

      TweenSequenceItem(
        tween: Tween(begin: _finalLogoScale, end: _finalLogoScale),
        weight: 35,
      ),
    ]).animate(_masterController);

    _logoSlideX = Tween<double>(begin: 0.0, end: _finalLogoSlideX).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeInOutCubic),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.75, 0.92, curve: Curves.easeIn),
      ),
    );

    _masterController.forward();

    _navigationTimer = Timer(
      const Duration(milliseconds: 4500),
      _navigateToSignIn,
    );
  }

  void _navigateToSignIn() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignInScreen(),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },

        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _masterController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF1B1B1A);
    const Color fontColor = Color(0xFFFFF4E0);
    const Color crimsonColor = Color(0xFFCD0033);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dotSize = screenWidth * 0.18;

    final double finalLogoSize = screenWidth * _finalLogoScale;

    final double finalLogoCenterX =
        (screenWidth / 2) + (_finalLogoSlideX * screenWidth);

    final double finalLogoRightEdge = finalLogoCenterX + (finalLogoSize / 2);

    final double textLeftPos = finalLogoRightEdge + 16;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: AnimatedBuilder(
        animation: _masterController,

        builder: (context, child) {
          final logoScale = _logoScale.value;
          final progress = _masterController.value;

          final double logoSize = screenWidth * logoScale;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.3,

                    colors: [Color(0xFF252524), backgroundColor],
                  ),
                ),
              ),

              if (progress < 0.35)
                Positioned(
                  left: (screenWidth - dotSize) / 2,

                  top:
                      (screenHeight / 2 - dotSize / 2) +
                      (_crimsonDotY.value * screenHeight),

                  child: Opacity(
                    opacity: _dotOpacity.value.clamp(0.0, 1.0),

                    child: Container(
                      width: dotSize,
                      height: dotSize,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: crimsonColor,

                        boxShadow: [
                          BoxShadow(
                            color: crimsonColor.withValues(alpha: 0.6),
                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (progress < 0.35)
                Positioned(
                  left: (screenWidth - dotSize) / 2,

                  top:
                      (screenHeight / 2 - dotSize / 2) +
                      (_offWhiteDotY.value * screenHeight),

                  child: Opacity(
                    opacity: _dotOpacity.value.clamp(0.0, 1.0),

                    child: Container(
                      width: dotSize,
                      height: dotSize,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: fontColor,

                        boxShadow: [
                          BoxShadow(
                            color: fontColor.withValues(alpha: 0.4),
                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if (progress >= 0.25 && logoScale > 0)
                Positioned(
                  left:
                      (screenWidth / 2) +
                      (_logoSlideX.value * screenWidth) -
                      (logoSize / 2),

                  top: (screenHeight / 2) - (logoSize / 2),

                  child: Container(
                    width: logoSize,
                    height: logoSize,

                    child: FittedBox(
                      fit: BoxFit.contain,

                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(44),

                          child: SizedBox(
                            width: 220,
                            height: 220,

                            child: Transform.scale(
                              scale: 1.85,

                              child: Image.asset(
                                'assest/images/IMG-20260802-WA0014.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (progress >= 0.72)
                Positioned(
                  left: textLeftPos,
                  top: (screenHeight / 2) - 22,

                  child: Opacity(
                    opacity: _textOpacity.value.clamp(0.0, 1.0),

                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sprint ',
                            style: TextStyle(
                              color: crimsonColor,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),

                          TextSpan(
                            text: 'Journal',
                            style: TextStyle(
                              color: fontColor,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
