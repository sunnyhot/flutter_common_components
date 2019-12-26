import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jdl_flutter_kit/jdl_flutter_kit.dart';
import 'package:jdl_flutter_kit_example/constant/colors.dart';

import 'shop.dart';

/// [buildJDLFutureBody]、[StoneFetchDataError]、[StoneJson]
class FutureBodyDemoPage extends StatefulWidget {
  @override
  _FutureBodyDemoPageState createState() => _FutureBodyDemoPageState();
}

class _FutureBodyDemoPageState extends State<FutureBodyDemoPage> {
  Future<List<List<Shop>>> _dataFuture;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('FutureBody'),
      centerTitle: true,
      leading: StoneBackButton(),
      actions: <Widget>[
        StoneBarButton(
          onPressed: _fetchData,
          title: Icon(Icons.refresh),
        ),
        StoneBarButton(
          onPressed: () => _fetchData(StoneFetchDataError(type: StoneFetchDataErrorType.networkError)),
          title: Icon(Icons.network_wifi),
        ),
        StoneBarButton(
          onPressed: () => _fetchData(StoneFetchDataError(type: StoneFetchDataErrorType.noList)),
          title: Icon(Icons.not_interested),
        )
      ],
    );
  }

  Widget _buildBody() {
    return buildJDLFutureBody<List<List<Shop>>>(
      onRetry: _fetchData,
      future: _dataFuture,
      contentBuilder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, List<List<Shop>> shopGroups) {
    return StoneListView.grouped(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10 + MediaQuery.of(context).padding.bottom),
      sectionCount: shopGroups.length,
      itemCount: (section) => shopGroups[section].length,
      itemBuilder: (context, section, index) => _buildItem(context, section, index, shopGroups),
      headerBuilder: (_, section) => SizedBox(height: 10.0),
    );
  }

  Widget _buildItem(BuildContext context, int section, int index, List<List<Shop>> shopGroups) {
    final group = shopGroups[section];
    final shop = group[index];
    final isFirst = index == 0;
    final isLast = index == group.length - 1;

    final content = Row(
      children: <Widget>[
        Icon(
          IconData(shop.iconCode, fontFamily: "MaterialIcons"),
          color: AppColors.red,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
                child: Text(
                    shop.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)
                ),
              ),
              SizedBox(height: 8.0),
              Text(shop.address),
            ],
          ),
        ),
      ],
    );

    return StoneItem(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 12.0 : 0.0),
        bottom: Radius.circular(isLast ? 12.0 : 0.0),
      ),
      divider: isLast ? null : Divider(
        height: 1.0,
        color: Color(0xFFD9D9D9),
      ),
      child: content,
    );
  }

  void _fetchData([StoneFetchDataError error]) {
    setState(() {
      _dataFuture = _DataProvider.fetchShopGroup(error);
    });
  }
}

class _DataProvider {
  static Future<List<List<Shop>>> fetchShopGroup([StoneFetchDataError error]) async {
    Completer<List<List<Shop>>> completer = Completer();

    // 模拟网络请求
    Future.delayed(Duration(milliseconds: 500), () async {
      if (error != null) {
        completer.completeError(error);
        return;
      }

      final jsonString = await rootBundle.loadString('res/shops.json');
      final jsonData = StoneJson.decode(jsonString);

      final shopGroups = jsonData.listValue().map((groupJson) {
        return groupJson.listValue().map((shopJson) => Shop.fromJson(shopJson)).toList();
      }).toList();

      completer.complete(shopGroups);
    });

    return completer.future;
  }
}