import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';
import 'package:jdl_flutter_kit_example/constant/styles.dart';
import 'package:jdl_flutter_kit_example/constant/themes.dart';
import 'package:jdl_flutter_kit_example/page/alert/alert_demo_page.dart';
import 'package:jdl_flutter_kit_example/page/calendar/calendar_demo_page.dart';
import 'package:jdl_flutter_kit_example/page/future_body/future_body_demo_page.dart';
import 'package:jdl_flutter_kit_example/page/item_extension/ItemExtensionDemoPage.dart';
import 'package:jdl_flutter_kit_example/page/stepper/stepper_demo_page.dart';
import 'package:jdl_flutter_kit_example/page/stream_body/stream_body_demo_page.dart';
import 'package:jdl_flutter_kit_example/page/tab_bar/tabbar_demo_page.dart';
import 'package:jdl_flutter_kit_example/service/navigate_service.dart';
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';

void main() => runApp(App());

final Map<String, WidgetBuilder> _routes = {
  'FutureBody': (_) => FutureBodyDemoPage(),
  'StreamBody': (_) => StreamBodyDemoPage(),
  'Calendar': (_) => StoneCalendarDemoPage(),
  'Alert': (_) => AlertDemoPage(),
  'Stepper': (_) => StepperDemoPage(),
  'TabBar': (_) => TabBarDemoPage(),
  'ItemExtension': (_) => ItemExtensionDemoPage(),
};

const List<List<String>> _tags = [
  ['buildJDLFutureBody', 'StoneFetchDataError', 'StoneJson'],
  ['buildJDLStreamBody', 'StoneFetchDataError', 'StoneJson'],
  ['StoneCalendar', 'StoneCalendarSheet', 'showJDLBottomSheet'],
  ['JDLAlert', 'showJDLAlert', 'StoneCounterBuilder'],
  ['JDLStepper'],
  ['JDLTitleBar', 'JDLTabBar'],
  ['JDLItem.leftTitleRightValue', 'JDLItem.leftTitleRightTextField', 'StoneNumberTextInputFormatter', 'JDLAlert'],
];

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppButtonThemes.light(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemeDatas.light,
        navigatorKey: NavigateService.I.key,
        routes: _routes,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JDL Flutter Kit'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0).copyWith(bottom: 10.0 + MediaQuery.of(context).padding.bottom),
        children: () {
          final entries = _routes.entries.toList();
          return <Widget>[
            for (int i = 0; i < entries.length; i++)
              _buildItem(
                context: context,
                entry: entries[i],
                tags: _tags[i],
                isFirst: i == 0,
                isLast: i == entries.length - 1,
              ),
          ];
        }(),
      ),
    );
  }

  Widget _buildItem({
    BuildContext context,
    MapEntry<String, WidgetBuilder> entry,
    List<String> tags,
    bool isFirst,
    bool isLast,
  }) {
    return StoneItem(
      onTap: () => NavigateService.I.push(entry.value(context)),
      padding: EdgeInsets.all(12.0),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 12.0 : 0.0),
        bottom: Radius.circular(isLast ? 12.0 : 0.0),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Text(entry.key, style: AppTextStyles.blackW400(fontSize: 18.0)),
                    Expanded(child: Container()),
                  ],
                ),
                if (tags.isNotEmpty) SizedBox(height: 8.0),
                if (tags.isNotEmpty) _buildTags(tags),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16.0),
        ],
      ),
      divider: isLast ? null : Divider(
        height: 1.0,
        color: AppColors.dividerColor,
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 4.0,
      children: tags.map((tag) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: ShapeDecoration(
          color: Colors.red[300],
          shape: StadiumBorder(),
        ),
        child: Text(tag, style: AppTextStyles.whiteW400(fontSize: 10.0)),
      )).toList(),
    );
  }
}