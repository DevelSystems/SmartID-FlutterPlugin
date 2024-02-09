import Flutter
import UIKit
import SmartId

public class SwiftSmartidFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "smartid_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftSmartidFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let argsMap: NSDictionary = call.arguments as! NSDictionary

        switch call.method {
            case "initInstance":
                initSmartId(arguments: argsMap, result: result)
            case "link":
                linkSmartId(arguments: argsMap, result: result)
            case "unlink":
                unlinkSmartId(arguments: argsMap, result: result)
            case "createOperation":
                createOperation(arguments: argsMap, result: result)
            default:
                result(FlutterMethodNotImplemented)
        }
  }

  private func initSmartId(arguments: NSDictionary, result: @escaping FlutterResult) {
          let license = arguments["license"] as! String
          let username = arguments["username"] as! String
          let isProduction = arguments["isProduction"] as! Bool
          SID.start(license: license, username: username, isProduction: isProduction)
          result("init Success")
      }

      private func linkSmartId(arguments: NSDictionary, result: @escaping FlutterResult) {
          let channel = arguments["channel"] as! String
          let session = arguments["session"] as! String

          SID.shared.link(channel: channel, session: session)

          result("link success")

      }

      private func unlinkSmartId(arguments: NSDictionary, result: @escaping FlutterResult) {
          let channel = arguments["channel"] as! String
          let session = arguments["session"] as! String

          SID.shared.unlink(channel: channel, session: session)

          result("unlink success")

      }
    
    private func createOperation(arguments: NSDictionary, result: @escaping FlutterResult) {
        guard let license = arguments["license"] as? String,
              let operationDict = arguments["operation"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments received", details: nil))
            return
        }

        do {
            print("Operation JSON: \(operationDict)")

            let operationData = try JSONSerialization.data(withJSONObject: operationDict, options: [])

            let decoder = JSONDecoder()
            do {
                let operation = try decoder.decode(CoreOperation.self, from: operationData)
                SID.shared.createOperation(channel: license, operation: operation)
            } catch let error {
                print("Decoding error: \(error)")
                // Consider using a more detailed error response to send back to Flutter
                result(FlutterError(code: "DECODE_ERROR", message: "Failed to decode operation", details: error.localizedDescription))
                return
            }
            result("Create operation success")
        } catch {
            result(FlutterError(code: "DECODE_ERROR", message: "Failed to decode operation", details: error.localizedDescription))
        }
    }

}
