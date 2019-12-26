import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/constant/jdl_colors.dart';

/// 页面顶部标题栏
class JDLTitleBar extends StatelessWidget {
  const JDLTitleBar({
    Key key,
    this.title,
    this.titleStyle = const TextStyle(color: JDLColors.black, fontSize: 22.0, fontWeight: FontWeight.w600),
    this.subtitle,
    this.subtitleStyle = const TextStyle(color: JDLColors.red, fontSize: 16.0, fontWeight: FontWeight.w600),
  }) : super(key: key);

  final String title;
  final TextStyle titleStyle;

  final String subtitle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        height: 62.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: titleStyle),
            Text(subtitle ?? '', style: subtitleStyle),
          ],
        ),
      ),
    );
  }
}