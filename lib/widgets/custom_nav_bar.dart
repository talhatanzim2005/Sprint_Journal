import 'package:flutter/material.dart';

/// Bottom navigation bar with 4 tabs evenly distributed.
///
/// Tab Index → Icon:
///   0 → Home
///   1 → Progress / Analytics
///   2 → Journal Book
///   3 → Timer
class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  // ── Color tokens ──
  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _activeColor = Color(0xFFCD0033);
  static const Color _inactiveColor = Color(0xFF8A8A85);
  static const Color _fontColor = Color(0xFFFFF4E0);

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.insights_rounded, label: 'Progress'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Journal'),
    _NavItem(icon: Icons.timer_rounded, label: 'Timer'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border(
          top: BorderSide(
            color: _inactiveColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: bottomPadding + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (index) {
          final isActive = index == currentIndex;
          return _NavTabButton(
            item: _items[index],
            isActive: isActive,
            onTap: () => onTabSelected(index),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

/// Individual nav tab with animated icon + label.
class _NavTabButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? CustomNavBar._activeColor : CustomNavBar._inactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon scale
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: Icon(item.icon, color: color, size: 26),
            ),
            const SizedBox(height: 4),
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive ? CustomNavBar._fontColor : color,
                fontSize: isActive ? 11.5 : 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
              child: Text(item.label),
            ),
            const SizedBox(height: 4),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isActive ? 5 : 0,
              height: isActive ? 5 : 0,
              decoration: const BoxDecoration(
                color: CustomNavBar._activeColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
