package com.develsystems.smartid.smartid_flutter

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.develsystems.smartid.SmartId
import com.develsystems.smartid.models.Account
import com.develsystems.smartid.models.AccountTo
import com.develsystems.smartid.models.CreditCard
import com.develsystems.smartid.models.CreditTo
import com.develsystems.smartid.models.DebitFrom
import com.develsystems.smartid.models.Device
import com.develsystems.smartid.models.Model
import com.develsystems.smartid.models.Operation
import com.develsystems.smartid.models.Order
import com.develsystems.smartid.models.Transaction
import java.util.HashMap

/** SmartidFlutterPlugin */
class SmartidFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var appContext: Context? = null;
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.appContext = flutterPluginBinding.applicationContext;
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartid_flutter")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "initInstance" -> {
        initSmartId(call, result)
      }
      "link" -> {
        linkSmartId(call, result)
      }
      "unlink" -> {
        unlinkSmartId(call, result)
      }
      "createOperation" -> {
        createOperationSmartId(call, result)
      }
      else -> result.notImplemented()
    }
  }

  fun initSmartId(call: MethodCall, result: Result) {
    var instance = SmartId.initInstance(
      appContext!!,
      call.argument<String>("license"),
      call.argument<String>("username"),
      call.argument<Boolean>("isProduction")!!
    )
    result.success("init Success")
  }

  fun linkSmartId(call: MethodCall, result: Result) {
    SmartId.getInstance().Link(
      call.argument<String>("channel"),
      call.argument<String>("session")
    )
    result.success("link success")
  }

  fun unlinkSmartId(call: MethodCall, result: Result) {
    SmartId.getInstance().UnLink(
      call.argument<String>("channel"),
      call.argument<String>("session")
    )
    result.success("unlink success")
  }

  fun createOperationSmartId(call: MethodCall, result: Result) {
    val license = call.argument<String>("license")!!
    val isProduction = call.argument<Boolean>("isProduction")!!
    val operationMap = call.argument<Map<String, Any>>("operation")!!

    val operationModel = convertMapToOperation(operationMap)

    SmartId.getInstance().CreateOperation(
      appContext,
      license,
      operationModel,
      isProduction
    )
    result.success("Create operation success")
  }

  private fun convertMapToOperation(map: Map<String, Any>): Operation {
    val operation = Operation()

    operation.model = convertMapToModel(map)

    return operation
  }

  private fun convertMapToModel(map: Map<String, Any>): Model? {
    val model = Model()

    model.channelId = (map["channelId"] as String).toInt()
    model.device = convertMapToDevice(map["device"] as Map<String, Any>)
    model.transaction = convertMapToTransaction(map["transaction"] as Map<String, Any>)
    model.account = convertMapToAccount(map["account"] as Map<String, Any>)
    model.accountTo = convertMapToAccountTo(map["accountTo"] as Map<String, Any>)
    model.debitFrom = convertMapToDebitFrom(map["debitFrom"] as Map<String, Any>)
    model.creditTo = convertMapToCreditTo(map["creditTo"] as Map<String, Any>)
    model.creditCard = convertMapToCreditCard(map["creditCard"] as Map<String, Any>)
    model.order = convertMapToOrder(map["order"] as Map<String, Any>)

    return model
  }

  private fun convertMapToDevice(map: Map<String, Any>): Device? {
    val device = Device()

    device.smartId = map["smartId"] as String
    device.ipAddress = map["ipAddress"] as String

    return device
  }

  private fun convertMapToTransaction(map: Map<String, Any>): Transaction? {
    val transaction = Transaction()

    transaction.category = map["category"] as String
    transaction.type = map["type"] as String
    transaction.description = map["description"] as String
    transaction.reference = map["reference"] as String
    transaction.date = map["date"] as String
    transaction.details = map["details"] as HashMap<String, String>

    return transaction
  }

  private fun convertMapToAccount(map: Map<String, Any>): Account? {
    val account = Account()

    account.client = map["client"] as String
    account.clientRefId = map["clientRefId"] as Int
    account.clientRefIdStr = map["clientRefIdStr"] as String
    account.email = map["email"] as String
    account.phoneNumber = map["phoneNumber"] as String
    account.session = map["session"] as String
    account.accountNumber = map["accountNumber"] as String
    account.bank = map["bank"] as String

    return account
  }

  private fun convertMapToAccountTo(map: Map<String, Any>): AccountTo? {
    val accountTo = AccountTo()

    accountTo.client = map["client"] as String
    accountTo.clientRefId = map["clientRefId"] as Int
    accountTo.clientRefIdStr = map["clientRefIdStr"] as String
    accountTo.email = map["email"] as String
    accountTo.phoneNumber = map["phoneNumber"] as String
    accountTo.session = map["session"] as String
    accountTo.accountNumber = map["accountNumber"] as String
    accountTo.bank = map["bank"] as String

    return accountTo
  }

  private fun convertMapToDebitFrom(map: Map<String, Any>): DebitFrom? {
    val debitFrom = DebitFrom()

    debitFrom.account = map["account"] as String
    debitFrom.bank= map["bank"] as String
    debitFrom.currency = map["currency"] as String

    return debitFrom
  }

  private fun convertMapToCreditTo(map: Map<String, Any>): CreditTo? {
    val creditTo = CreditTo()

    creditTo.account = map["account"] as String
    creditTo.bank= map["bank"] as String
    creditTo.currency = map["currency"] as String

    return creditTo
  }

  private fun convertMapToCreditCard(map: Map<String, Any>): CreditCard? {
    val creditCard = CreditCard()

    creditCard.bin = map["bin"] as String
    creditCard.hash = map["hash"] as String
    creditCard.last4Digits = map["last4Digits"] as String
    creditCard.token = map["token"] as String

    return creditCard
  }

  private fun convertMapToOrder(map: Map<String, Any>): Order? {
    val order = Order()

    order.amount = map["amount"] as Double
    order.currency = map["currency"] as String

    return order
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
