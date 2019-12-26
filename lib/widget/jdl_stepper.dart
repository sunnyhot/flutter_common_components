import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/constant/jdl_colors.dart';

/// 步进器
class JDlStepper extends StatefulWidget {
  const JDlStepper({
    Key key,
    this.titles,
    this.step,
  }) : super(key: key);

  final List<String> titles;
  final int step;

  @override
  _JDlStepperState createState() => _JDlStepperState();
}

class _JDlStepperState extends State<JDlStepper> {
  @override
  Widget build(BuildContext context) {
    final steps = <Widget>[];
    for (var i = 0; i < widget.titles.length; i++) {
      steps.add(
        Expanded(
          child: _buildStep(
            index: i + 1,
            title: widget.titles[i],
            indexed: i + 1 == widget.step,
          ),
        ),
      );
    }

    return Container(height: 50.0, child: Row(children: steps));
  }

  Widget _buildStep({int index, String title, bool indexed}) {
    final indexText = Text(
      index.toString(),
      style: TextStyle(
        color: Color(0xFFFAFAFA),
        fontSize: 12.0,
        fontWeight: indexed ? FontWeight.w400 : FontWeight.w500,
      ),
    );

    final innerContainer = Container(
      width: 18.0,
      height: 18.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color(indexed ? 0xFFFF483D : 0xFFCCCCCC), borderRadius: BorderRadius.circular(9.0)),
      child: indexText,
    );

    final outerContainer = Container(
      width: 24.0,
      height: 24.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color(indexed ? 0xFFFADFDB : 0xFFF5F5F5), borderRadius: BorderRadius.circular(12.0)),
      child: innerContainer,
    );

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Container(height: 1.0, color:  index == 1 ? Colors.transparent : Color(0xFFCCCCCC))),
            SizedBox(width: 4.0),
            outerContainer,
            SizedBox(width: 4.0),
            Expanded(child: Container(height: 1.0, color: index == widget.titles.length ? Colors.transparent : Color(0xFFCCCCCC))),
          ],
        ),
        Text(
          title,
          style: TextStyle(
            color: Color(indexed ? 0xFFFF483D : 0xFF888888),
            fontSize: 12.0,
            fontWeight: indexed ? FontWeight.w400 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}