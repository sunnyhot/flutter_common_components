import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/constant/jdl_colors.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

/// [JDLAlert] 的背景色
const Color _kBackgroundColor = JDLColors.white;

/// Dialog 弹窗形状
const ShapeBorder _kDialogShape = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
);

/// Sheet 弹窗形状
const ShapeBorder _kSheetShape = const RoundedRectangleBorder(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
);

/// [JDLAlert.title] 的文本样式
const TextStyle _kTitleTextStyle = TextStyle(color: JDLColors.black, fontSize: 16.0, fontWeight: FontWeight.w500);

/// [JDLAlert.message] 的文本样式
const TextStyle _kMessageTextStyle = TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w400);

/// [JDLAlertAction] 的高度
const double _kActionHeight = 50.0;

/// 普通 [JDLAlertAction] 的文本样式
const TextStyle _kNormalActionTextStyle = TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w400);

/// 默认 [JDLAlertAction] 的文本样式
const TextStyle _kDefaultActionTextStyle = TextStyle(color: JDLColors.red, fontSize: 14.0, fontWeight: FontWeight.w400);

/// 分割线颜色
const Color _kDividerColor = Color(0xFFD9D9D9);

/// 分割线宽度
double _kDividerWidth = 1.0 / ui.window.devicePixelRatio;

/// [JDLAlert] 弹窗样式
enum JDLAlertStyle {
  /// 显示在屏幕中央
  dialog,
  /// 从屏幕底部滑入
  sheet,
}

/// [JDLAlert] 弹窗中的选项
class JDLAlertAction extends StatelessWidget{
  const JDLAlertAction({
    this.onPressed,
    this.isDefaultAction = false,
    @required this.child,
  });

  /// 点击后的回调
  final VoidCallback onPressed;

  /// 是否为默认选项
  ///
  /// 默认选项的文本为红色。
  final bool isDefaultAction;

  /// 选项内容
  ///
  /// 通常使用 [Text]。
  final Widget child;

  /// 是否为启用状态
  bool get enabled => onPressed != null;

