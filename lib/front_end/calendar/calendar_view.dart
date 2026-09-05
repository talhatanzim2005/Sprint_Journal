import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// Top calendar component occupying ~40% of the body height.
class CalendarView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(DateTime focusedDay) onPageChanged;

  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);
  static const Color _highlightColor = Color(0xFFCD0033);

  const CalendarView({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2040, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        sixWeekMonthsEnforced: true,
        rowHeight: 32,
        daysOfWeekHeight: 22,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) {
            final months = [
              'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
              'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
            ];
            return '${date.day} ${months[date.month - 1]} ${date.year}';
          },
          titleTextStyle: const TextStyle(
            color: _fontColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: _fontColor, size: 22),
          rightChevronIcon: const Icon(Icons.chevron_right, color: _fontColor, size: 22),
          headerPadding: const EdgeInsets.symmetric(vertical: 0.0),
          leftChevronPadding: const EdgeInsets.all(4.0),
          rightChevronPadding: const EdgeInsets.all(4.0),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: _fontColor.withOpacity(0.6),
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: _highlightColor.withOpacity(0.8),
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(
            color: _fontColor,
            fontSize: 13.0,
          ),
          weekendTextStyle: const TextStyle(
            color: _highlightColor,
            fontSize: 13.0,
          ),
          outsideTextStyle: TextStyle(
            color: _fontColor.withOpacity(0.3),
            fontSize: 13.0,
          ),
          todayDecoration: BoxDecoration(
            color: _highlightColor.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: _highlightColor,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: _fontColor,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: const TextStyle(
            color: _fontColor,
            fontWeight: FontWeight.bold,
          ),
          cellMargin: const EdgeInsets.all(1),
        ),
      ),
    );
  }
}
