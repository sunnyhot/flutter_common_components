import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdl_flutter_kit/constant/jdl_colors.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

extension JDLItem on StoneItem {
  /// 左侧标题 - 右侧内容
  static StoneItem leftTitleRightValue({
    VoidCallback onTap,
    StoneItemType type,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
    @required String title,
    TextStyle titleStyle = const TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w300),
    String value,
    TextStyle valueStyle = const TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
    String hint,
    TextStyle hintStyle = const TextStyle(color: JDLColors.grey, fontSize: 14.0, fontWeight: FontWeight.w500),
    Widget prefixIcon,
    String prefixText,
    TextStyle prefixStyle = const TextStyle(color: JDLColors.red, fontSize: 14.0, fontWeight: FontWeight.w300),
    Widget prefix,
    Widget suffixIcon,
    String suffixText,
    TextStyle suffixStyle = const TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
    Widget suffix,
    bool showRightArrow = false,
    bool showsDivider= false,
    double dividerIndent = 10.0,
    double dividerEndIndent = 0.0,
    bool showsTopRoundedCorners = false,
    bool showsBottomRoundedCorners = false,
  }) {
    assert(prefixText == null || prefix == null, 'prefixText 与 prefix 不能同时使用');
    assert(suffixText == null || suffix == null, 'prefixText 与 prefix 不能同时使用');
    assert(!(showRightArrow && suffixIcon != null), 'showRightArrow 与 suffixIcon 不能同时使用');

    final items = <Widget>[];

    if (prefixIcon != null) {
      items.add(prefixIcon);
      items.add(SizedBox(width: 6.0));
    }

    if (prefixText != null) {
      items.add(Text(prefixText, style: prefixStyle));
      items.add(SizedBox(width: 4.0));
    }

    if (prefix != null) {
      items.add(prefix);
      items.add(SizedBox(width: 4.0));
    }

    items.add(
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: () {
            final items = <Widget>[Text(title, style: titleStyle), SizedBox(width: 16.0)];

            if (value != null) {
              items.add(Expanded(child: Text(value, style: valueStyle, textAlign: TextAlign.end)));
            } else {
              items.add(Flexible(child: Container()));
            }

            if (hint != null && (value?.isEmpty ?? true)) {
              items.add(Text(hint, style: hintStyle));
            }

            return items;
          }(),
        ),
      ),
    );

    if (suffixText != null) {
      items.add(SizedBox(width: 4.0));
      items.add(Text(suffixText, style: suffixStyle));
    }

    if (suffix != null) {
      items.add(SizedBox(width: 4.0));
      items.add(suffix);
    }

    if (suffixIcon != null) {
      items.add(SizedBox(width: 6.0));
      items.add(suffixIcon);
    }

    if (showRightArrow) {
      items.add(SizedBox(width: 6.0));
      items.add(Icon(Icons.arrow_forward_ios, size: 16.0));
    }

    return StoneItem(
      onTap: onTap,
      type: type,
      padding: padding,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(showsTopRoundedCorners ? 12.0 : 0.0),
        bottom: Radius.circular(showsBottomRoundedCorners ? 12.0 : 0.0),
      ),
      divider: !showsDivider ? null : Divider(
        height: 1.0,
        color: JDLColors.dividerColor,
        indent: dividerIndent,
        endIndent: dividerEndIndent,
      ),
      child: Row(children: items),
    );
  }

  /// 可以编辑的单元格
  static Widget leftTitleRightTextField({
    EdgeInsets padding,
    @required String title,
    TextStyle titleStyle = const TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w300),
    String tips,
    TextStyle tipsStyle = const TextStyle(color: JDLColors.grey, fontSize: 10.0, fontWeight: FontWeight.w400),
    TextStyle valueStyle = const TextStyle(color: JDLColors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
    TextInputType keyboardType,
    TextInputFormatter inputFormatter,
    TextInputAction textInputAction = TextInputAction.done,
    TextAlign textAlign = TextAlign.end,
    bool selectAllWhenFocused = false,
    TextEditingController editingController,
    bool inputEnabled = true,
    String hint,
    TextStyle hintStyle = const TextStyle(color: Color(0xFF888888), fontSize: 14.0, fontWeight: FontWeight.w300),
    Widget prefixIcon,
    String prefixText,
    TextStyle prefixStyle = const TextStyle(color: Color(0xFFFF483D), fontSize: 14.0, fontWeight: FontWeight.w300),
    Widget prefix,
    Widget suffixIcon,
    String suffixText,
    TextStyle suffixStyle = const TextStyle(color: Color(0xFF404040), fontSize: 14.0, fontWeight: FontWeight.w600),
    Widget suffix,
    bool showRightArrow = false,
    bool showsDivider= false,
    double dividerIndent = 10.0,
    double dividerEndIndent = 0.0,
    bool showsTopRoundedCorners = false,
    bool showsBottomRoundedCorners = false,
  }) {
    assert(prefixText == null || prefix == null, 'prefixText 与 prefix 不能同时使用');
    assert(suffixText == null || suffix == null, 'prefixText 与 prefix 不能同时使用');

    return _LeftTitleRightTextFieldCell(
      padding: padding ?? (tips == null
              ? const EdgeInsets.symmetric(horizontal: 10.0)
              : const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0)),
      title: title,
      titleStyle: titleStyle,
      tips: tips,
      tipsStyle: tipsStyle,
      valueStyle: valueStyle,
      keyboardType: keyboardType,
      inputFormatter: inputFormatter,
      textInputAction: textInputAction,
      textAlign: textAlign,
      selectAllWhenFocused: selectAllWhenFocused,
      editingController: editingController ?? TextEditingController(),
      inputEnabled: inputEnabled,
      hint: hint,
      hintStyle: hintStyle,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefix: prefix,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffix: suffix,
      showRightArrow: showRightArrow,
      showsDivider: showsDivider,
      dividerIndent: dividerIndent,
      dividerEndIndent: dividerEndIndent,
      showsTopRoundedCorners: showsTopRoundedCorners,
        showsBottomRoundedCorners: showsBottomRoundedCorners,
    );
  }
}

