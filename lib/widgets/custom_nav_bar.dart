import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  const CustomNavBar({super.key, required this.currentIndex, required this.onTabSelected});

  static const _bgColor = Color(0xFF1B1B1A), _active = Color(0xFFCD0033), _inactive = Color(0xFF8A8A85), _font = Color(0xFFFFF4E0);
  static const _items = [
    (Icons.home_rounded, 'Home'), (Icons.insights_rounded, 'Progress'),
    (Icons.menu_book_rounded, 'Journal'), (Icons.timer_rounded, 'Timer')
  ];

  @override Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _bgColor, border: Border(top: BorderSide(color: _inactive.withValues(alpha: 0.15)))),
      padding: EdgeInsets.only(top: 8, bottom: MediaQuery.of(context).padding.bottom + 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final active = i == currentIndex;
          final color = active ? _active : _inactive;
          return GestureDetector(
            onTap: () => onTabSelected(i), behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 64,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(scale: active ? 1.15 : 1.0, duration: const Duration(milliseconds: 200), curve: Curves.easeOutCubic, child: Icon(_items[i].$1, color: color, size: 26)),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(duration: const Duration(milliseconds: 200), style: TextStyle(color: active ? _font : color, fontSize: active ? 11.5 : 10.5, fontWeight: active ? FontWeight.w700 : FontWeight.w500, letterSpacing: 0.3), child: Text(_items[i].$2)),
                  const SizedBox(height: 4),
                  AnimatedContainer(duration: const Duration(milliseconds: 250), curve: Curves.easeOut, width: active ? 5 : 0, height: active ? 5 : 0, decoration: const BoxDecoration(color: _active, shape: BoxShape.circle)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
