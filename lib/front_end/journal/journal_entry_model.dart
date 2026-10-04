/// A simple model representing a saved journal entry.
class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  JournalEntry copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) =>
      JournalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );
}
