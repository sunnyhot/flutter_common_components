import 'package:flutter/cupertino.dart';

const String _kPackageName = 'jdl_flutter_kit';

/// JDL Flutter Kit 中的图片资源
class JDLImages {
  /// 无数据
  static AssetImage get imgNoData => const AssetImage('asset/images/img_no_data.png', package: _kPackageName);
  /// 无列表
  static AssetImage get imgNoList => const AssetImage('asset/images/img_no_list.png', package: _kPackageName);
  /// 无网络
  static AssetImage get imgNoNetwork => const AssetImage('asset/images/img_no_network.png', package: _kPackageName);
}