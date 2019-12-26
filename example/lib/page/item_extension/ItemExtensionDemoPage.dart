import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';

/// [JDLItem.leftTitleRightValue]、[JDLItem.leftTitleRightTextField]、[StoneNumberTextInputFormatter]、[JDLAlert]
class ItemExtensionDemoPage extends StatefulWidget {
  @override
  _ItemExtensionDemoPageState createState() => _ItemExtensionDemoPageState();
}

class _ItemExtensionDemoPageState extends State<ItemExtensionDemoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _paymentMethod;
  String _goodsType;

  TextEditingController _numEditingController = TextEditingController();
  TextEditingController _volumeEditingController = TextEditingController();
  TextEditingController _weightEditingController = TextEditingController();
  TextEditingController _kilometreNumEditingController = TextEditingController();
  TextEditingController _floorNumEditingController = TextEditingController();

  @override
  void dispose() {
    _kilometreNumEditingController.dispose();
    _floorNumEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ItemExtension'),
        centerTitle: true,
        leading: StoneBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return NotificationListener(
      onNotification: (notify) {
        if (notify is UserScrollNotification) {
          _dismissKeyboard();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => _dismissKeyboard(),
        child: Column(
          children: <Widget>[
            Expanded(child: _buildContent()),
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      children: <Widget>[
        JDLTitleBar(title: '请填写'),
        JDLItem.leftTitleRightValue(
          onTap: _onSelectPaymentMethod,
          title: '支付方式',
          value: _paymentMethod,
          hint: '请选择',
          showRightArrow: true,
          showsDivider: true,
          showsTopRoundedCorners: true,
        ), // 支付方式
        JDLItem.leftTitleRightValue(
          onTap: _onSelectGoodsType,
          title: '物品',
          value: _goodsType,
          hint: '请选择',
          showRightArrow: true,
          showsBottomRoundedCorners: true,
        ),
        SizedBox(height: 10.0),
        JDLItem.leftTitleRightTextField(
          editingController: _numEditingController,
          inputFormatter: StoneNumberTextInputFormatter(maximumFractionDigits: 0),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
          selectAllWhenFocused: true,
          tips: '至少一个',
          title: '件数',
          hint: '请填写',
          suffixText: '个',
          showsDivider: true,
          showsTopRoundedCorners: true,
        ), // 包裹件数
        JDLItem.leftTitleRightTextField(
          editingController: _volumeEditingController,
          inputFormatter: StoneNumberTextInputFormatter(maximumFractionDigits: 3),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          selectAllWhenFocused: true,
          tips: '最小按 1m³ 计',
          title: '体积',
          hint: '请填写',
          inputEnabled: true,
          suffixText: 'm³',
          showsDivider: true,
        ), // 包裹体积
        JDLItem.leftTitleRightTextField(
          editingController: _weightEditingController,
          inputFormatter: StoneNumberTextInputFormatter(maximumFractionDigits: 2),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          selectAllWhenFocused: true,
          tips: '最低按 1.0kg 计',
          title: '货物重量',
          hint: '请填写',
          suffixIcon: Text('公里', style: AppTextStyles.blackW600(fontSize: 14.0)),
          showsDivider: true,
          showsBottomRoundedCorners: true,
        ),
        SizedBox(height: 10.0),
        JDLItem.leftTitleRightTextField(
          editingController: _kilometreNumEditingController,
          inputFormatter: StoneNumberTextInputFormatter(maximumFractionDigits: 2),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
          selectAllWhenFocused: true,
          title: '配送公里数',
          hint: '请填写',
          suffixIcon: Text('公里', style: AppTextStyles.blackW600(fontSize: 14.0)),
          showsDivider: true,
          showsTopRoundedCorners: true,
        ),
        JDLItem.leftTitleRightTextField(
          editingController: _floorNumEditingController,
          inputFormatter: StoneNumberTextInputFormatter(maximumFractionDigits: 0),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
          selectAllWhenFocused: true,
          title: '上楼楼层',
          hint: '请填写',
          suffixIcon: Text('层', style: AppTextStyles.blackW600(fontSize: 14.0)),
          showsDivider: true,
          showsBottomRoundedCorners: true,
        ),
      ],
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
        child: Text('确定'),
      ),
    );
  }

  void _onSelectPaymentMethod() {
    _showOptionsMenu(['到付', '后结', '寄付', '月结'], (method) => setState(() => _paymentMethod = method));
  }

  void _onSelectGoodsType() {
    _showOptionsMenu(['文件', '玻璃', '玩具', '床上用品'], (method) => setState(() => _goodsType = method));
  }

  void _showOptionsMenu(List<String> options, ValueChanged<String> onSelected) {
    showJDLAlert(
      context: context,
      style: JDLAlertStyle.sheet,
      builder: (context) => JDLAlert(
        cancelButton: JDLAlertAction(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        actions: options.map((option) => JDLAlertAction(
          onPressed: () {
            onSelected(option);
            Navigator.pop(context);
          },
          child: Text(option),
        )).toList(),
      ),
    );
  }

  void _onConfirm() {
    _dismissKeyboard();
    _showSnack('提交完成');
  }

  void _showSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(message),
      ),
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}