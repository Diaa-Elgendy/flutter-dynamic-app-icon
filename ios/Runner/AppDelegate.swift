import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "dynamic_icon", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "getIcon":
        result(UIApplication.shared.alternateIconName ?? "DayIcon")

      case "setIcon":
        guard let args = call.arguments as? [String: Any],
              let iconName = args["icon"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Icon name is required", details: nil))
          return
        }

        guard UIApplication.shared.supportsAlternateIcons else {
          result(FlutterError(code: "NOT_SUPPORTED", message: "Alternate icons not supported on this device", details: nil))
          return
        }

        // nil resets to the primary icon; any other name maps to a CFBundleAlternateIcons key
        let alternateIconName: String? = (iconName == "DayIcon") ? nil : iconName
        self?.changeIcon(to: alternateIconName, result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func changeIcon(to iconName: String?, result: @escaping FlutterResult) {
    UIApplication.shared.setAlternateIconName(iconName) { error in
      if let error = error {
        result(FlutterError(code: "ICON_CHANGE_FAILED", message: error.localizedDescription, details: nil))
      } else {
        result(nil)
      }
    }
  }
}
