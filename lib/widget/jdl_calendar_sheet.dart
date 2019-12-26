import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/widget/jdl_bottom_sheet.dart';
import 'package:jdl_flutter_kit/widget/jdl_calendar.dart';

/// 选择日历的面板
class _CalendarPanel extends StatefulWidget {
  const _CalendarPanel({
    this.onSelected,
    this.selectedDate,
    @required this.firstDate,
    @required this.lastDate,
  });

  /// 选择了新日期后的回调
  final ValueChanged<DateTime> onSelected;
  /// 已经选中的日期
  final DateTime selectedDate;
  /// 可以选择的最早日期
  final DateTime firstDate;
  /// 可以选择的最晚日期
  final DateTime lastDate;

  @override
  _CalendarPanelState createState() => _CalendarPanelState();
}

class _CalendarPanelState extends State<_CalendarPanel> {
  /// 当前选中的日期
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.0,
      child: SizedBox.expand(
        child: JDLCalendar(
          onSelected: (date) => setState(() {
            _selectedDate = date;
            Future.delayed(Duration(milliseconds: 150), () {
              widget.onSelected(date);
              Navigator.pop(context);
            });
          }),
          selectedDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
        ),
      ),
    );
  }
}

/// 显示日历选择器
Future<T> showJDLCalendarSheet<T>({
  @required BuildContext context,
  String title,
  bool showsSeparator: true,
  @required ValueChanged<DateTime> onSelected,
  DateTime selectedDate,
  DateTime firstDate,
  DateTime lastDate,
}) {
  return showJDLBottomSheet(
    context: context,
    title: title,
    showsSeparator: showsSeparator,
    builder: (BuildContext context) => _CalendarPanel(
      onSelected: onSelected,
      selectedDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}