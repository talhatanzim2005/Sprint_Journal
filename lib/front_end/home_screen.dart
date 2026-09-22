import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/event_form_sheet.dart';
import 'calendar/calendar_item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);
  static const Color cardColor = Color.fromARGB(255, 36, 36, 35);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CalendarItem> _tasks = [];

  void _addTask(CalendarItem task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _editTask(CalendarItem task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
    });
  }

  void _deleteTask(CalendarItem task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateHeader = DateFormat('EEE, MMM d').format(now);

    return Scaffold(
      backgroundColor: HomeScreen.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text(
                "Good Morning,",
                style: TextStyle(
                  color: HomeScreen.fontColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                "Mr.Talha",
                style: TextStyle(
                  color: HomeScreen.accentColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Let's make today productive.",
                style: TextStyle(
                  color: HomeScreen.fontColor.withValues(alpha: 0.7),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),




              // Task Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task for $dateHeader',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HomeScreen.fontColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: HomeScreen.accentColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_tasks.length} Tasks',
                      style: const TextStyle(
                        color: HomeScreen.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),




              // task list
              if (_tasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_available,
                          size: 44,
                          color: HomeScreen.fontColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Tasks for $dateHeader',
                          style: TextStyle(
                            color: HomeScreen.fontColor.withValues(alpha: .3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._tasks.map((task) => _buildTaskItem(task)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HomeScreen.accentColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          EventFormSheet.show(
            context,
            selectedDay: now,
            isTask: true,
            onSave: _addTask,
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildTaskItem(CalendarItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HomeScreen.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HomeScreen.fontColor.withValues(alpha: .2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Red dot indicator
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: HomeScreen.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: HomeScreen.fontColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: HomeScreen.fontColor.withValues(alpha: .6),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Edit button
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: HomeScreen.accentColor,
            ),
            onPressed: () {
              EventFormSheet.show(
                context,
                selectedDay: task.date,
                existingItem: task,
                isTask: true,
                onSave: _editTask,
              );
            },
          ),

          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: HomeScreen.accentColor,
            ),
            onPressed: () => _deleteTask(task),
          ),
        ],
      ),
    );
  }
}