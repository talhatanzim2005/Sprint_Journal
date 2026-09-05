import 'package:flutter/material.dart';

/// Data model representing a calendar event or task.
class CalendarItem {
  final String id;
  final String title;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime date;
  final bool isEvent; // true for "Upcoming Event", false for "Task"

  const CalendarItem({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    this.isEvent = true,
  });

  /// CopyWith helper method for editing existing items
  CalendarItem copyWith({
    String? id,
    String? title,
    String? description,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? date,
    bool? isEvent,
  }) {
    return CalendarItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
      isEvent: isEvent ?? this.isEvent,
    );
  }

  /// Formats TimeOfDay into HH:mm (24-hour style matching reference image)
  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get startTimeString => formatTime(startTime);
  String get endTimeString => formatTime(endTime);
}
