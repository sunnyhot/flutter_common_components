import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';

/// [JDLTitleBar]、[JDLTabBar]
class TabBarDemoPage extends StatefulWidget {
  @override
  _TabBarDemoPageState createState() => _TabBarDemoPageState();
}

class _TabBarDemoPageState extends State<TabBarDemoPage> {
  JDLTabPosition _tabPosition = JDLTabPosition.left;
  bool get _isLeft => _tabPosition == JDLTabPosition.left;
  bool get _isRight => _tabPosition == JDLTabPosition.right;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBar'),
        centerTitle: true,
        leading: StoneBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        JDLTitleBar(title: '订单支付', subtitle: 'JD18778'),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTabBar(),
                _buildContent(),
              ],
            ),
          ),
        ),
        _buildBottomToolbar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return JDLTabBar(
      onChanged: (val) => setState(() => _tabPosition = val),
      selected: _tabPosition,
      leftTitle: '现金支付',
      rightTitle: '扫码支付',
      showsShadow: true,
    );
  }

  Widget _buildContent() {
    return AspectRatio(
      aspectRatio: 1.2,
      child: IndexedStack(
        index: _isLeft ? 0 : 1,
        sizing: StackFit.expand,
        children: <Widget>[
          _buildCard('¥188.88'),
          _buildCard('¥888.88'),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text.toString(),
          style: AppTextStyles.greyW500(fontSize: 40.0)
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return StoneBottomToolbar(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      height: 60.0,
      child: StoneButton(
        onPressed: _onConfirm,
        styleKey: AppButtonStyles.redStadiumRaised.key,
        width: double.infinity,
        height: 40.0,
        child: Text('确认收款'),
      ),
    );
  }

  void _onConfirm() {
    showJDLAlert(
      context: context,
      style: JDLAlertStyle.dialog,
      builder: (context) => JDLAlert(
        title: Text('确定已收到款项？'),
        cancelButton: JDLAlertAction(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        actions: <Widget>[
          StoneCounterBuilder(
            duration: Duration(seconds: 1),
            count: 3,
            builder: (context, number, finished) => JDLAlertAction(
              onPressed: !finished ? null : () => Navigator.pop(context),
              isDefaultAction: true,
              child: Text(!finished ? '好的（${3 - number}）' : '好的'),
            ),
          ),
        ],
      ),
    );
  }
}