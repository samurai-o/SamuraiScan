#import "SamuraiScanPlugin.h"
#if __has_include(<samurai_scan/samurai_scan-Swift.h>)
#import <samurai_scan/samurai_scan-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "samurai_scan-Swift.h"
#endif

@implementation SamuraiScanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSamuraiScanPlugin registerWithRegistrar:registrar];
}
@end
