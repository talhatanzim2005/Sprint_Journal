import 'package:flutter/material.dart';

/// Full calendar view opened via the AppBar calendar trigger.
///
/// Uses its own [Scaffold] because it is pushed as a modal route,
/// not rendered inside the dashboard's [IndexedStack].
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: _fontColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: _fontColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Calendar Screen',
          style: TextStyle(
            color: _fontColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
