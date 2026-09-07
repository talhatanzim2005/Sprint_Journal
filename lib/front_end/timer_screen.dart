import 'dart:async';
import 'package:flutter/material.dart';

enum TimerMode { pomodoro, shortBreak, longBreak }

/// Countdown/interval timer.
///
/// No Scaffold — [MainDashboardScreen] provides the outer shell.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimerMode _currentMode = TimerMode.pomodoro;
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  bool _isRunning = false;

  int _getDurationForMode(TimerMode mode) {
    switch (mode) {
      case TimerMode.pomodoro:
        return 25 * 60;
      case TimerMode.shortBreak:
        return 5 * 60;
      case TimerMode.longBreak:
        return 15 * 60;
    }
  }

  void _changeMode(TimerMode mode) {
    _timer?.cancel();
    setState(() {
      _currentMode = mode;
      _remainingSeconds = _getDurationForMode(mode);
      _isRunning = false;
    });
  }

  void _startTimer() {
    if (_isRunning || _remainingSeconds == 0) return;
    
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _getDurationForMode(_currentMode);
      _isRunning = false;
    });
  }
  
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _modeText {
    switch (_currentMode) {
      case TimerMode.pomodoro:
        return 'Focus Time';
      case TimerMode.shortBreak:
        return 'Short Break';
      case TimerMode.longBreak:
        return 'Long Break';
    }
  }

  Widget _buildModeButton(String text, TimerMode mode) {
    final isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () => _changeMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade300,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF121212), // Dark/black background
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mode selection buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeButton('pomodoro', TimerMode.pomodoro),
                const SizedBox(width: 8),
                _buildModeButton('short break', TimerMode.shortBreak),
                const SizedBox(width: 8),
                _buildModeButton('long break', TimerMode.longBreak),
              ],
            ),
            
            const SizedBox(height: 80),

            // Timer display
            Text(
              _formattedTime,
              style: const TextStyle(
                color: Color(0xFFFFF4E0),
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtitle text
            Text(
              _modeText,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
            
            const SizedBox(height: 80),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reset Button
                _buildControlButton(
                  icon: Icons.refresh,
                  onTap: _resetTimer,
                ),
                const SizedBox(width: 24),
                // Play Button
                _buildControlButton(
                  icon: Icons.play_arrow,
                  onTap: _startTimer,
                ),
                const SizedBox(width: 24),
                // Pause Button
                _buildControlButton(
                  icon: Icons.pause,
                  onTap: _pauseTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFB71C1C), // Red color for buttons
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
