import 'package:flutter/material.dart';

/// Daily overview and active sprint metrics.
///
/// No Scaffold — [MainDashboardScreen] provides the outer shell.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Background - Dark/black background
      color: const Color(0xFF121212),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 2. Greeting
            const Text(
              "Hi, Talha.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // 3. My Journal section
            const Text(
              "My Journal",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            
            // Large empty rectangular box (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent, // Empty inside
                border: Border.all(color: Colors.white30, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.edit_note,
                  color: Colors.white30,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 4. Quick Journal section
            const Text(
              "Quick Journal",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            
            // Four small boxes arranged horizontally
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickJournalBox(Icons.horizontal_rule),
                _buildQuickJournalBox(Icons.horizontal_rule),
                _buildQuickJournalBox(Icons.horizontal_rule),
                _buildQuickJournalBox(Icons.horizontal_rule),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create small quick journal placeholder boxes
  Widget _buildQuickJournalBox(IconData icon) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white54,
          size: 30,
        ),
      ),
    );
  }
}
