import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// 月视图表头内边距
const _kHeaderTopPadding = 8.0;
/// 月视图表头的高度
const _kHeaderHeight = 60.0;
/// GridView 左右内边距
const _kHorizontalPadding = 8.0;
/// GridView Item 内容的大小
const _kItemContentSize = 40.0;

/// 日历组件
class JDLCalendar extends StatefulWidget {
  const JDLCalendar({
    Key key,
    this.onSelected,
    this.selectedDate,
    @required this.firstDate,
    @required this.lastDate,
  }) : super(key: key);


  /// 选择了新日期后的回调
  final ValueChanged<DateTime> onSelected;
  /// 已经选中的日期
  final DateTime selectedDate;
  /// 可以选择的最早日期
  final DateTime firstDate;
  /// 可以选择的最晚日期
  final DateTime lastDate;

  @override
  _JDLCalendarState createState() => _JDLCalendarState();
}

class _JDLCalendarState extends State<JDLCalendar> {
  GlobalKey _scrollViewKey = GlobalKey();
  
  /// 可以选择的最早日期
  DateTime _startDate;
  /// 可以选择的最晚日期
  DateTime _endDate;
  /// 月视图中的模型列表
  List<_MonthModel> _monthModels = [];
  /// CustomScrollView 的控制器
  ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();

    // 计算可以选择的最早日期
    final startYear = widget.firstDate.year;
    final startMonth = widget.firstDate.month;
    _startDate = DateTime(startYear, startMonth, widget.firstDate.day);

    // 计算可以选择的最晚日期
    final endYear = widget.lastDate.year;
    final endMonth = widget.lastDate.month;
    _endDate = DateTime(endYear, endMonth, widget.lastDate.day);

    // 计算月视图中的模型列表
    final monthCount = (endMonth - startMonth) + ((endYear - startYear) * 12) + 1;
    for (int i = 0; i < monthCount; i++) {
      final year = startYear + ((startMonth + i) ~/ 13);
      final month = () {
        final temp = (startMonth + i) % 12;
        return temp == 0 ? 12 : temp;
      }();

      _monthModels.add(_MonthModel(year, month));
    }

    // 如果有默认选中的日期，对列表设置初始偏移量
    if (widget.selectedDate != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final itemSize = (_scrollViewKey.currentContext.size.width - _kHorizontalPadding * 2) / 7;
        final monthCount = (widget.selectedDate.month - startMonth) + ((widget.selectedDate.year - startYear) * 12);
        final offset = _monthModels
            .take(monthCount)
            .map((monthModel) => _kHeaderHeight + (itemSize * monthModel.lines))
            .reduce((v, e) => v + e);
        _scrollController.jumpTo(offset);
      });
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[];
    for (int i = 0; i < _monthModels.length; i++) {
      final monthModel = _monthModels[i];
      final itemCount = 7 * monthModel.lines;

      // 月视图的表头
      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(top: _kHeaderTopPadding),
            alignment: Alignment.center,
            height: _kHeaderHeight,
            child: Text(
              '${monthModel.year}年${monthModel.month}月',
              style: TextStyle(color: Color(0xFF2F2F2F), fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );

      // 月视图的内容
      slivers.add(
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
          sliver: SliverGrid.count(
            crossAxisCount: 7,
            children: List<int>.generate(itemCount, (index) => index).map((index) =>
              _buildDayItem(
                month: monthModel,
                index: index,
              ),
            ).toList(),
          ),
        ),
      );
    }

    return CustomScrollView(
      key: _scrollViewKey,
      controller: _scrollController,
      slivers: slivers,
    );
  }

  Widget _buildDayItem({_MonthModel month, int index}) {
    final buildContent = (int day, bool inRange, bool selected) => Container(
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        gradient: !selected ? null : LinearGradient(
          colors: <Color>[Color(0xFFF20000), Color(0xFFFF4F18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: CircleBorder(),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: inRange
                ? selected ? Colors.white : Color(0xFF2F2F2F)
                : Color(0xFFE6E6E6),
            fontSize: 15.0,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );

    final dayInMonth = index + 1 >= month.startWeekday && index < month.startWeekday - 1 + month.days;

    if (!dayInMonth) {
      return Container();
    }

    // 日
    final day = index - month.startWeekday + 2;
    // 当前日期
    final date = DateTime(month.year, month.month, day);

    // 是否在可选择的日期范围内
    final inRange = date.millisecondsSinceEpoch >= _startDate.millisecondsSinceEpoch
        && date.millisecondsSinceEpoch <= _endDate.millisecondsSinceEpoch;

    // 当前日期是否被选中
    final selected = date.year == widget.selectedDate?.year
        && date.month == widget.selectedDate?.month
        && date.day == widget.selectedDate?.day;

    return Center(
      child: SizedBox(
        width: _kItemContentSize,
        height: _kItemContentSize,
        child: GestureDetector(
          onTap: !inRange || widget.onSelected == null ? null : () => widget.onSelected(date),
          child: buildContent(day, inRange, selected),
        ),
      ),
    );
  }
}

/// 用在月视图中的模型
class _MonthModel {
  _MonthModel(this.year, this.month) {
    days = daysInMonth(year, month);
    startWeekday = DateTime(year, month, 1).weekday + 1;
    startWeekday = startWeekday == 8 ? 1 : startWeekday;
    lines = ((startWeekday - 2 + days) ~/ 7) + 1;
  }

  /// 月份所属的年份
  int year;
  /// 当前月份
  int month;
  /// 此月的天数
  int days;
  /// 此月展示时在 GirdView 中需要的行数
  int lines;
  /// 此月第一天是星期几（1～7，周日～周六）
  int startWeekday;

  @override
  String toString() => 'Month(year: $year, month: $month, days: $days, lines: $lines, startWeekday: $startWeekday)';
}

/// 判断某年是否为闰年
bool isLeapYear(int year) => ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);

/// 计算某个月的天数
int daysInMonth(int year, int month) {
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
    return 31;
  }

  if (month == 2) {
    return isLeapYear(year) ? 29 : 28;
  }

  return 30;
}