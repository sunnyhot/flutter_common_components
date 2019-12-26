import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

/// Sheet 弹窗形状
const ShapeBorder _kSheetShape = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
);

class _BottomSheetPanel extends StatefulWidget {
  const _BottomSheetPanel({
    @required this.title,
    this.showsSeparator = false,
    @required this.child,
  });

  final String title;
  final bool showsSeparator;
  final Widget child;

  @override
  _BottomSheetPanelState createState() => _BottomSheetPanelState();
}

class _BottomSheetPanelState extends State<_BottomSheetPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTitleBar(),
        widget.child,
      ],
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 70.0,
      decoration: BoxDecoration(
        border: widget.showsSeparator ? Border(bottom: BorderSide(color: Color(0xFFD9D9D9), width: 0.5)) : null,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20.0),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(color: Color(0xFF404040), fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
          ),
          StoneButton(
            onPressed: () => Navigator.of(context).pop(),
            splashShape: CircleBorder(),
            tapTargetSize: Size(56.0, 56.0),
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

Future<T> showJDLBottomSheet<T>({
  @required BuildContext context,
  String title,
  bool showsSeparator = false,
  Color color,
  double elevation,
  ShapeBorder shape,
  bool enableDrag = true,
  @required WidgetBuilder builder,
}) {
  assert(context != null);
  assert(builder != null);

  return showModalBottomSheet(
    context: context,
    backgroundColor: color,
    elevation: elevation,
    shape: shape ?? _kSheetShape,
    clipBehavior: Clip.antiAlias,
    isScrollControlled: enableDrag,
    builder: title == null ? builder : (context) => _BottomSheetPanel(
      title: title,
      showsSeparator: showsSeparator,
      child: builder(context),
    ),
  );
}