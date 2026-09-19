import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCalendarPressed, onMenuPressed;
  const CustomAppBar({super.key, required this.onCalendarPressed, required this.onMenuPressed});

  static const _bgColor = Color(0xFF1B1B1A), _fontColor = Color(0xFFFFF4E0), _crimson = Color(0xFFCD0033), _surfaceColor = Color(0xFF252524), _mutedColor = Color(0xFF8A8A85);

  @override Size get preferredSize => const Size.fromHeight(120);

  Widget _buildIcon(IconData icon, VoidCallback onTap) => SizedBox(
    width: 42, height: 42,
    child: IconButton(
      onPressed: onTap, icon: Icon(icon, color: _fontColor, size: 24), splashRadius: 22,
      style: IconButton.styleFrom(backgroundColor: _surfaceColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
  );

  @override Widget build(BuildContext context) {
    return Container(
      color: _bgColor, padding: EdgeInsets.fromLTRB(12, MediaQuery.of(context).padding.top + 8, 12, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('EEEE, MMMM d').format(DateTime.now()), textAlign: TextAlign.center, style: const TextStyle(color: _fontColor, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildIcon(Icons.calendar_today_rounded, onCalendarPressed), const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 42, padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: _surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: _mutedColor.withValues(alpha: 0.2))),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded, color: _mutedColor, size: 20), SizedBox(width: 8),
                      Expanded(child: TextField(style: TextStyle(color: _fontColor, fontSize: 14), cursorColor: _crimson, decoration: InputDecoration(hintText: 'Search...', hintStyle: TextStyle(color: _mutedColor, fontSize: 14), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8)))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8), _buildIcon(Icons.menu_rounded, onMenuPressed),
            ],
          ),
        ],
      ),
    );
  }
}
