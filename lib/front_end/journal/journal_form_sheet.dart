import 'package:flutter/material.dart';
import 'journal_entry_model.dart';

/// A bottom-sheet form for creating/editing journal entries.
/// Modelled after [EventFormSheet] from the calendar feature.
class JournalFormSheet extends StatefulWidget {
  final JournalEntry? existingEntry;
  final void Function(JournalEntry) onSave;

  const JournalFormSheet({
    super.key,
    this.existingEntry,
    required this.onSave,
  });

  /// Convenience method to present the sheet – mirrors EventFormSheet.show().
  static void show(
    BuildContext context, {
    JournalEntry? existingEntry,
    required void Function(JournalEntry) onSave,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF242423),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (_) => JournalFormSheet(
          existingEntry: existingEntry,
          onSave: onSave,
        ),
      );

  @override
  State<JournalFormSheet> createState() => _JournalFormSheetState();
}

class _JournalFormSheetState extends State<JournalFormSheet> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl = TextEditingController(
    text: widget.existingEntry?.title ?? '',
  );
  late final _descCtrl = TextEditingController(
    text: widget.existingEntry?.description ?? '',
  );

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: fontColor.withValues(alpha: 0.5)),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.existingEntry;
    widget.onSave(
      JournalEntry(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        createdAt: existing?.createdAt ?? DateTime.now(),
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    int lines = 1,
    bool required = false,
  }) =>
      Padding(
        padding: const EdgeInsets.all(14),
        child: TextFormField(
          controller: ctrl,
          style: const TextStyle(color: fontColor),
          maxLines: lines,
          validator: required
              ? (v) =>
                  (v == null || v.trim().isEmpty) ? '$label is required' : null
              : null,
          decoration: _decoration(label),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final String sheetTitle =
        widget.existingEntry != null ? 'Edit Journal' : 'Add Journal';

    return Padding(
      padding: EdgeInsets.all(24).copyWith(
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle Pill
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: fontColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sheet Title
            Text(
              sheetTitle,
              style: const TextStyle(
                color: fontColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Title Input (Required)
            _buildField('Title', _titleCtrl, required: true),
            // Description Input (3 lines, Optional)
            _buildField('Description', _descCtrl, lines: 3),
            const SizedBox(height: 14),
            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submit,
              child: Text(
                widget.existingEntry != null ? 'Save Changes' : 'Create',
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
  }
}