class _LeftTitleRightTextFieldCell extends StatefulWidget {
  const _LeftTitleRightTextFieldCell({
    this.padding,
    @required this.title,
    this.titleStyle,
    this.tips,
    this.tipsStyle,
    this.valueStyle,
    this.keyboardType,
    this.inputFormatter,
    this.textInputAction,
    this.textAlign,
    this.selectAllWhenFocused,
    this.editingController,
    this.inputEnabled,
    this.hint,
    this.hintStyle,
    this.prefixIcon,
    this.prefixText,
    this.prefixStyle,
    this.prefix,
    this.suffixIcon,
    this.suffixText,
    this.suffixStyle,
    this.suffix,
    this.showRightArrow,
    this.showsDivider,
    this.dividerIndent,
    this.dividerEndIndent,
    this.showsTopRoundedCorners,
    this.showsBottomRoundedCorners,
  });

  final EdgeInsets padding;

  final String title;
  final TextStyle titleStyle;

  final String tips;
  final TextStyle tipsStyle;

  final TextStyle valueStyle;
  final TextInputType keyboardType;
  final TextInputFormatter inputFormatter;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final bool selectAllWhenFocused;
  final TextEditingController editingController;
  final bool inputEnabled;

  final String hint;
  final TextStyle hintStyle;

  final Widget prefixIcon;
  final String prefixText;
  final TextStyle prefixStyle;
  final Widget prefix;

  final Widget suffixIcon;
  final String suffixText;
  final TextStyle suffixStyle;
  final Widget suffix;

  final bool showRightArrow;
  final bool showsDivider;
  final double dividerIndent;
  final double dividerEndIndent;
  final bool showsTopRoundedCorners;
  final bool showsBottomRoundedCorners;

  @override
  _LeftTitleRightTextFieldCellState createState() => _LeftTitleRightTextFieldCellState();
}

class _LeftTitleRightTextFieldCellState extends State<_LeftTitleRightTextFieldCell> {
  @override
  Widget build(BuildContext context) {
    final topItems = <Widget>[];

    if (widget.prefixIcon != null) {
      topItems.add(widget.prefixIcon);
      topItems.add(SizedBox(width: 6.0));
    }

    if (widget.prefixText != null) {
      topItems.add(Text(widget.prefixText, style: widget.prefixStyle));
      topItems.add(SizedBox(width: 4.0));
    }

    if (widget.prefix != null) {
      topItems.add(widget.prefix);
      topItems.add(SizedBox(width: 4.0));
    }

    topItems.add(Text(widget.title, style: widget.titleStyle));

    if (widget.tips != null) {
      topItems.add(Flexible(child: Container()));
      topItems.add(Text(widget.tips, style: widget.tipsStyle));
    }

    final textField = Container(
      alignment: Alignment.center,
      padding: widget.tips == null ? null : EdgeInsets.only(left: 80.0),
      height: widget.tips == null ? 50.0 : 35.0,
      child: CupertinoTextField(
        controller: widget.editingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign,
        style: widget.valueStyle,
        inputFormatters: widget.inputFormatter == null ? null : [widget.inputFormatter],
        textAlignVertical: TextAlignVertical.center,
        placeholder: widget.hint,
        placeholderStyle: widget.hintStyle,
        decoration: BoxDecoration(),
        suffix: () {
          if (widget.suffix != null) {
            return widget.suffix;
          }
          if (widget.suffixText != null) {
            return Text(widget.suffixText, style: widget.suffixStyle);
          }
          return null;
        }(),
        suffixMode: OverlayVisibilityMode.always,
        onTap: _onBeginEditing,
        enabled: widget.inputEnabled,
      ),
    );

    final content = () {
      if (widget.tips == null) {
        topItems.add(SizedBox(width: 16.0));
        topItems.add(Expanded(child: textField));

        if (widget.suffixIcon != null) {
          topItems.add(SizedBox(width: 6.0));
          topItems.add(widget.suffixIcon);
        }

        return Row(children: topItems);
      }

      final bottomItems = <Widget>[Expanded(child: textField)];
      if (widget.suffixIcon != null) {
        bottomItems.add(SizedBox(width: 6.0));
        bottomItems.add(widget.suffixIcon);
      }

      return Column(
        children: <Widget>[
          Row(children: topItems),
          Row(children: bottomItems),
        ],
      );
    }();

    return StoneItem(
      padding: widget.padding,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(widget.showsTopRoundedCorners ? 12.0 : 0.0),
        bottom: Radius.circular(widget.showsBottomRoundedCorners ? 12.0 : 0.0),
      ),
      divider: !widget.showsDivider ? null : Divider(
        height: 1.0,
        color: JDLColors.dividerColor,
        indent: widget.dividerIndent,
        endIndent: widget.dividerEndIndent,
      ),
      child: content,
    );
  }

  void _onBeginEditing() {
    widget.editingController.selection = TextSelection(baseOffset: 0, extentOffset: widget.editingController.text.length);
  }
}