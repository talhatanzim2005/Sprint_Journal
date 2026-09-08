import 'package:flutter/material.dart';

void showCompletionsDialog(BuildContext context, int completed, int total) {
  showDialog(
    context: context,

    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF252524),

        title: const Text(
          'Completions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(Icons.done_all, color: Color(0xFFCD0033), size: 50),

            const SizedBox(height: 15),

            Text(
              '$completed / $total',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Habits completed today',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            Text(
              'You completed $completed habits today.',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },

            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFCD0033)),
            ),
          ),
        ],
      );
    },
  );
}

void showStreakDialog(BuildContext context, int currentStreak, int bestStreak) {
  showDialog(
    context: context,

    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF252524),

        title: const Text(
          'Streaks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.local_fire_department,
              color: Color(0xFFCD0033),
              size: 55,
            ),

            const SizedBox(height: 15),

            Text(
              '$currentStreak Days',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Current Streak',
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            Text(
              '$bestStreak Days',
              style: const TextStyle(
                color: Color(0xFFCD0033),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text('Best Streak', style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 15),

            const Text(
              'Keep completing your habits every day to build a longer streak.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },

            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFCD0033)),
            ),
          ),
        ],
      );
    },
  );
}
