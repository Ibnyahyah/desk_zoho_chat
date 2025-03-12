import Flutter
import UIKit

public class SwiftDeskZohoChatPlugin: NSObject, FlutterPlugin {
    
    // Registers the plugin with Flutter
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "desk_zoho_chat", binaryMessenger: registrar.messenger())
        let instance = SwiftDeskZohoChatPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // Handles incoming method calls from Flutter
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented) // Handle unknown method calls
        }
    }
}
