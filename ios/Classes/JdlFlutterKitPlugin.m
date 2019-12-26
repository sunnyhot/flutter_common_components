#import "JdlFlutterKitPlugin.h"
#if __has_include(<jdl_flutter_kit/jdl_flutter_kit-Swift.h>)
#import <jdl_flutter_kit/jdl_flutter_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "jdl_flutter_kit-Swift.h"
#endif

@implementation JdlFlutterKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJdlFlutterKitPlugin registerWithRegistrar:registrar];
}
@end
