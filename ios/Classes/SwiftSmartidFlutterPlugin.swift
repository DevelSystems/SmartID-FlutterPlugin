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
        
        let cleanedOperationDict = operationDict.removingNullsAndProvidingDefaults()


        if var coreOperation = convertToCoreOperation(dict: cleanedOperationDict) {
            let newAccount = Account(
                client: coreOperation.account?.client ?? "",
                clientRefId: 0,
                clientRefIdStr: "",
                email: "",
                phoneNumber: "",
                session: "",
                accountNumber: "",
                bank: ""
            )

            coreOperation.account?.client = newAccount.client
            
            SID.shared.createOperation(channel: license, operation: coreOperation)
            result("Create operation success")
        } else {
            result(FlutterError(code: "DECODE_ERROR", message: "Failed to convert operation dictionary", details: nil))
        }
    }

    
    private func convertToCoreOperation(dict: [String: Any]) -> CoreOperation? {
        guard let channelId = dict["channelId"] as? String else { return nil }
        let device = dict["device"] as? [String: Any]
        let transaction = dict["transaction"] as? [String: Any]
        let account = dict["account"] as? [String: Any]
        let accountTo = dict["accountTo"] as? [String: Any]
        let debitFrom = dict["debitFrom"] as? [String: Any]
        let creditTo = dict["creditTo"] as? [String: Any]
        let creditCard = dict["creditCard"] as? [String: Any]
        let order = dict["order"] as? [String: Any]
        let timestamp = dict["timestamp"] as? String

        let coreOperation = CoreOperation(
            channelId: channelId,
            device: device != nil ? convertToDevice(dict: device!) : nil,
            transaction: transaction != nil ? convertToTransaction(dict: transaction!) : nil,
            account: account != nil ? convertToAccount(dict: account!) : nil,
            accountTo: accountTo != nil ? convertToAccount(dict: accountTo!) : nil,
            debitFrom: debitFrom != nil ? convertToBankAccount(dict: debitFrom!) : nil,
            creditTo: creditTo != nil ? convertToBankAccount(dict: creditTo!) : nil,
            creditCard: creditCard != nil ? convertToCreditCard(dict: creditCard!) : nil,
            order: order != nil ? convertToOrder(dict: order!) : nil,
            timestamp: timestamp
        )

        return coreOperation
    }

    private func convertToAccount(dict: [String: Any]) -> Account {
        return Account(
            client: dict["client"] as? String ?? "",
            clientRefId: dict["clientRefId"] as? Int ?? 0,
            clientRefIdStr: dict["clientRefIdStr"] as? String ?? "",
            email: dict["email"] as? String ?? "",
            phoneNumber: dict["phoneNumber"] as? String ?? "",
            session: dict["session"] as? String ?? "",
            accountNumber: dict["accountNumber"] as? String ?? "",
            bank: dict["bank"] as? String ?? ""
        )
    }

    private func convertToBankAccount(dict: [String: Any]) -> BankAccount {
        return BankAccount(
            account: dict["account"] as? String ?? "",
            bank: dict["bank"] as? String ?? "",
            currency: dict["currency"] as? String ?? ""
        )
    }

    private func convertToTransaction(dict: [String: Any]) -> Transaction {
        return Transaction(
            category: dict["category"] as? String ?? "",
            type: dict["type"] as? String ?? "",
            description: dict["description"] as? String ?? "",
            reference: dict["reference"] as? String ?? "",
            date: dict["date"] as? String,
            details: dict["details"] as? [String: String] ?? [:]
        )
    }

    private func convertToDevice(dict: [String: Any]) -> Device {
        return Device(
            smartId: dict["smartId"] as? String ?? "",
            ipAddress: dict["ipAddress"] as? String ?? "",
            userAgent: dict["userAgent"] as? String ?? ""
        )
    }

    private func convertToCreditCard(dict: [String: Any]) -> CreditCard {
        return CreditCard(
            bin: dict["bin"] as? String ?? "",
            hash: dict["hash"] as? String ?? "",
            last4Digits: dict["last4Digits"] as? String ?? "",
            token: dict["token"] as? String ?? ""
        )
    }

    private func convertToOrder(dict: [String: Any]) -> Order {
        return Order(
            amount: dict["amount"] as? Decimal ?? 0,
            currency: dict["currency"] as? String ?? ""
        )
    }

}

extension Dictionary where Key == String {
    func removingNullsAndProvidingDefaults() -> Dictionary {
        var dict = self
        let keysWithNullValues = dict.keys.filter { dict[$0] is NSNull || dict[$0] == nil }
        for key in keysWithNullValues {
            dict[key] = defaultForType(key: key)
        }

        for (key, value) in dict {
            if let nestedDict = value as? [String: Any] {
                dict[key] = nestedDict.removingNullsAndProvidingDefaults() as? Value
            }
        }
        return dict
    }
    
    private func defaultForType(key: String) -> Value? {
        switch key {
        case "client", "clientRefIdStr", "email", "phoneNumber", "session", "accountNumber", "bank", "category", "type", "description", "reference", "currency", "timeStamp", "bin", "hash", "last4Digits", "token", "smartId":
            return "" as? Value
        case "clientRefId", "channelId":
            return 0 as? Value
        case "amount":
            return 0.0 as? Value
        case "details":
            return [:] as? Value
        case "device", "transaction", "account", "accountTo", "debitFrom", "creditTo", "creditCard", "order":
            return nil // Devolver nil para objetos anidados que serán manejados de otra manera
        default:
            return nil
        }
    }
}
