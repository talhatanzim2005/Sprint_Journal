import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'journal_entry_model.dart';
import 'journal_service.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with AutomaticKeepAliveClientMixin {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);
  static const Color cardColor = Color.fromARGB(255, 36, 36, 35);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _currentEntryId;
  DateTime? _currentCreatedAt;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (JournalService.instance.entries.isNotEmpty) {
      final latest = JournalService.instance.entries.first;
      _currentEntryId = latest.id;
      _currentCreatedAt = latest.createdAt;
      _titleController.text = latest.title;
      _descController.text = latest.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Save or update the current title + description as a journal entry.
  /// The written text is retained on the screen and not removed.
  void _saveJournalEntry() {
    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add a title before saving.'),
          backgroundColor: accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (_currentEntryId != null) {
      // Update existing entry
      JournalService.instance.editEntry(
        JournalEntry(
          id: _currentEntryId!,
          title: title,
          description: description,
          createdAt: _currentCreatedAt ?? DateTime.now(),
        ),
      );
    } else {
      // Create new entry
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      _currentEntryId = id;
      _currentCreatedAt = DateTime.now();
      JournalService.instance.addEntry(
        JournalEntry(
          id: id,
          title: title,
          description: description,
          createdAt: _currentCreatedAt!,
        ),
      );
    }

    // Keep the written text in _titleController and _descController (do not clear)
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Journal saved!'),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

                    // Description Input (max 246 chars, flexible lines)
                    TextField(
                      controller: _descController,
                      maxLength: 246,
                      maxLines: 7,
                      minLines: 7,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (_) {
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
      // + button to save the journal entry
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: _saveJournalEntry,
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
