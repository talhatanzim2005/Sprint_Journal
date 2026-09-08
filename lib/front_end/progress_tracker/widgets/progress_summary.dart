import 'package:flutter/material.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    super.key,
    required this.totalHabits,
    required this.completions,
    required this.bestStreak,
    required this.onHabitsTap,
    required this.onCompletionsTap,
    required this.onStreakTap,
  });

  final int totalHabits;
  final int completions;
  final int bestStreak;

  final VoidCallback onHabitsTap;
  final VoidCallback onCompletionsTap;
  final VoidCallback onStreakTap;

  static const Color cardColor = Color(0xFF252524);
  static const Color redColor = Color(0xFFCD0033);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onHabitsTap,

            child: progressCard(
              'Total Habits',
              totalHabits.toString(),
              Icons.check_circle_outline,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: GestureDetector(
            onTap: onCompletionsTap,

            child: progressCard(
              'Completions',
              completions.toString(),
              Icons.done_all,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: GestureDetector(
            onTap: onStreakTap,

            child: progressCard(
              'Best Streak',
              bestStreak.toString(),
              Icons.local_fire_department,
            ),
          ),
        ),
      ],
    );
  }

  Widget progressCard(String title, String number, IconData icon) {
    return Container(
      height: 120,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: redColor, size: 25),

          const SizedBox(height: 8),

          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
