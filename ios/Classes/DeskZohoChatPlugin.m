#import "DeskZohoChatPlugin.h"
#if __has_include(<desk_zoho_chat/desk_zoho_chat-Swift.h>)
#import <desk_zoho_chat/desk_zoho_chat-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "desk_zoho_chat-Swift.h"
#endif

@implementation DeskZohoChatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeskZohoChatPlugin registerWithRegistrar:registrar];
}
@end
