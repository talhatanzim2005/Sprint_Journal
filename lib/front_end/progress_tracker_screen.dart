import 'package:flutter/material.dart';

/// Habit/goal analytics and charts.
///
/// No Scaffold — [MainDashboardScreen] provides the outer shell.
class ProgressTrackerScreen extends StatelessWidget {
  const ProgressTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Progress Tracker',
        style: TextStyle(
          color: Color(0xFFFFF4E0),
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
