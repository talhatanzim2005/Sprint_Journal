import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color _kBackgroundColor = Color(0xFF1B1B1A);
const Color _kSurfaceColor = Color(0xFF252524);
const Color _kFontColor = Color(0xFFFFF4E0);
const Color _kMutedColor = Color(0xFF8A8A85);
const Color _kCrimsonColor = Color(0xFFCD0033);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.onCalendarPressed,
    required this.onMenuPressed,
    this.searchController,
    this.onSearchChanged,
  });

  final VoidCallback onCalendarPressed;
  final VoidCallback onMenuPressed;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _kFontColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _AppBarIconButton(
                    icon: Icons.calendar_today_rounded,
                    onTap: onCalendarPressed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _AppBarSearchBar(
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _AppBarIconButton(
                    icon: Icons.menu_rounded,
                    onTap: onMenuPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: _kFontColor, size: 22),
        splashRadius: 22,
        style: IconButton.styleFrom(
          backgroundColor: _kSurfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _AppBarSearchBar extends StatelessWidget {
  const _AppBarSearchBar({
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _kSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _kMutedColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: _kMutedColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                color: _kFontColor,
                fontSize: 14,
              ),
              cursorColor: _kCrimsonColor,
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: _kMutedColor,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}