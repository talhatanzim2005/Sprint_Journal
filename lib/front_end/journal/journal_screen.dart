import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);
  static const Color cardColor = Color.fromARGB(255, 36, 36, 35);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  _DailyJournal get todayEntry => _DailyJournal(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTodayEntry() {
    // Save entry logic / persist state
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateDisplay = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Title
              const Text(
                'Thinker Log!',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                'Have Clarity in five simple minutes',
                style: TextStyle(
                  color: fontColor.withValues(alpha: 0.65),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // Date Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TODAY\'S LOG',
                    style: TextStyle(
                      color: accentColor.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    dateDisplay,
                    style: TextStyle(
                      color: fontColor.withValues(alpha: 0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Journal Box Card
              Container(
                padding: const EdgeInsets.all(16),
                
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: fontColor.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Input
                    TextField(
                      controller: _titleController,
                      onChanged: (_) => _saveTodayEntry(),
                      style: const TextStyle(
                        color: fontColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: fontColor.withValues(alpha: 0.35),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Divider(
                      color: fontColor.withValues(alpha: 0.1),
                      height: 1,
                    ),
                    const SizedBox(height: 12),

                    // Description Input (max 306 chars, flexible lines)
                    TextField(
                      controller: _descController,
                      maxLength: 246,
                      maxLines: 7,
                      minLines: 7,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (_) {
                        _saveTodayEntry();
                        setState(() {}); // refresh counter UI if needed
                      },
                      style: const TextStyle(
                        color: fontColor,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'What\'s on your mind today?',
                        hintStyle: TextStyle(
                          color: fontColor.withValues(alpha: 0.35),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          color: fontColor.withValues(alpha: 0.4),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyJournal {
  final String title;
  final String description;

  const _DailyJournal({
    required this.title,
    required this.description,
  });
}
