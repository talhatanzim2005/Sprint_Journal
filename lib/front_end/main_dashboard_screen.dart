import 'dart:math';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_nav_bar.dart';
import 'home_screen.dart';
import 'progress_tracker/progress_tracker_screen.dart';
import 'journal_screen.dart';
import 'timer_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

/// Stateful shell that hosts the four main views via [IndexedStack],
/// a shared [CustomAppBar], and a [CustomNavBar].
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;

  static const Color _bgColor = Color(0xFF1B1B1A);

  final List<Widget> _screens = const [
    HomeScreen(),
    ProgressTrackerScreen(),
    JournalScreen(),
    TimerScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _openCalendar() {
    Navigator.of(context).push(_circularRevealRoute());
  }

  void _openMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: CustomAppBar(
        onCalendarPressed: _openCalendar,
        onMenuPressed: _openMenu,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // Circular Reveal Route for CalendarScreen
  // ─────────────────────────────────────────────────

  /// Creates a [PageRouteBuilder] with a [ClipPath] animation that expands
  /// from a 25 % circle (originating near the calendar icon) to a full page.
  Route<dynamic> _circularRevealRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const CalendarScreen(),
      transitionDuration: const Duration(milliseconds: 550),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final screenSize = MediaQuery.of(context).size;
        final topPadding = MediaQuery.of(context).padding.top;

        // Position of calendar icon in the search bar row (~ left side)
        final origin = Offset(33, topPadding + 65);

        // Transition color morphs from 0xFF1B1B1A (dark) -> 0xFFCD0033 (crimson)
        final animColor = Color.lerp(
          const Color(0xFF1B1B1A),
          const Color(0xFFCD0033),
          animation.value,
        )!;

        return ClipPath(
          clipper: _CircularRevealClipper(
            fraction: animation.value,
            center: origin,
            screenSize: screenSize,
          ),
          child: Stack(
            children: [
              // Expanding color transition background layer
              Positioned.fill(
                child: Container(color: animColor),
              ),
              // Calendar screen content
              Opacity(
                opacity: animation.value,
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom clipper that reveals the page through an expanding circle.
///
/// At [fraction] = 0 the circle has 25% of the maximum radius needed
/// to cover the screen from [center]. At [fraction] = 1 the circle
/// fully covers the viewport.
class _CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;
  final Size screenSize;

  _CircularRevealClipper({
    required this.fraction,
    required this.center,
    required this.screenSize,
  });

  @override
  Path getClip(Size size) {
    // Maximum radius = distance from origin to the farthest corner.
    final maxRadius = _maxDistanceToCorner(size);

    // Interpolate from 25 % of max radius → 100 %.
    final startRadius = maxRadius * 0.25;
    final radius = startRadius + (maxRadius - startRadius) * fraction;

    return Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  }

  /// Computes the distance from [center] to the farthest corner of [size].
  double _maxDistanceToCorner(Size size) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    double maxDist = 0;
    for (final corner in corners) {
      final dist = (corner - center).distance;
      maxDist = max(maxDist, dist);
    }
    return maxDist;
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) =>
      fraction != oldClipper.fraction;
}
