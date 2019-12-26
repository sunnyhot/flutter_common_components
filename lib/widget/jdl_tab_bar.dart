import 'package:flutter/material.dart';

/// 分组位置
enum JDLTabPosition { left, right }

/// 分组切换器
class JDLTabBar extends StatefulWidget {
  const JDLTabBar({
    Key key,
    this.onChanged,
    this.selected,
    this.leftTitle,
    this.rightTitle,
    this.showsShadow = false,
  }) : super(key: key);

  /// 切换了选项的回调
  final ValueChanged<JDLTabPosition> onChanged;
  /// 选中的 Tab 位置
  final JDLTabPosition selected;
  /// 左侧标题
  final String leftTitle;
  /// 右侧标题
  final String rightTitle;
  /// 是否显示阴影
  final bool showsShadow;

  @override
  _JDLTabBarState createState() => _JDLTabBarState();
}

class _JDLTabBarState extends State<JDLTabBar> {
  @override
  Widget build(BuildContext context) {
    final tabShapes = <Widget>[
      Positioned.fill(child: _buildTabShape(position: JDLTabPosition.left)),
      Positioned.fill(child: _buildTabShape(position: JDLTabPosition.right)),
    ];

    final tabMargin = (MediaQuery.of(context).size.width - 20.0) / 2 + _TabPainter._triangleWidth / 2;
    final tabs = <Widget>[
      Positioned(
        left: tabMargin,
        top: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: _buildTabContent(title: widget.rightTitle, position: JDLTabPosition.right),
      ),
      Positioned(
        left: 0.0,
        top: 0.0,
        right: tabMargin,
        bottom: 0.0,
        child: _buildTabContent(title: widget.leftTitle, position: JDLTabPosition.left),
      ),
    ];

    return SizedBox(
      height: 40.0,
      child: Stack(
        children: (widget.selected == JDLTabPosition.right ? tabShapes : tabShapes.reversed.toList()) + tabs,
      ),
    );
  }

  /// 构建 Tab 图形
  Widget _buildTabShape({JDLTabPosition position}) {
    return CustomPaint(
      painter: _TabPainter(
        position: position,
        selected: widget.selected == position,
        showsShadow: widget.showsShadow,
      ),
    );
  }

  /// 构建 Tab 内容
  Widget _buildTabContent({String title, JDLTabPosition position}) {
    final selected = widget.selected == position;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (widget.onChanged == null || selected) ? null : () => setState(() {
        widget.onChanged(position);
      }),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Color(selected ? 0xFFFF483D : 0xFF888888),
            fontSize: 14.0,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _TabPainter extends CustomPainter {
  const _TabPainter({
    JDLTabPosition position,
    bool selected,
    bool showsShadow,
  }) : _position = position, _selected = selected, _showsShadow = showsShadow;

  /// Tab 图形的位置
  final JDLTabPosition _position;
  /// Tab 是否为选中状态
  final bool _selected;
  /// 是否显示阴影
  final bool _showsShadow;

  /// Tab 的圆角
  static final double _borderRadius = 10.0;
  /// Tab 尖角部分的三角形宽度
  static final double _triangleWidth = 25.0;
  /// Tab 底部矩形的高度
  static final double _bottomRectHeight = 2.0;

  /// 阴影
  static final BoxShadow _shadow = const BoxShadow(
    color: Color(0x0D000000),
    offset: Offset(0.0, 4.0), blurRadius: 5.0, spreadRadius: 0.0,
  );

  /// 阴影画笔，参考自 [BoxShadow.toPaint]
  static final Paint _shadowPaint = Paint()
    ..color = _shadow.color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, _shadow.blurSigma);

  @override
  void paint(Canvas canvas, Size size) {
    var shapePath;
    switch (_position) {
      case JDLTabPosition.left:
        shapePath = Path()
          ..moveTo(size.width / 2 - _triangleWidth / 2, 0.0) // 三角形上顶点
          ..lineTo(size.width / 2 + _triangleWidth / 2, size.height - _bottomRectHeight) // 三角形右顶点
          ..lineTo(size.width, size.height - _bottomRectHeight) // 底部矩形右顶点
          ..lineTo(size.width, size.height) // 底部矩形右底点
          ..lineTo(0.0, size.height) // 底部矩形左底点
          ..lineTo(0.0, _borderRadius) // 左上角圆角起点
          ..arcToPoint(Offset(_borderRadius, 0.0), radius: Radius.circular(_borderRadius)) // 左上角圆角终点
          ..close(); // 封闭路径，回到三角形上顶点
          break;
      case JDLTabPosition.right:
        shapePath = Path()
          ..moveTo(size.width - _borderRadius, 0.0) // 右上角圆角起点
          ..arcToPoint(Offset(size.width, _borderRadius), radius: Radius.circular(_borderRadius)) // 右上角圆角终点
          ..lineTo(size.width, size.height) // 底部矩形右底点
          ..lineTo(0.0, size.height) // 底部矩形左底点
          ..lineTo(0.0, size.height - _bottomRectHeight)
          ..lineTo(size.width / 2 - _triangleWidth / 2, size.height - _bottomRectHeight) // 三角形左顶点
          ..lineTo(size.width / 2 + _triangleWidth / 2, 0.0) // 三角形上顶点
          ..close(); // 封闭路径，回到右上角圆角起点
          break;
    }

    // 画阴影
    if (_showsShadow) {
      // 阴影的偏移参考自 [BoxDecoration._paintShadows]
      final shadowPath = shapePath.shift(_shadow.offset).shift(Offset(-_shadow.spreadRadius, -_shadow.spreadRadius));
      canvas.drawPath(shadowPath, _shadowPaint);
    }

    // 画图形
    final shapePaint = Paint()..color = _selected ? Colors.white : Color(0xFFE6E6E6);
    canvas.drawPath(shapePath, shapePaint);
  }

  @override
  bool shouldRepaint(_TabPainter oldDelegate) => true;
}