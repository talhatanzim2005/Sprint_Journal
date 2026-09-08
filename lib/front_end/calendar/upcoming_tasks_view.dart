import 'package:flutter/material.dart';

import 'calendar_item_model.dart';

class UpcomingTasksView extends StatefulWidget {
  final DateTime selectedDate;
  final List<CalendarItem> items;
  final String? selectedItemId;
  final Function(CalendarItem item)? onSelectItem;
  final Function(CalendarItem item) onEditItem;
  final Function(CalendarItem item) onDeleteItem;

  const UpcomingTasksView({
    super.key,
    required this.selectedDate,
    required this.items,
    this.selectedItemId,
    this.onSelectItem,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  @override
  State<UpcomingTasksView> createState() => _UpcomingTasksViewState();
}

class _UpcomingTasksViewState extends State<UpcomingTasksView> {
  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);
  static const Color _highlightColor = Color(0xFFCD0033);

  final ScrollController _scrollController = ScrollController();
  double _scrollThumbPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) {
      setState(() => _scrollThumbPosition = 0.0);
      return;
    }
    setState(() {
      _scrollThumbPosition = (_scrollController.offset / maxExtent).clamp(
        0.0,
        1.0,
      );
    });
  }

  bool get _isToday {
    final now = DateTime.now();
    return widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;
  }

  String get _headerTitle {
    if (_isToday) return 'Today';
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${widget.selectedDate.day} ${months[widget.selectedDate.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _fontColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _headerTitle,
                  style: const TextStyle(
                    color: _fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.items.length} ${widget.items.length == 1 ? 'event' : 'events'}',
                  style: TextStyle(
                    color: _fontColor.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: widget.items.isEmpty
                ? _buildEmptyState()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final trackHeight = constraints.maxHeight;
                      const thumbHeight = 48.0;
                      final maxThumbOffset = trackHeight - thumbHeight - 16;

                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.only(bottom: 80.0),
                              itemCount: widget.items.length,
                              itemBuilder: (context, index) {
                                final item = widget.items[index];
                                final isFirst = index == 0;
                                final isLast = index == widget.items.length - 1;
                                return TimelineRowItem(
                                  item: item,
                                  isFirst: isFirst,
                                  isLast: isLast,
                                  onEditItem: widget.onEditItem,
                                  onDeleteItem: widget.onDeleteItem,
                                  onSelectItem: widget.onSelectItem,
                                );
                              },
                            ),
                          ),

                          Positioned(
                            right: 2,
                            top:
                                8 +
                                (_scrollThumbPosition * maxThumbOffset).clamp(
                                  0.0,
                                  maxThumbOffset,
                                ),
                            child: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                if (!_scrollController.hasClients) return;
                                final maxExtent =
                                    _scrollController.position.maxScrollExtent;
                                if (maxExtent <= 0) return;

                                final dragProportion =
                                    details.delta.dy / maxThumbOffset;
                                final newOffset =
                                    _scrollController.offset +
                                    (dragProportion * maxExtent);
                                _scrollController.jumpTo(
                                  newOffset.clamp(0.0, maxExtent),
                                );
                              },
                              child: Container(
                                width: 22,
                                height: thumbHeight,
                                decoration: BoxDecoration(
                                  color: _highlightColor,
                                  borderRadius: BorderRadius.circular(11),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _highlightColor.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 2,
                                        margin: const EdgeInsets.only(
                                          bottom: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 2,
                                        margin: const EdgeInsets.only(
                                          bottom: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_rounded,
            size: 48,
            color: _fontColor.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Text(
            'No events or tasks scheduled',
            style: TextStyle(
              color: _fontColor.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap the + button to add one',
            style: TextStyle(color: _fontColor.withOpacity(0.3), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class TimelineRowItem extends StatefulWidget {
  final CalendarItem item;
  final bool isFirst;
  final bool isLast;
  final Function(CalendarItem item) onEditItem;
  final Function(CalendarItem item) onDeleteItem;
  final Function(CalendarItem item)? onSelectItem;

  static const Color _bgColor = Color(0xFF1B1B1A);
  static const Color _fontColor = Color(0xFFFFF4E0);
  static const Color _highlightColor = Color(0xFFCD0033);
  static const Color _cardBgColor = Color(0xFF242423);

  const TimelineRowItem({
    super.key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.onEditItem,
    required this.onDeleteItem,
    this.onSelectItem,
  });

  @override
  State<TimelineRowItem> createState() => _TimelineRowItemState();
}

class _TimelineRowItemState extends State<TimelineRowItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = _isHovered;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.item.startTimeString,
                  style: const TextStyle(
                    color: TimelineRowItem._fontColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.item.endTimeString,
                  style: TextStyle(
                    color: TimelineRowItem._fontColor.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: widget.isFirst ? 18 : 0,
                  bottom: widget.isLast ? 18 : 0,
                  child: Container(
                    width: 2,
                    color: TimelineRowItem._highlightColor.withOpacity(0.7),
                  ),
                ),
                Positioned(
                  top: 16,
                  child: isHighlighted
                      ? Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TimelineRowItem._bgColor,
                            border: Border.all(
                              color: TimelineRowItem._fontColor,
                              width: 3,
                            ),
                          ),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: TimelineRowItem._highlightColor,
                          ),
                        ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: GestureDetector(
                onDoubleTap: () => widget.onEditItem(widget.item),
                onLongPress: () => widget.onEditItem(widget.item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? TimelineRowItem._highlightColor
                        : TimelineRowItem._cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isHighlighted
                        ? [
                            BoxShadow(
                              color: TimelineRowItem._highlightColor
                                  .withOpacity(0.45),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.item.title,
                              style: TextStyle(
                                color: isHighlighted
                                    ? Colors.white
                                    : TimelineRowItem._fontColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (widget.item.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.item.description,
                                style: TextStyle(
                                  color: isHighlighted
                                      ? Colors.white.withOpacity(0.85)
                                      : TimelineRowItem._fontColor.withOpacity(
                                          0.6,
                                        ),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: isHighlighted
                              ? Colors.white.withOpacity(0.8)
                              : TimelineRowItem._fontColor.withOpacity(0.5),
                          size: 20,
                        ),
                        color: TimelineRowItem._cardBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            widget.onEditItem(widget.item);
                          } else if (value == 'delete') {
                            widget.onDeleteItem(widget.item);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  color: TimelineRowItem._fontColor,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: TimelineRowItem._fontColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: TimelineRowItem._highlightColor,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: TimelineRowItem._highlightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
