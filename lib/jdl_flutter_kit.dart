library stone_flutter_kit;

import 'dart:async';

import 'package:flutter/services.dart';
export 'package:stone_flutter_kit/stone_flutter_kit.dart';

export 'extension/jdl_item.dart';
export 'widget/jdl_alert.dart';
export 'widget/jdl_async_body.dart';
export 'widget/jdl_bottom_sheet.dart';
export 'widget/jdl_calendar.dart';
export 'widget/jdl_calendar_sheet.dart';
export 'widget/jdl_tab_bar.dart';
export 'widget/jdl_title_bar.dart';
export 'widget/jdl_stepper.dart';

class JDLFlutterKit {
  static const MethodChannel _channel = const MethodChannel('jdl_flutter_kit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}