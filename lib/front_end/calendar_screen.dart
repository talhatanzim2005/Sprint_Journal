import 'package:flutter/material.dart';

import 'calendar/calendar_item_model.dart';
import 'calendar/calendar_view.dart';
import 'calendar/upcoming_tasks_view.dart';
import '../widgets/event_form_sheet.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);
  static const Color sheetBgColor = Color.fromARGB(255, 36, 36, 35);

  // Selected Date & focused month
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String? _selectedItemId;

  final Map<String, List<CalendarItem>> _itemsMap = {};

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  // Getter to quickly retrieve todays item
  List<CalendarItem> get _selectedDayItems =>
      _itemsMap[_dateKey(_selectedDate)] ?? [];

  // Sort items sequentially by their start time
  void _sortItems(List<CalendarItem> list) => list.sort(
    (a, b) => (a.startTime.hour * 60 + a.startTime.minute).compareTo(
      b.startTime.hour * 60 + b.startTime.minute,
    ),
  );

  // Add Item
  void _addItem(CalendarItem item) => setState(() {
    final list = _itemsMap.putIfAbsent(_dateKey(item.date), () => [])
      ..add(item);
    _sortItems(list);
  });

  // Edit Item
  void _editItem(CalendarItem item) => setState(() {
    final list = _itemsMap[_dateKey(item.date)];
    if (list != null) {
      final index = list.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        list[index] = item;
        _sortItems(list);
      }
    }
  });

  // Delete Item WITH Snackbar
  void _deleteItem(CalendarItem item) {
    setState(
      () => _itemsMap[_dateKey(item.date)]?.removeWhere((e) => e.id == item.id),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.isEvent ? 'Event' : 'Task'} deleted'),
        backgroundColor: sheetBgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: fontColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: fontColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: Column(
        children: [
          // Top 40%: Calendar Month View
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarView(
                focusedDay: _focusedDay,
                selectedDay: _selectedDate,
                onPageChanged: (d) => _focusedDay = d,
                onDaySelected: (s, f) => setState(() {
                  _selectedDate = s;
                  _focusedDay = f;
                }),
              ),
            ),
          ),
          // Bottom 60%: Events & Task List
          Expanded(
            flex: 6,
            child: UpcomingTasksView(
              selectedDate: _selectedDate,
              items: _selectedDayItems,
              selectedItemId: _selectedItemId,
              onSelectItem: (item) => setState(() => _selectedItemId = item.id),
              onEditItem: (item) => EventFormSheet.show(
                context,
                selectedDay: _selectedDate,
                existingItem: item,
                onSave: _editItem,
              ),
              onDeleteItem: _deleteItem,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          EventFormSheet.show(
            context,
            selectedDay: _selectedDate,
            onSave: _addItem,
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}