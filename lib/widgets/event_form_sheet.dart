import 'package:flutter/material.dart';
import '../front_end/calendar/calendar_item_model.dart';

class EventFormSheet extends StatefulWidget {
  final DateTime selectedDay;
  final CalendarItem? existingItem;
  final bool isTask;// task true means start time and end times are hidden
  final void Function(CalendarItem) onSave;

  const EventFormSheet({
    super.key,
    required this.selectedDay, //data on selected date
    this.existingItem,
    this.isTask = false,
    required this.onSave,
  });
  //bottom sheet open widget funtionality
  static void show(
    BuildContext context, {
    required DateTime selectedDay,
    CalendarItem? existingItem,
    bool isTask = false,
    required void Function(CalendarItem) onSave,//save callback function
  }) => showModalBottomSheet(// returns bottom sheet
    context: context,
    isScrollControlled: true,// aloow bottom sheet to appear at true height
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
  //ensuring changable sheet between task and envent
  State<EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<EventFormSheet> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

  final _formKey = GlobalKey<FormState>();//creates uniqe id for the form
  late final _titleCtrl = TextEditingController(
    text: widget.existingItem?.title ?? '',//calener item er modhe title er user likhe ta save hoi otherwise empty
  );
  late final _descCtrl = TextEditingController(
    text: widget.existingItem?.description ?? '',//calener item er modhe description er user likhe ta save hoi otherwise empty
  );

  // default start and end times
  late TimeOfDay _startTime =
      widget.existingItem?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
  late TimeOfDay _endTime =
      widget.existingItem?.endTime ?? const TimeOfDay(hour: 10, minute: 0);

  late final _startCtrl = TextEditingController(
    text: widget.existingItem != null
        ? '${widget.existingItem!.startTime.hourOfPeriod}:${widget.existingItem!.startTime.minute.toString().padLeft(2, '0')}'
        : '',
  );
  late final _endCtrl = TextEditingController(
    text: widget.existingItem != null
        ? '${widget.existingItem!.endTime.hourOfPeriod}:${widget.existingItem!.endTime.minute.toString().padLeft(2, '0')}'
        : '',
  );

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }
  //by default word  inside the editable box we see 
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

  //the submission handler function
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // ensure that user has provided necessary information
    final editedItem = widget.existingItem;
    widget.onSave(
      //CalendarItem constructor creates and initializes a new instance or object
      CalendarItem(
        id: editedItem?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),//reuses exiting Id or generate a uniqe Id using default time
        title: _titleCtrl.text.trim(),//Captures title text from input field and removes before and after extra spacing 
        description: _descCtrl.text.trim(),//Captures description text from input field and removes before and after extra spacing 
        startTime: _startTime,
        endTime: _endTime,
        date: editedItem?.date ?? widget.selectedDay,//ensure task or event created on selected day
        isEvent: editedItem?.isEvent ?? !widget.isTask,//determines if item is a event or a task
      ),
    );
    Navigator.pop(context);//sheet slide down 
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    int lines = 1,
    bool required = false,
  }) => Padding(
    padding: const EdgeInsets.all(14),
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

  @override
  Widget build(BuildContext context) {
    final String sheetTitle = widget.existingItem != null
        ? (widget.isTask ? 'Edit Task' : 'Edit Event')
        : (widget.isTask ? 'Add Task' : 'Add Event');

    return Padding(
      padding: EdgeInsets.all(24).copyWith(
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24, //when click on buildfied text default text push up
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
                  Expanded(child: _buildField('Start Time', _startCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildField('End Time', _endCtrl)),
                ],
              ),
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
