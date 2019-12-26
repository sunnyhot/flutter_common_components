import 'package:flutter/material.dart';
import 'package:jdl_flutter_kit/constant/jdl_assets.dart';
import 'package:jdl_flutter_kit/constant/jdl_colors.dart';
import 'package:jdl_flutter_kit/constant/jdl_styles.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';

/// 基于 [FutureBuilder] 的页面内容脚手架
///
/// 提供了默认的 [loadingBuilder] 和 [errorBuilder]。
/// 建议在你的 App 中定义一个全局的 [errorConverter]，将任意类型的 error 转换为 [StoneFetchDataError]。
StoneFutureBody<T> buildJDLFutureBody<T>({
  Key key,
  VoidCallback onRetry,
  T initialData,
  @required Future<T> future,
  WidgetBuilder loadingBuilder = _buildLoading,
  @required StoneAsyncBodyContentBuilder<T> contentBuilder,
  StoneAsyncBodyErrorBuilder errorBuilder = _buildError,
  StoneAsyncBodyErrorConverter errorConverter,
}) => StoneFutureBody<T>(
  key: key,
  onRetry: onRetry,
  initialData: initialData,
  future: future,
  loadingBuilder: loadingBuilder,
  contentBuilder: contentBuilder,
  errorBuilder: errorBuilder,
  errorConverter: errorConverter,
);

/// 基于 [StreamBuilder] 的页面内容脚手架
///
/// 提供了默认的 [loadingBuilder] 和 [errorBuilder]。
/// 建议在你的 App 中定义一个全局的 [errorConverter]，将任意类型的 error 转换为 [StoneFetchDataError]。
StoneStreamBody<T> buildJDLStreamBody<T>({
  Key key,
  VoidCallback onRetry,
  T initialData,
  @required Stream<T> stream,
  WidgetBuilder loadingBuilder = _buildLoading,
  @required StoneAsyncBodyContentBuilder<T> contentBuilder,
  StoneAsyncBodyErrorBuilder errorBuilder = _buildError,
  StoneAsyncBodyErrorConverter errorConverter,
}) => StoneStreamBody<T>(
  key: key,
  onRetry: onRetry,
  initialData: initialData,
  stream: stream,
  loadingBuilder: loadingBuilder,
  contentBuilder: contentBuilder,
  errorBuilder: errorBuilder,
  errorConverter: errorConverter,
);

Widget _buildLoading(BuildContext context) {
  return _LoadingWidget();
}

Widget _buildError(BuildContext context, StoneFetchDataError error, VoidCallback onRetry) {
  return _ErrorWidget(onPressedButton: onRetry, error: error);
}

/// 展示页面 Loading 状态的组件
class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: JDLColors.white,
      child: CircularProgressIndicator(),
    );
  }
}

/// 展示页面获取数据失败状态的组件
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    this.onPressedButton,
    @required this.error,
  });

  final VoidCallback onPressedButton;
  final StoneFetchDataError error;

  @override
  Widget build(BuildContext context) {
    AssetImage image;
    String message;
    String buttonText;

    switch (error.type) {
      case StoneFetchDataErrorType.networkError:
        message = error.message ?? '世界上最遥远的距离是没有网！';
        image ??= JDLImages.imgNoNetwork;
        buttonText = '重试';
        break;
      case StoneFetchDataErrorType.fetchFailed:
        message = error.message ?? '获取数据失败！';
        image ??= JDLImages.imgNoData;
        buttonText = '重试';
        break;
      case StoneFetchDataErrorType.noData:
        message = error.message ?? '当前无数据！';
        image ??= JDLImages.imgNoData;
        buttonText = '刷新';
        break;
      case StoneFetchDataErrorType.noList:
        message = error.message ?? '当前无数据！';
        image ??= JDLImages.imgNoList;
        buttonText = '刷新';
        break;
    }

    final items = <Widget>[
      Image(image: image),
      SizedBox(height: 12.0),
      Text(
        message,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: JDLTextStyles.lightGreyW400(fontSize: 15.0),
      ),
    ];

    if (onPressedButton != null) {
      items.add(SizedBox(height: 32.0));
      items.add(
        IntrinsicWidth(
          child: StoneButton(
            onPressed: onPressedButton,
            textStyle: TextStyle(color: JDLColors.white, fontSize: 16.0, fontWeight: FontWeight.w400),
            gradient: LinearGradient(colors: JDLColors.readGradient),
            borderRadius: BorderRadius.circular(8.0),
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            constraints: BoxConstraints(minWidth: 120.0),
            height: 36.0,
            child: Text(buttonText, maxLines: 1),
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 80.0),
      color: JDLColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}