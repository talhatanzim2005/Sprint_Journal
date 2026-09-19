import 'package:flutter/material.dart';

Route swipeAnimRoute(Widget page, {bool fromRight = false}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Offset by just 25% for a subtle premium nudge, instead of coming entirely off-screen
      final beginOffset = Offset(fromRight ? 0.25 : -0.25, 0.0);
      const endOffset = Offset.zero;

      // Luxurious curve that slows down beautifully at the end
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final slideAnim = Tween(begin: beginOffset, end: endOffset).animate(curve);
      final fadeAnim = Tween(begin: 0.0, end: 1.0).animate(curve);

      return FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: child,
        ),
      );
    },
  );
}
