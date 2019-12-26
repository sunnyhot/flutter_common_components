import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';

/// [JDLStepper]
class StepperDemoPage extends StatefulWidget {
  @override
  _StepperDemoPageState createState() => _StepperDemoPageState();
}

class _StepperDemoPageState extends State<StepperDemoPage> {
  int _step = 1;
  bool get _isFirst => _step == 1;
  bool get _isLast => _step == 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper'),
        centerTitle: true,
        leading: StoneBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildStepper(),
        Expanded(child: _buildContent()),
        _buildBottomToolbar(),
      ],
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: JDlStepper(
          step: _step,
          titles: <String>['第1步', '第2步', '第3步', '第4步'],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: IndexedStack(
        index: _step - 1,
        sizing: StackFit.expand,
        children: <Widget>[
          _buildCard(color: Colors.cyan, number: 1),
          _buildCard(color: Colors.red, number: 2),
          _buildCard(color: Colors.green, number: 3),
          _buildCard(color: Colors.blue, number: 4),
        ],
      ),
    );
  }

  Widget _buildCard({Color color, int number}) {
    return SizedBox.expand(
      child: Card(
        color: color,
        child: Center(
          child: Text(
            number.toString(),
            style: AppTextStyles.whiteW600(fontSize: 80.0).copyWith(
              shadows: <ui.Shadow>[ui.Shadow(color: Colors.black45, offset: Offset(2.0, 2.0), blurRadius: 4.0)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return StoneBottomToolbar(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StoneButton(
              onPressed: _isFirst ? null : () => setState(() => _step--),
              styleKey: AppButtonStyles.whiteStadiumRaised.key,
              height: 40.0,
              child: Text('上一步'),
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: StoneButton(
              onPressed: _isLast ? null : () => setState(() => _step++),
              styleKey: AppButtonStyles.whiteStadiumRaised.key,
              height: 40.0,
              child: Text('下一步'),
            ),
          ),
        ],
      ),
    );
  }
}