import 'package:flutter/material.dart';
import '../front_end/calendar/calendar_item_model.dart';

class EventFormSheet extends StatefulWidget {
  final DateTime selectedDay;
  final CalendarItem? existingItem;
  final bool isTask;
  final void Function(CalendarItem) onSave;

  const EventFormSheet({
    super.key,
    required this.selectedDay,
    this.existingItem,
    this.isTask = false,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required DateTime selectedDay,
    CalendarItem? existingItem,
    bool isTask = false,
    required void Function(CalendarItem) onSave,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF242423),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
    ),
    builder: (_) => EventFormSheet(
      selectedDay: selectedDay,
      existingItem: existingItem,
      isTask: isTask,
      onSave: onSave,
    ),
  );
  @override
  State<EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<EventFormSheet> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

  final _formKey = GlobalKey<FormState>();
  late final _titleCtrl = TextEditingController(
    text: widget.existingItem?.title ?? '',
  );
  late final _descCtrl = TextEditingController(
    text: widget.existingItem?.description ?? '',
  );

  // Default start and end times
  late TimeOfDay _startTime =
      widget.existingItem?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
  late TimeOfDay _endTime =
      widget.existingItem?.endTime ?? const TimeOfDay(hour: 10, minute: 0);

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

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: accentColor,
            onPrimary: fontColor,
            surface: backgroundColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => isStart ? _startTime = picked : _endTime = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final editedItem = widget.existingItem;
    widget.onSave(
      CalendarItem(
        id: editedItem?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        startTime: _startTime,
        endTime: _endTime,
        date: editedItem?.date ?? widget.selectedDay,
        isEvent: editedItem?.isEvent ?? !widget.isTask,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    int lines = 1,
    bool required = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: ctrl,
      style: const TextStyle(color: fontColor),
      maxLines: lines,
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
      decoration: _decoration(label),
    ),
  );

  Widget _buildTimeTile(String label, TimeOfDay time, bool isStart) => Expanded(
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: backgroundColor,
      title: Text(
        label,
        style: TextStyle(
          color: fontColor.withValues(alpha: 0.5),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        time.format(context),
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      onTap: () => _pickTime(isStart),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final String sheetTitle = widget.existingItem != null
        ? (widget.isTask ? 'Edit Task' : 'Edit Event')
        : (widget.isTask ? 'Add Task' : 'Add Event');

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle Pill at the top
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
            // Description Input (2 lines, Optional)
            _buildField('Description', _descCtrl, lines: 2),
            // Start Time & End Time Row (Only for events, hidden for tasks)
            if (!widget.isTask) ...[
              Row(
                children: [
                  _buildTimeTile('Start Time', _startTime, true),
                  const SizedBox(width: 12),
                  _buildTimeTile('End', _endTime, false),
                ],
              ),
              const SizedBox(height: 10),
            ],
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
                widget.existingItem != null ? 'Save Changes' : 'Create',
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