  /// 当前状态下的文本样式
  TextStyle get _effectiveTextStyle {
    final normalTextStyle = isDefaultAction ? _kDefaultActionTextStyle : _kNormalActionTextStyle;
    return enabled ? normalTextStyle : normalTextStyle.copyWith(color: normalTextStyle.color.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kActionHeight + MediaQuery.of(context).padding.bottom,
      child: StoneItem(
        onTap: onPressed,
        child: DefaultTextStyle(
          style: _effectiveTextStyle,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 弹窗组件
///
/// 请使用 [showJDLAlert] 函数展示 [JDLAlert]，通过 [JDLAlertStyle] 指定弹窗样式。
class JDLAlert extends StatelessWidget {
  const JDLAlert({
    Key key,
    this.title,
    this.titleTextStyle,
    this.message,
    this.messageTextStyle,
    this.cancelButton,
    this.actions,
  }) : super(key: key);

  /// 标题
  ///
  /// 通常使用 [Text]。
  final Widget title;

  /// 标题样式
  final TextStyle titleTextStyle;

  /// 内容
  ///
  /// 通常使用 [Text]。
  final Widget message;

  /// 内容样式
  final TextStyle messageTextStyle;

  /// 取消按钮
  ///
  /// 通常使用 [JDLAlertAction]。
  final Widget cancelButton;

  /// 弹窗的操作选项
  ///
  /// 通常使用 [JDLAlertAction]。
  final List<Widget> actions;

  /// 是否有内容（[title] || [message]）
  bool get _hasContent => title != null || message != null;
  /// 是否有取消按钮
  bool get _hasCancelButton => cancelButton != null;
  /// 是否有选项
  bool get _hasAction => _hasCancelButton || (actions?.isNotEmpty ?? false);

  /// 构建横向分割线
  Widget _buildHorizontalDivider() => Container(
    width: double.infinity,
    height: _kDividerWidth,
    color: _kDividerColor,
  );

  /// 构建纵向分割线
  Widget _buildVerticalDivider() => Container(
    width: _kDividerWidth,
    height: _kActionHeight,
    color: _kDividerColor,
  );

  @override
  Widget build(BuildContext context) {
    switch (_JDLAlertWrapper.of(context).alertStyle) {
      case JDLAlertStyle.dialog:
        return _buildDialog(context);
      case JDLAlertStyle.sheet:
        return _buildSheet(context);
      default:
        return null;
    }
  }

  /// 构建 [JDLAlertStyle.dialog] 样式的弹窗
  Widget _buildDialog(BuildContext context) {
    final buildActions = () {
      final allActions = [
        if (cancelButton != null) cancelButton,
        ...actions,
      ];

      if (allActions.length == 2) {
        return MediaQuery.removePadding(
          context: context,
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          child: Row(
            children: <Widget>[
              Expanded(child: allActions[0]),
              _buildVerticalDivider(),
              Expanded(child: allActions[1]),
            ],
          ),
        );
      }

      return _buildActions(context, allActions);
    };

    return Dialog(
      backgroundColor: _kBackgroundColor,
      shape: _kDialogShape,
      child: ClipRRect(
        borderRadius: (_kDialogShape as RoundedRectangleBorder).borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_hasContent) _buildContent(),
            if (_hasContent && _hasAction) _buildHorizontalDivider(),
            if (_hasAction) buildActions(),
          ],
        ),
      ),
    );
  }

  /// 构建 [JDLAlertStyle.sheet] 样式的弹窗
  Widget _buildSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_hasContent) _buildContent(),
        if (_hasContent && _hasAction) _buildHorizontalDivider(),
        if (_hasAction) _buildActions(context, actions),
        if (_hasCancelButton) Container(color: Color(0xFFF4F4F4), height: 10.0),
        if (_hasCancelButton)
          MediaQuery(
            data: MediaQueryData(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
            child: cancelButton,
          ),
      ],
    );
  }

  /// 构建内容组件（[title] + [message]）
  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null) DefaultTextStyle(textAlign: TextAlign.center, style: _kTitleTextStyle, child: title),
          if (title != null && message != null) SizedBox(height: 12.0),
          if (message != null) DefaultTextStyle(textAlign: TextAlign.center, style: _kMessageTextStyle, child: message),
        ],
      ),
    );
  }

  /// 构建选项列表
  Widget _buildActions(BuildContext context, List<Widget> actions) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: !(_JDLAlertWrapper.of(context).alertStyle == JDLAlertStyle.sheet && !_hasCancelButton),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) => actions[index],
        separatorBuilder: (context, index) => _buildHorizontalDivider(),
        itemCount: actions.length,
      ),
    );
  }
}

class _JDLAlertWrapper extends InheritedWidget {
  const _JDLAlertWrapper({
    Key key,
    @required this.alertStyle,
    @required Widget child,
  }) : assert(alertStyle != null),
        assert(child != null),
        super(key: key, child: child);

  final JDLAlertStyle alertStyle;

  static _JDLAlertWrapper of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_JDLAlertWrapper>();
  }

  @override
  bool updateShouldNotify(_JDLAlertWrapper old) => alertStyle != old.alertStyle;
}

/// 展示 [JDLAlert] 弹窗
Future<T> showJDLAlert<T>({
  @required BuildContext context,
  @required JDLAlertStyle style,
  @required WidgetBuilder builder,
  bool useRootNavigator = true,
  bool dismissible,
}) {
  final wrapper = (context, style) => _JDLAlertWrapper(
    alertStyle: style,
    child: builder(context),
  );

  switch (style) {
    case JDLAlertStyle.dialog:
      return showDialog(
        context: context,
        barrierDismissible: dismissible ?? false,
        useRootNavigator: useRootNavigator,
        builder: (context) => wrapper(context, style),
      );
    case JDLAlertStyle.sheet:
      return showModalBottomSheet(
        context: context,
        backgroundColor: _kBackgroundColor,
        shape: _kSheetShape,
        clipBehavior: Clip.antiAlias,
        useRootNavigator: useRootNavigator,
        isDismissible: dismissible ?? true,
        isScrollControlled: true,
        builder: (context) => wrapper(context, style),
      );
    default:
      return null;
  }
}