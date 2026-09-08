import 'package:flutter/material.dart';

import 'widgets/progress_summary.dart';
import 'widgets/progress_graph.dart';
import 'dialogs/habits_dialog.dart';
import 'dialogs/progress_dialogs.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() =>
      _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {

  // ---------------- THEME COLORS ----------------

  static const Color bgColor = Color(0xFF1B1B1A);
  static const Color redColor = Color(0xFFCD0033);

  // ---------------- HABITS ----------------

  List<String> habits = [
    'Drink 8 glasses of water',
    'Read for 30 minutes',
    'Exercise',
    'Write journal',
    'Meditate',
    'Sleep before 11 PM',
  ];

  List<bool> habitDone = [
    true,
    false,
    true,
    true,
    false,
    false,
  ];

  // ---------------- STREAK DATA ----------------

  int currentStreak = 7;
  int bestStreak = 12;

  // ---------------- COUNT COMPLETED HABITS ----------------

  int _getCompletedCount() {
    int count = 0;

    for (bool done in habitDone) {
      if (done) {
        count++;
      }
    }

    return count;
  }

  // ---------------- SHOW HABITS ----------------

  void _showHabits() {
    showHabitsDialog(
      context,
      habits,
      habitDone,
          (index, value) {
        setState(() {
          habitDone[index] = value;
        });
      },
    );
  }

  // ---------------- SHOW COMPLETIONS ----------------

  void _showCompletions() {
    showCompletionsDialog(
      context,
      _getCompletedCount(),
      habits.length,
    );
  }

  // ---------------- SHOW STREAK ----------------

  void _showStreak() {
    showStreakDialog(
      context,
      currentStreak,
      bestStreak,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      // ---------------- APP BAR ----------------

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,

        title: const Text(
          'Progress Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ---------------- BODY ----------------

      body: Scrollbar(
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // YOUR PROGRESS
                // ==================================================

                const Text(
                  'Your Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // ---------------- SUMMARY CARDS ----------------

                ProgressSummary(
                  totalHabits: habits.length,
                  completions: _getCompletedCount(),
                  bestStreak: bestStreak,

                  onHabitsTap: _showHabits,
                  onCompletionsTap: _showCompletions,
                  onStreakTap: _showStreak,
                ),

                const SizedBox(height: 30),

                // ==================================================
                // THIS WEEK
                // ==================================================

                const Text(
                  'This Week',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Habit completion for the last 7 days',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 15),

                const ProgressGraph(
                  isThirtyDays: false,
                ),

                const SizedBox(height: 30),

                // ==================================================
                // LAST 30 DAYS
                // ==================================================

                const Text(
                  'Last 30 Days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your habit completion for the last 30 days',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 15),

                const ProgressGraph(
                  isThirtyDays: true,
                ),

                const SizedBox(height: 20),

                // ==================================================
                // CONSISTENCY
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            '30-Day Consistency',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Keep going!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const Text(
                        '72%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}