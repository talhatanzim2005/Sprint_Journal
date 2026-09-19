import 'package:flutter/material.dart';

class TaskItem {
  String id;
  String title;
  String description;

  TaskItem({required this.id, required this.title, required this.description});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color backgroundColor = Color(0xFF121212);
  static const Color accentColor = Color(0xFFCD0033);
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Colors.white70;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskItem> _tasks = [];

  void _deleteTask(TaskItem task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  void _showTaskForm({TaskItem? task}) {
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF242423),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: HomeScreen.primaryText.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  task != null ? 'Edit Task' : 'Add Task',
                  style: const TextStyle(
                    color: HomeScreen.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleCtrl,
                  style: const TextStyle(color: HomeScreen.primaryText),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                        color: HomeScreen.primaryText.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1B1B1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: descCtrl,
                  style: const TextStyle(color: HomeScreen.primaryText),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                        color: HomeScreen.primaryText.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1B1B1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomeScreen.accentColor,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    setState(() {
                      if (task == null) {
                        _tasks.add(
                          TaskItem(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            title: titleCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                          ),
                        );
                      } else {
                        task.title = titleCtrl.text.trim();
                        task.description = descCtrl.text.trim();
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    task != null ? 'Save Changes' : 'Create',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeScreen.backgroundColor,
      width: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // GREETING
              // =========================

              const Text(
                "Good Morning,",
                style: TextStyle(
                  color: HomeScreen.primaryText,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 3),

              const Text(
                "Reshad 👋",
                style: TextStyle(
                  color: HomeScreen.accentColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Let's make today productive.",
                style: TextStyle(
                  color: HomeScreen.secondaryText,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              // =========================
              // TODAY'S FOCUS
              // =========================

              const Text(
                "Today's Focus",
                style: TextStyle(
                  color: HomeScreen.primaryText,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildProgressCard(),

              const SizedBox(height: 35),

              // =========================
              // TASKS
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tasks",
                    style: TextStyle(
                      color: HomeScreen.primaryText,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: HomeScreen.accentColor),
                    onPressed: () => _showTaskForm(),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ..._tasks.map((task) => _buildTaskItem(task)),

              if (_tasks.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "No tasks yet. Tap + to add one.",
                      style: TextStyle(
                        color: HomeScreen.secondaryText.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HomeScreen.primaryText.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: HomeScreen.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: HomeScreen.primaryText,
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
                      color: HomeScreen.primaryText.withValues(alpha: .6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: HomeScreen.accentColor,
            ),
            onPressed: () => _showTaskForm(task: task),
          ),
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

  // =========================================================
  // PROGRESS CARD
  // =========================================================

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HomeScreen.accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Icon + Title
          Row(
            children: const [
              Icon(
                Icons.track_changes,
                color: Colors.white,
                size: 28,
              ),

              SizedBox(width: 12),

              Text(
                "Today's Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Progress number
          const Text(
            "3 / 5",
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            "Tasks Completed",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 20),

          // Progress bar
          Row(
            children: [

              Expanded(
                child: Container(
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                "60%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Small steps create big results.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}