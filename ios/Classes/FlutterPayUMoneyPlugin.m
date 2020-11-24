#import "FlutterPayUMoneyPlugin.h"
#if __has_include(<flutter_pay_u_money/flutter_pay_u_money-Swift.h>)
#import <flutter_pay_u_money/flutter_pay_u_money-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_pay_u_money-Swift.h"
#endif

@implementation FlutterPayUMoneyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPayUMoneyPlugin registerWithRegistrar:registrar];
}
@end
