import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calendar_item_model.dart';

class UpcomingTasksView extends StatefulWidget {
  final DateTime selectedDate;
  final List<CalendarItem> items;
  final String? selectedItemId;
  final Function(CalendarItem)? onSelectItem;
  // CRUD call_back function
  final Function(CalendarItem) onEditItem;
  final Function(CalendarItem) onDeleteItem;

  const UpcomingTasksView({
    super.key,
    required this.selectedDate,
    required this.items,
    this.selectedItemId, //selected item is optional
    this.onSelectItem,
    // CRUD call_back function
    required this.onEditItem,
    required this.onDeleteItem,
  });

  @override
  State<UpcomingTasksView> createState() => _UpcomingTasksViewState();
}

// state Creation
class _UpcomingTasksViewState extends State<UpcomingTasksView> {
  static const Color backgroundColor = Color.fromARGB(255, 27, 27, 26);
  static const Color fontColor = Color.fromARGB(255, 255, 244, 224);
  static const Color accentColor = Color.fromARGB(255, 205, 0, 51);

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final dayItems = widget.items.where((item) {
      return item.date.year == widget.selectedDate.year &&
          item.date.month == widget.selectedDate.month &&
          item.date.day == widget.selectedDate.day;
    }).toList();

    final dateHeader = DateFormat('EEE, MMM d').format(widget.selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events for $dateHeader',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: fontColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${dayItems.length} Events',
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
        Expanded(
          child: dayItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_available,
                        size: 44,
                        color: fontColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Events for $dateHeader',
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
                  itemCount: dayItems.length,
                  itemBuilder: (context, index) {
                    final item = dayItems[index];
                    final isSelected = item.id == widget.selectedItemId;
                    // inkwell to make widget touch interactive and clickable with subtle animation
                    return InkWell(
                      onTap: () => widget.onSelectItem?.call(item),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? accentColor
                                : fontColor.withValues(alpha: .2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item.isEvent
                                    ? accentColor
                                    : fontColor.withValues(alpha: .5),
                                shape: BoxShape.circle,//dot for event
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: fontColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: fontColor.withValues(alpha: .6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: accentColor,
                              ),
                              onPressed: () => widget.onEditItem(item),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: accentColor,
                              ),
                              onPressed: () => widget.onDeleteItem(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
