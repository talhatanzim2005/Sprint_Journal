import 'package:flutter/material.dart';
import 'calendar/calendar_item_model.dart';
import 'calendar/calendar_view.dart';
import 'calendar/upcoming_tasks_view.dart';

/// Full calendar screen view.
///
/// Features:
/// - 40% height allocation for top Table Calendar.
/// - 60% height allocation for bottom Timeline & Event view.
/// - Bottom-right FAB offering "Upcoming Event" or "Create Task".
/// - Complete CRUD (Add, Edit, Delete) for items with Title, Description, and Start:End time.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);
  static const Color _highlightColor = Color(0xFFCD0033);
  static const Color _sheetBgColor = Color(0xFF242423);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedItemId = '3'; // Default selected item matching sample data

  // In-memory store for events and tasks grouped by date key "YYYY-MM-DD"
  final Map<String, List<CalendarItem>> _itemsMap = {};

  @override
  void initState() {
    super.initState();
    _seedInitialSampleData();
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _seedInitialSampleData() {
    final todayKey = _dateKey(DateTime.now());
    _itemsMap[todayKey] = [
      CalendarItem(
        id: '1',
        title: 'Daily Workout',
        description: 'Push up 10x, Squat 10x',
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 8, minute: 0),
        date: DateTime.now(),
        isEvent: false,
      ),
      CalendarItem(
        id: '2',
        title: 'Work on a new project',
        description: 'Working on a new UI project',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        date: DateTime.now(),
        isEvent: false,
      ),
      CalendarItem(
        id: '3',
        title: 'Meeting with a client',
        description: 'Zoom meeting with Zake, Allen, and David',
        startTime: const TimeOfDay(hour: 18, minute: 0),
        endTime: const TimeOfDay(hour: 19, minute: 0),
        date: DateTime.now(),
        isEvent: true, // Highlighted event card matching screenshot
      ),
      CalendarItem(
        id: '4',
        title: 'Buy a present',
        description: 'At House of Tadu',
        startTime: const TimeOfDay(hour: 19, minute: 30),
        endTime: const TimeOfDay(hour: 20, minute: 30),
        date: DateTime.now(),
        isEvent: false,
      ),
      CalendarItem(
        id: '5',
        title: 'Home sweet home',
        description: 'Sleep well and prepare for next day',
        startTime: const TimeOfDay(hour: 21, minute: 0),
        endTime: const TimeOfDay(hour: 22, minute: 0),
        date: DateTime.now(),
        isEvent: false,
      ),
    ];
  }

  List<CalendarItem> get _selectedDayItems {
    final key = _dateKey(_selectedDay);
    return _itemsMap[key] ?? [];
  }

  void _addItem(CalendarItem item) {
    setState(() {
      final key = _dateKey(item.date);
      if (!_itemsMap.containsKey(key)) {
        _itemsMap[key] = [];
      }
      _itemsMap[key]!.add(item);
      // Sort items by start time
      _itemsMap[key]!.sort((a, b) {
        final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return aMinutes.compareTo(bMinutes);
      });
    });
  }

  void _editItem(CalendarItem updatedItem) {
    setState(() {
      final key = _dateKey(updatedItem.date);
      if (_itemsMap.containsKey(key)) {
        final index = _itemsMap[key]!.indexWhere((i) => i.id == updatedItem.id);
        if (index != -1) {
          _itemsMap[key]![index] = updatedItem;
          _itemsMap[key]!.sort((a, b) {
            final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
            final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
            return aMinutes.compareTo(bMinutes);
          });
        }
      }
    });
  }

  void _deleteItem(CalendarItem item) {
    setState(() {
      final key = _dateKey(item.date);
      if (_itemsMap.containsKey(key)) {
        _itemsMap[key]!.removeWhere((i) => i.id == item.id);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.isEvent ? "Event" : "Task"} deleted'),
        backgroundColor: _sheetBgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: _fontColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: _fontColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Top 40% height for Table Calendar
              SizedBox(
                height: constraints.maxHeight * 0.40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CalendarView(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
              ),

              // Bottom 60% height for Timeline / Upcoming Tasks
              SizedBox(
                height: constraints.maxHeight * 0.60,
                child: UpcomingTasksView(
                  selectedDate: _selectedDay,
                  items: _selectedDayItems,
                  selectedItemId: _selectedItemId,
                  onSelectItem: (item) {
                    setState(() {
                      _selectedItemId = item.id;
                    });
                  },
                  onEditItem: (item) => _showItemFormModal(context, existingItem: item),
                  onDeleteItem: _deleteItem,
                ),
              ),
            ],
          );
        },
      ),

      // Bottom Right Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: _highlightColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () => _showItemFormModal(context),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  /// Opens full form modal for Adding or Editing an Event
  void _showItemFormModal(
    BuildContext context, {
    CalendarItem? existingItem,
  }) {
    final isEditing = existingItem != null;
    final titleController = TextEditingController(text: existingItem?.title ?? '');
    final descController = TextEditingController(text: existingItem?.description ?? '');

    TimeOfDay startTime = existingItem?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = existingItem?.endTime ?? const TimeOfDay(hour: 10, minute: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _sheetBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _fontColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isEditing ? 'Edit Event' : 'New Event',
                    style: const TextStyle(
                      color: _fontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Parameter 1: Title Input
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: _fontColor),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: _fontColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: _bgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Parameter 2: Description Input
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: _fontColor),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: _fontColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: _bgColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Parameter 3: Start Time & End Time as text inputs
                  Row(
                    children: [
                      // Start Time Input
                      Expanded(
                        child: _TimeInputField(
                          label: 'Start Time',
                          time: startTime,
                          onChanged: (newTime) {
                            setModalState(() {
                              startTime = newTime;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // End Time Input
                      Expanded(
                        child: _TimeInputField(
                          label: 'End Time',
                          time: endTime,
                          onChanged: (newTime) {
                            setModalState(() {
                              endTime = newTime;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Save Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _highlightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return;

                        if (isEditing) {
                          final updated = existingItem.copyWith(
                            title: title,
                            description: descController.text.trim(),
                            startTime: startTime,
                            endTime: endTime,
                          );
                          _editItem(updated);
                        } else {
                          final newItem = CalendarItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: title,
                            description: descController.text.trim(),
                            startTime: startTime,
                            endTime: endTime,
                            date: _selectedDay,
                            isEvent: true,
                          );
                          _addItem(newItem);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(
                        isEditing ? 'Save Changes' : 'Create',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// A simple text-based time input field (HH : MM) — no clock dial.
class _TimeInputField extends StatefulWidget {
  final String label;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimeInputField({
    required this.label,
    required this.time,
    required this.onChanged,
  });

  @override
  State<_TimeInputField> createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<_TimeInputField> {
  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);
  static const Color _highlightColor = Color(0xFFCD0033);

  late TextEditingController _hourController;
  late TextEditingController _minuteController;

  @override
  void initState() {
    super.initState();
    _hourController = TextEditingController(
      text: widget.time.hour.toString().padLeft(2, '0'),
    );
    _minuteController = TextEditingController(
      text: widget.time.minute.toString().padLeft(2, '0'),
    );
  }

  @override
  void didUpdateWidget(covariant _TimeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.time != widget.time) {
      _hourController.text = widget.time.hour.toString().padLeft(2, '0');
      _minuteController.text = widget.time.minute.toString().padLeft(2, '0');
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _emitChange() {
    final hour = int.tryParse(_hourController.text) ?? 0;
    final minute = int.tryParse(_minuteController.text) ?? 0;
    widget.onChanged(TimeOfDay(
      hour: hour.clamp(0, 23),
      minute: minute.clamp(0, 59),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: _fontColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // Hour input
              SizedBox(
                width: 36,
                child: TextField(
                  controller: _hourController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  style: const TextStyle(
                    color: _fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _fontColor.withOpacity(0.2)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: _highlightColor, width: 2),
                    ),
                  ),
                  onChanged: (_) => _emitChange(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  ':',
                  style: TextStyle(
                    color: _fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Minute input
              SizedBox(
                width: 36,
                child: TextField(
                  controller: _minuteController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  style: const TextStyle(
                    color: _fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: _fontColor.withOpacity(0.2)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: _highlightColor, width: 2),
                    ),
                  ),
                  onChanged: (_) => _emitChange(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
