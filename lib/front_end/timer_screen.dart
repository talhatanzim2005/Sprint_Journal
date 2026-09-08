import 'dart:async';

import 'package:flutter/material.dart';

enum TimerMode {
  pomodoro,
  shortBreak,
  longBreak,
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() {
    return _TimerScreenState();
  }
}

class _TimerScreenState extends State<TimerScreen> {

  TimerMode currentMode = TimerMode.pomodoro;

  int remainingSeconds = 25 * 60;

  Timer? timer;

  bool isRunning = false;

  // List of timer modes
  final List<TimerMode> modes = [
    TimerMode.pomodoro,
    TimerMode.shortBreak,
    TimerMode.longBreak,
  ];


  @override
  void initState() {
    super.initState();

    // Initial timer value
    remainingSeconds = 25 * 60;
  }


  // Get duration
  int getDuration(TimerMode mode) {

    if (mode == TimerMode.pomodoro) {
      return 25 * 60;
    }

    if (mode == TimerMode.shortBreak) {
      return 5 * 60;
    }

    return 15 * 60;
  }


  // Change timer mode
  void changeMode(TimerMode mode) {

    timer?.cancel();

    setState(() {
      currentMode = mode;
      remainingSeconds = getDuration(mode);
      isRunning = false;
    });
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
      remainingSeconds = getDuration(currentMode);
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


  // Timer description
  String get modeText {

    if (currentMode == TimerMode.pomodoro) {
      return "Focus Time";
    }

    if (currentMode == TimerMode.shortBreak) {
      return "Short Break";
    }

    return "Long Break";
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

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            // -------------------------
            // TIMER MODES
            // -------------------------

            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                for (TimerMode mode in modes)

                  Padding(

                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),

                    child: _buildModeButton(mode),
                  ),
              ],
            ),


            const SizedBox(height: 60),


            // -------------------------
            // TIMER
            // -------------------------

            Center(

              child: Text(

                formattedTime,

                style: const TextStyle(

                  color: Color(0xFFFFF4E0),

                  fontSize: 80,

                  fontWeight: FontWeight.bold,

                  letterSpacing: 2,
                ),
              ),
            ),


            const SizedBox(height: 10),


            Text(

              modeText,

              style: const TextStyle(

                color: Colors.white70,

                fontSize: 20,

                fontWeight: FontWeight.normal,

                letterSpacing: 1,
              ),
            ),


            const SizedBox(height: 50),


            // -------------------------
            // CONTROL BUTTONS
            // -------------------------

            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                _buildControlButton(
                  Icons.refresh,
                  resetTimer,
                ),

                const SizedBox(width: 20),

                _buildControlButton(
                  Icons.play_arrow,
                  startTimer,
                ),

                const SizedBox(width: 20),

                _buildControlButton(
                  Icons.pause,
                  pauseTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // -------------------------
  // MODE BUTTON
  // -------------------------

  Widget _buildModeButton(TimerMode mode) {

    bool selected = currentMode == mode;

    String text = "";

    if (mode == TimerMode.pomodoro) {
      text = "pomodoro";
    }

    if (mode == TimerMode.shortBreak) {
      text = "short break";
    }

    if (mode == TimerMode.longBreak) {
      text = "long break";
    }


    return GestureDetector(

      onTap: () {
        changeMode(mode);
      },

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 300),

        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 9,
        ),

        decoration: BoxDecoration(

          color: Colors.transparent,

          border: Border.all(

            color: selected
                ? Colors.red
                : Colors.grey,

            width: selected ? 2 : 1,
          ),

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(

          text,

          style: TextStyle(

            color: Colors.white,

            fontSize: 15,

            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.normal,

            letterSpacing: 0.5,
          ),
        ),
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
