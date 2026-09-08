import 'dart:async';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() {
    return _TimerScreenState();
  }
}

class _TimerScreenState extends State<TimerScreen> {
  int remainingSeconds = 25 * 60;

  Timer? timer;

  bool isRunning = false;

  @override
  void initState() {
    super.initState();

    remainingSeconds = 25 * 60;
  }

  void startTimer() {
    if (isRunning || remainingSeconds == 0) {
      return;
    }

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();

        setState(() {
          isRunning = false;
        });
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      remainingSeconds = 25 * 60;
      isRunning = false;
    });
  }

  String get formattedTime {
    int minutes = remainingSeconds ~/ 60;

    int seconds = remainingSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedTime,
            style: const TextStyle(
              color: Color(0xFFFFF4E0),
              fontSize: 80,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Focus Timer",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                isRunning ? Icons.pause : Icons.play_arrow,
                isRunning ? pauseTimer : startTimer,
              ),
              const SizedBox(width: 20),
              _buildControlButton(Icons.stop, resetTimer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback function) {
    return Container(
      width: 70,

      height: 70,

      decoration: const BoxDecoration(
        color: Color(0xFFB71C1C),

        shape: BoxShape.circle,
      ),

      child: IconButton(
        onPressed: function,

        icon: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}
