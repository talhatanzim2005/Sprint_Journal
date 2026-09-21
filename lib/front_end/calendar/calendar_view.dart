import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatelessWidget {
  final DateTime focusedDay;//curent day
  final DateTime? selectedDay;//clicked by the user
  // to show highlight on specific days
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final Function(DateTime focusedDay) onPageChanged;

  // Dark background
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  // Off-white cream font
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  // Crimson red accent highlight
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

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
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        //
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(fontSize: 12.0, color: fontColor),
          weekendTextStyle: TextStyle(fontSize: 12.0, color: accentColor),
          outsideTextStyle: TextStyle(
            fontSize: 12.0,
            color: fontColor.withAlpha(76),
          ),

          holidayTextStyle: TextStyle(fontSize: 12.0),
          //to make selected date date and today's date glowing red
          todayDecoration: BoxDecoration(
            color: fontColor.withAlpha(156),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
          selectedDecoration: BoxDecoration(
            color: accentColor.withAlpha(76),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: fontColor,
            fontWeight: FontWeight.bold,
          ),
          cellMargin: EdgeInsets.all(2.0),
          cellPadding: EdgeInsets.zero,
        ),
        sixWeekMonthsEnforced: false,
        rowHeight: 32,
        daysOfWeekHeight: 22,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        startingDayOfWeek: StartingDayOfWeek.saturday,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) {
            final month = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            return '${date.day} ${month[date.month - 1]} ${date.year}';
          },
          titleTextStyle: TextStyle(
            color: fontColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: .8,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: fontColor, size: 22),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: fontColor,
            size: 22,
          ),

          headerPadding: EdgeInsets.zero,
          leftChevronPadding: EdgeInsets.all(4.0),
          rightChevronPadding: EdgeInsets.all(4.0),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: fontColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: TextStyle(
            color: accentColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
