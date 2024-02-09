#import "SmartidFlutterPlugin.h"
#if __has_include(<smartid_flutter/smartid_flutter-Swift.h>)
#import <smartid_flutter/smartid_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "smartid_flutter-Swift.h"
#endif

@implementation SmartidFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmartidFlutterPlugin registerWithRegistrar:registrar];
}
@end
