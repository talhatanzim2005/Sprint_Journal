import 'package:flutter/material.dart';

class CalendarItem {
  final String id;
  final String title;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final DateTime date;
  final bool isEvent;

  const CalendarItem({
    required this.id,
    required this.title,
    required this.description,
    this.startTime = const TimeOfDay(hour: 9, minute: 0),
    this.endTime = const TimeOfDay(hour: 10, minute: 0),
    required this.date,
    this.isEvent = true,
  });
  //copywith method ensures to create a new copy of existing object with only specific field modification
  CalendarItem copyWith({
    String? id,//optional and nullable
    String? title,
    String? description,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? date,
    bool? isEvent,
  }) => CalendarItem(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    date: date ?? this.date,
    isEvent: isEvent ?? this.isEvent,
  );
  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get startTimeString => formatTime(startTime);
  String get endTimeString => formatTime(endTime);
}
