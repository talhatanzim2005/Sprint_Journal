import 'package:flutter/foundation.dart';
import 'journal_entry_model.dart';

/// Shared singleton that holds all saved journal entries.
/// Both [JournalScreen] and [MyJournalListScreen] read/write from here.
class JournalService extends ChangeNotifier {
  static final JournalService instance = JournalService._internal();
  JournalService._internal();

  // Shared static list so entries are preserved across instances and hot reloads
  static final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => List.unmodifiable(_entries);

  void addEntry(JournalEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void editEntry(JournalEntry entry) {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      notifyListeners();
    }
  }

  void deleteEntry(JournalEntry entry) {
    _entries.removeWhere((e) => e.id == entry.id);
    notifyListeners();
  }
}
