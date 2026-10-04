import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'journal_entry_model.dart';
import 'journal_form_sheet.dart';
import 'journal_service.dart';

/// Full-page screen that lists all saved journal entries.
/// Modelled after [UpcomingTasksView] – same colour scheme, card style,
/// empty state, and edit/delete actions.
class MyJournalListScreen extends StatefulWidget {
  const MyJournalListScreen({super.key});

  @override
  State<MyJournalListScreen> createState() => _MyJournalListScreenState();
}

class _MyJournalListScreenState extends State<MyJournalListScreen> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

  @override
  void initState() {
    super.initState();
    JournalService.instance.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    JournalService.instance.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  List<JournalEntry> get _entries => JournalService.instance.entries;

  void _editEntry(JournalEntry entry) {
    JournalService.instance.editEntry(entry);
  }

  void _deleteEntry(JournalEntry entry) {
    JournalService.instance.deleteEntry(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Journal',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row – mirrors UpcomingTasksView header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Journals',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: fontColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_entries.length} Entries',
                    style: const TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List / empty state
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          size: 44,
                          color: fontColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Journal Entries Yet',
                          style: TextStyle(
                            color: fontColor.withValues(alpha: .3),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: fontColor.withValues(alpha: .2),
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
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Title + description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: const TextStyle(
                                      color: fontColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (entry.description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            fontColor.withValues(alpha: .6),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM d, yyyy – hh:mm a')
                                        .format(entry.createdAt),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: fontColor.withValues(alpha: .35),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Edit button
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: accentColor,
                              ),
                              onPressed: () {
                                JournalFormSheet.show(
                                  context,
                                  existingEntry: entry,
                                  onSave: _editEntry,
                                );
                              },
                            ),

                            // Delete button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: accentColor,
                              ),
                              onPressed: () => _deleteEntry(entry),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
