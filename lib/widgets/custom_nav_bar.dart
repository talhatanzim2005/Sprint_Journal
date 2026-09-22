import 'package:flutter/material.dart';

const Color _kNavBarBgColor = Color(0xFF1B1B1A);
const Color _kActiveColor = Color(0xFFCD0033);
const Color _kInactiveColor = Color(0xFF8A8A85);
const Color _kFontColor = Color(0xFFFFF4E0);

const Duration _kTabAnimationDuration = Duration(milliseconds: 200);
const Duration _kIndicatorAnimationDuration = Duration(milliseconds: 250);

class NavBarItem {
  const NavBarItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.items = defaultItems,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<NavBarItem> items;

  static const List<NavBarItem> defaultItems = [
    NavBarItem(icon: Icons.home_rounded, label: 'Home'),
    NavBarItem(icon: Icons.insights_rounded, label: 'Progress'),
    NavBarItem(icon: Icons.menu_book_rounded, label: 'Journal'),
    NavBarItem(icon: Icons.timer_rounded, label: 'Timer'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kNavBarBgColor,
        border: Border(
          top: BorderSide(
            color: _kInactiveColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              items.length,
                  (index) => _NavBarTabItem(
                item: items[index],
                isSelected: index == currentIndex,
                onTap: () => onTabSelected(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarTabItem extends StatelessWidget {
  const _NavBarTabItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isSelected ? _kActiveColor : _kInactiveColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: _kTabAnimationDuration,
              curve: Curves.easeOutCubic,
              child: Icon(
                item.icon,
                color: activeColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: _kTabAnimationDuration,
              style: TextStyle(
                color: isSelected ? _kFontColor : activeColor,
                fontSize: isSelected ? 11.5 : 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
              ),
              child: Text(item.label),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: _kIndicatorAnimationDuration,
              curve: Curves.easeOut,
              width: isSelected ? 5.0 : 0.0,
              height: isSelected ? 5.0 : 0.0,
              decoration: const BoxDecoration(
                color: _kActiveColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}