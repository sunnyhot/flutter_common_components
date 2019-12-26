import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';

/// [JDLAlert]、[showJDLAlert]、[StoneCounterBuilder]
class AlertDemoPage extends StatefulWidget {
  @override
  _AlertDemoPageState createState() => _AlertDemoPageState();
}

class _AlertDemoPageState extends State<AlertDemoPage> {
  bool _showsTitle = true;
  bool _showsMessage = true;
  bool _showsCancelButton = true;
  bool _showCountdown = false;
  int _actionsCount = 1;

  JDLAlertAction _cancelButton;
  List<Widget> _actions1;
  List<Widget> _actions2;

  @override
  void initState() {
    super.initState();

    _cancelButton = JDLAlertAction(
      onPressed: () => Navigator.pop(context),
      child: Text('取消'),
    );

    final action = (onPressed, title, [bool isDefault = false]) => JDLAlertAction(
      onPressed: onPressed,
      isDefaultAction: isDefault,
      child: Text(title),
    );

    _actions1 = <Widget>[
      action(() => Navigator.pop(context), '嗯嗯'),
      action(() => Navigator.pop(context), '好的', true),
    ];

    _actions2 = <Widget>[
      action(() => Navigator.pop(context), '嗯嗯'),
      StoneCounterBuilder(
        duration: Duration(seconds: 1),
        count: 3,
        builder: (context, number, finished) => action(
          !finished ? null : () => Navigator.pop(context),
          !finished ? '好的（${3 - number}）' : '好的',
          true,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert'),
        centerTitle: true,
        leading: StoneBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.all(10.0) + EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      children: <Widget>[
        _buildSwitchItem(
          onChanged: (val) => setState(() => _showsTitle = !_showsTitle),
          title: '显示标题',
          value: _showsTitle,
          isFirst: true,
        ),
        _buildSwitchItem(
          onChanged: (val) => setState(() => _showsMessage = !_showsMessage),
          title: '显示内容',
          value: _showsMessage,
        ),
        _buildSwitchItem(
          onChanged: (val) => setState(() => _showsCancelButton = !_showsCancelButton),
          title: '取消按钮',
          value: _showsCancelButton,
        ),
        _buildSwitchItem(
          onChanged: (val) => setState(() => _showCountdown = val),
          title: '倒计时',
          value: _showCountdown,
        ),
        _buildOptionItem(
          onSelected: (val) => setState(() => _actionsCount = val),
          title: '按钮数量',
          isLast: true,
        ),
        SizedBox(height: 10.0),
        _buildActionItem(
          onTap: () => _showAlert(JDLAlertStyle.dialog),
          title: 'Show Alert Dialog',
          isFirst: true,
        ),
        _buildActionItem(
          onTap: () => _showAlert(JDLAlertStyle.sheet),
          title: 'Show Action Sheet',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    ValueChanged<bool> onChanged,
    String title,
    bool value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return _buildItem(
      onTap: () => onChanged(!value),
      isFirst: isFirst,
      isLast: isLast,
      content: Row(
        children: <Widget>[
          Text(title, style: AppTextStyles.blackW400(fontSize: 16.0)),
          Expanded(child: Container()),
          Switch(onChanged: onChanged, value: value, activeColor: AppColors.red),
        ],
      ),
    );
  }

  Widget _buildOptionItem({ValueChanged<int> onSelected, String title, bool isFirst = false, bool isLast = false}) {
    return _buildItem(
      onTap: () => showJDLAlert(
        context: context,
        style: JDLAlertStyle.sheet,
        builder: (context) => JDLAlert(
          cancelButton: _cancelButton,
          actions: [1, 2].map((number) => JDLAlertAction(
            onPressed: () {
              Navigator.pop(context);
              onSelected(number);
            },
            child: Text('$number 个'),
          )).toList(),
        ),
      ),
      isFirst: isFirst,
      isLast: isLast,
      content: Row(
        children: <Widget>[
          Text(title, style: AppTextStyles.blackW400(fontSize: 16.0)),
          Expanded(child: Container()),
          Text('$_actionsCount 个', style: AppTextStyles.blackW400(fontSize: 16.0)),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    VoidCallback onTap,
    String title,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return _buildItem(
      onTap: onTap,
      isFirst: isFirst,
      isLast: isLast,
      content: Center(child: Text(title, style: AppTextStyles.blackW400(fontSize: 16.0))),
    );
  }

  Widget _buildItem({VoidCallback onTap, Widget content, bool isFirst = false, bool isLast = false}) {
    return SizedBox(
      height: 50.0,
      child: StoneItem(
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isFirst ? 12.0 : 0.0),
          bottom: Radius.circular(isLast ? 12.0 : 0.0),
        ),
        divider: isLast ? null : Divider(color: Color(0xFFD9D9D9), height: 0.5),
        child: content,
      ),
    );
  }

  void _showAlert(JDLAlertStyle style) {
    final actions = _showCountdown ? _actions2 : _actions1;
    showJDLAlert(
      context: context,
      style: style,
      builder: (context) => JDLAlert(
        title: !_showsTitle ? null : Text('我是标题'),
        message: !_showsMessage ? null : Text('我是内容，我是内容，我是内容，我是内容，我是内容，我是内容'),
        cancelButton: !_showsCancelButton ? null : _cancelButton,
        actions: actions.sublist(actions.length - _actionsCount, actions.length),
      ),
    );
  }
}