import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_nav_bar.dart';
import '../widgets/swipe_anim.dart';
import 'home_screen.dart';
import 'progress_tracker/progress_tracker_screen.dart';
import 'journal/journal_screen.dart';
import 'timer_screen.dart';
import 'calendar/calendar_screen.dart';
import 'auth/profile_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  static const Color _bgColor = Color(0xFF1B1B1A);

  final List<Widget> _screens = const [
    HomeScreen(),
    ProgressTrackerScreen(),
    JournalScreen(),
    TimerScreen(),
  ];

  void _onTabSelected(int index) {
    final previousIndex = _currentIndex;
    setState(() => _currentIndex = index);

    if ((index - previousIndex).abs() == 1) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  void _openCalendar() {
    Navigator.push(
      context,
      swipeAnimRoute(const CalendarScreen(), fromRight: false),
    );
  }

  void _openMenu() {
    Navigator.push(
      context,
      swipeAnimRoute(const ProfileScreen(), fromRight: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: CustomAppBar(
        onCalendarPressed: _openCalendar,
        onMenuPressed: _openMenu,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _screens,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
