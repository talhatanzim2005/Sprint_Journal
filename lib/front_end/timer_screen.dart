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

    // Initial timer value
    remainingSeconds = 25 * 60;
  }


  // Start timer
  void startTimer() {

    if (isRunning || remainingSeconds == 0) {
      return;
    }

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {

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
      },
    );
  }


  // Pause timer
  void pauseTimer() {

    timer?.cancel();

    setState(() {
      isRunning = false;
    });
  }


  // Reset timer
  void resetTimer() {

    timer?.cancel();

    setState(() {
      remainingSeconds = 25 * 60;
      isRunning = false;
    });
  }


  // Format timer
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

    double progress = remainingSeconds / (25 * 60);

    return Container(

      color: const Color(0xFF121212),

      child: Column(

        children: [

          const SizedBox(height: 40),

          Expanded(

            child: Stack(

              alignment: Alignment.center,

              children: [

                SizedBox(

                  width: 300,

                  height: 300,

                  child: CircularProgressIndicator(

                    backgroundColor: Colors.grey.shade800,

                    color: const Color(0xFFB71C1C),

                    value: progress,

                    strokeWidth: 6,
                  ),
                ),

                Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Text(

                      formattedTime,

                      style: const TextStyle(

                        color: Color(0xFFFFF4E0),

                        fontSize: 60,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(

                      "Focus Time",

                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 20,

                        fontWeight: FontWeight.normal,

                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),

            child: Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                _buildControlButton(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  isRunning ? pauseTimer : startTimer,
                ),

                const SizedBox(width: 20),

                _buildControlButton(
                  Icons.stop,
                  resetTimer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // -------------------------
  // CONTROL BUTTON
  // -------------------------

  Widget _buildControlButton(
    IconData icon,
    VoidCallback function,
  ) {

    return Container(

      width: 70,

      height: 70,

      decoration: const BoxDecoration(

        color: Color(0xFFB71C1C),

        shape: BoxShape.circle,
      ),

      child: IconButton(

        onPressed: function,

        icon: Icon(

          icon,

          color: Colors.white,

          size: 35,
        ),
      ),
    );
  }
}
