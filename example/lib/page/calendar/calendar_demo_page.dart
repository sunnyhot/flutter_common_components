import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';

const _kAppBarHeight = 56.0;

/// [StoneCalendar]、[StoneCalendarSheet]、[showJDLBottomSheet]
class StoneCalendarDemoPage extends StatefulWidget {
  @override
  _StoneCalendarDemoPageState createState() => _StoneCalendarDemoPageState();
}

class _StoneCalendarDemoPageState extends State<StoneCalendarDemoPage> {
  DateTime _firstDate = DateTime(2019, 1, 16);
  DateTime _lastDate = DateTime(2020, 12, 15);
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBody(),
          _buildAppBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final themeData = ThemeData(
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          button: Theme.of(context).appBarTheme.textTheme.button.copyWith(color: AppColors.white),
        ),
      ),
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: Row(children: <Widget>[StoneBackButton()])),
        Text('Calendar', style: Theme.of(context).appBarTheme.textTheme.title.copyWith(color: AppColors.white)),
        Expanded(child: SizedBox()),
      ],
    );

    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: SizedBox(
        height: _kAppBarHeight,
        child: Theme(data: themeData, child: content),
      ),
    );
  }

  Widget _buildBody() {
    final calendar = Container(
      padding: EdgeInsets.all(4.0),
      height: 420,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.black12, blurRadius: 8.0, offset: Offset(0.0, 4.0)),
        ],
      ),
      child: JDLCalendar(
        onSelected: (newDate) => setState(() => _selectedDate = newDate),
        selectedDate: _selectedDate,
        firstDate: _firstDate,
        lastDate: _lastDate,
      ),
    );

    final dateButton = Container(
      child: StoneButton(
        onPressed: () => showJDLCalendarSheet(
          context: context,
          title: '请选择出发日期',
          onSelected: (newDate) => setState(() => _selectedDate = newDate),
          selectedDate: _selectedDate,
          firstDate: _firstDate,
          lastDate: _lastDate,
        ),
        textStyle: AppTextStyles.whiteW600(fontSize: 32.0).copyWith(
          shadows: <ui.Shadow>[ui.Shadow(color: Colors.black45, offset: Offset(2.0, 2.0), blurRadius: 4.0)],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text('${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日'),
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(30.0, _kAppBarHeight + 30.0, 30.0, 30.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.purple, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            calendar,
            SizedBox(height: 40.0),
            dateButton,
            SizedBox(height: 16.0),
            Text('点击日期试试看～　', style: AppTextStyles.whiteW400(fontSize: 14.0)),
          ],
        ),
      ),
    );
  }
}