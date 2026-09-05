import 'dart:async';
import 'package:flutter/material.dart';
import 'main_dashboard_screen.dart';

/// Multi-phase cinematic splash screen animation:
///
/// Phase 1 (0.0 - 0.25): Two dot circles fly toward center
///   - Crimson dot enters from top (off-screen) → center
///   - Off-white dot enters from bottom (off-screen) → center
///
/// Phase 2 (0.25 - 0.50): Dots merge, logo image scales up to 50%
///
/// Phase 3 (0.50 - 0.65): Logo smoothly scales down from 50% → 45%
///
/// Phase 4 (0.65 - 0.85): Logo slides center → left, text reveals at fixed position
///
/// Phase 5 (0.85 - 1.0): Hold final composition, then navigate

class OneTimeSplashScreen extends StatefulWidget {
  const OneTimeSplashScreen({super.key});

  @override
  State<OneTimeSplashScreen> createState() => _OneTimeSplashScreenState();
}

class _OneTimeSplashScreenState extends State<OneTimeSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _masterController;

  // Phase 1: Dot circles flying to center
  late Animation<double> _crimsonDotY;
  late Animation<double> _offWhiteDotY;
  late Animation<double> _dotOpacity;

  // Phase 2+3: Single smooth logo scale (0 → 0.50 → 0.45)
  late Animation<double> _logoScale;

  // Phase 4: Logo slide left + text reveal
  late Animation<double> _logoSlideX;
  late Animation<double> _textOpacity;

  Timer? _navigationTimer;

  // Final logo position constants (fraction of screen width)
  static const double _finalLogoScale = 0.45;
  static const double _finalLogoSlideX = -0.25;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // ──────────────────────────────────────────────
    // PHASE 1 (0% – 25%): Dots fly toward center
    // ──────────────────────────────────────────────

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

    // ──────────────────────────────────────────────
    // PHASE 2+3 (25% – 65%): Seamless scale 0 → 0.50 → 0.45
    // Single TweenSequence for buttery smooth transition
    // ──────────────────────────────────────────────

    _logoScale = TweenSequence<double>([
      // 0% – 25%: Logo invisible (scale = 0)
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.0), weight: 25),
      // 25% – 50%: Scale up from 0 → 0.50
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.50)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
      // 50% – 65%: Smoothly settle down from 0.50 → 0.45
      TweenSequenceItem(
        tween: Tween(begin: 0.50, end: _finalLogoScale)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 15,
      ),
      // 65% – 100%: Hold at 0.45
      TweenSequenceItem(
        tween: Tween(begin: _finalLogoScale, end: _finalLogoScale),
        weight: 35,
      ),
    ]).animate(_masterController);

    // ──────────────────────────────────────────────
    // PHASE 4 (65% – 85%): Logo slides left, text fades in
    // ──────────────────────────────────────────────

    _logoSlideX = Tween<double>(begin: 0.0, end: _finalLogoSlideX).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeInOutCubic),
      ),
    );

    // Text fades in at a FIXED position (not following the logo)
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.75, 0.92, curve: Curves.easeIn),
      ),
    );

    // Start the master animation
    _masterController.forward();

    // Navigate after animation completes + small hold buffer
    _navigationTimer =
        Timer(const Duration(milliseconds: 4500), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainDashboardScreen(),
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

    // Pre-compute the text's FINAL fixed position based on where the logo
    // will END UP (not where it currently is during animation).
    // This way the text never chases or moves toward the logo.
    final double finalLogoSize = screenWidth * _finalLogoScale;
    final double finalLogoCenterX =
        (screenWidth / 2) + (_finalLogoSlideX * screenWidth);
    final double finalLogoRightEdge = finalLogoCenterX + (finalLogoSize / 2);
    final double textLeftPos = finalLogoRightEdge + 16; // Fixed gap after logo

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
              // ── Background gradient ──
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.3,
                    colors: [
                      Color(0xFF252524),
                      backgroundColor,
                    ],
                  ),
                ),
              ),

              // ── PHASE 1: Crimson dot (from top) ──
              if (progress < 0.35)
                Positioned(
                  left: (screenWidth - dotSize) / 2,
                  top: (screenHeight / 2 - dotSize / 2) +
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

              // ── PHASE 1: Off-white dot (from bottom) ──
              if (progress < 0.35)
                Positioned(
                  left: (screenWidth - dotSize) / 2,
                  top: (screenHeight / 2 - dotSize / 2) +
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

              // ── PHASE 2-5: Logo image (smooth scale + slide) ──
              if (progress >= 0.25 && logoScale > 0)
                Positioned(
                  left: (screenWidth / 2) +
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
                          borderRadius: BorderRadius.circular(44), // Adjust to match corner radius
                          child: SizedBox(
                            width: 220,
                            height: 220,
                            child: Transform.scale(
                              scale: 1.85, // Zooms in past the outer dark container
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

              // ── PHASE 4-5: "Sprint Journal" text ──
              // FIXED position — does NOT follow the logo's slide animation.
              // Anchored to the logo's FINAL resting position.
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
