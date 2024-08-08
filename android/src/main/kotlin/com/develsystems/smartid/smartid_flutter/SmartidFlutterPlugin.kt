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
  private var appContext: Context? = null;
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.appContext = flutterPluginBinding.applicationContext;
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "smartid_flutter")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
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

  private fun initSmartId(call: MethodCall, result: Result) {
    SmartId.initInstance(
      appContext!!,
      call.argument("license"),
      call.argument("username"),
      call.argument<Boolean>("isProduction")!!
    )
    result.success("init Success")
  }

  private fun linkSmartId(call: MethodCall, result: Result) {
    SmartId.getInstance().Link(
      call.argument("channel"),
      call.argument("session")
    )
    result.success("link success")
  }

  private fun unlinkSmartId(call: MethodCall, result: Result) {
    SmartId.getInstance().UnLink(
      call.argument("channel"),
      call.argument("session")
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

    if (map.containsKey("channelId")) {
      model.channelId = (map["channelId"] as String).toInt()
    }
    if (map.containsKey("device") && map["device"] is Map<*, *>) {
      model.device = convertMapToDevice(map["device"] as Map<String, Any>)
    }
    if (map.containsKey("transaction") && map["transaction"] is Map<*, *>) {
      model.transaction = convertMapToTransaction(map["transaction"] as Map<String, Any>)
    }
    if (map.containsKey("account") && map["account"] is Map<*, *>) {
      model.account = convertMapToAccount(map["account"] as Map<String, Any>)
    }
    if (map.containsKey("accountTo") && map["accountTo"] is Map<*, *>) {
      model.accountTo = convertMapToAccountTo(map["accountTo"] as Map<String, Any>)
    }
    if (map.containsKey("debitFrom") && map["debitFrom"] is Map<*, *>) {
      model.debitFrom = convertMapToDebitFrom(map["debitFrom"] as Map<String, Any>)
    }
    if (map.containsKey("creditTo") && map["creditTo"] is Map<*, *>) {
      model.creditTo = convertMapToCreditTo(map["creditTo"] as Map<String, Any>)
    }
    if (map.containsKey("creditCard") && map["creditCard"] is Map<*, *>) {
      model.creditCard = convertMapToCreditCard(map["creditCard"] as Map<String, Any>)
    }
    if (map.containsKey("order") && map["order"] is Map<*, *>) {
      model.order = convertMapToOrder(map["order"] as Map<String, Any>)
    }

    return model
  }
  private fun convertMapToDevice(map: Map<String, Any>): Device {
    val device = Device()

    map.getSafe<String>("smartId")?.let { device.smartId = it }
    map.getSafe<String>("ipAddress")?.let { device.ipAddress = it }

    return device
  }

  private fun convertMapToTransaction(map: Map<String, Any>): Transaction {
    val transaction = Transaction()

    map.getSafe<String>("category")?.let { transaction.category = it }
    map.getSafe<String>("type")?.let { transaction.type = it }
    map.getSafe<String>("description")?.let { transaction.description = it }
    map.getSafe<String>("reference")?.let { transaction.reference = it }
    map.getSafe<String>("date")?.let { transaction.date = it }
    map.getSafe<HashMap<String, String>>("details")?.let { transaction.details = it }

    return transaction
  }

  private fun convertMapToAccount(map: Map<String, Any>): Account {
    val account = Account()

    map.getSafe<String>("client")?.let { account.client = it }
    map.getSafe<Int>("clientRefId")?.let { account.clientRefId = it }
    map.getSafe<String>("clientRefIdStr")?.let { account.clientRefIdStr = it }
    map.getSafe<String>("email")?.let { account.email = it }
    map.getSafe<String>("phoneNumber")?.let { account.phoneNumber = it }
    map.getSafe<String>("session")?.let { account.session = it }
    map.getSafe<String>("accountNumber")?.let { account.accountNumber = it }
    map.getSafe<String>("bank")?.let { account.bank = it }

    return account
  }

  private fun convertMapToAccountTo(map: Map<String, Any>): AccountTo {
    val accountTo = AccountTo()

    map.getSafe<String>("client")?.let { accountTo.client = it }
    map.getSafe<Int>("clientRefId")?.let { accountTo.clientRefId = it }
    map.getSafe<String>("clientRefIdStr")?.let { accountTo.clientRefIdStr = it }
    map.getSafe<String>("email")?.let { accountTo.email = it }
    map.getSafe<String>("phoneNumber")?.let { accountTo.phoneNumber = it }
    map.getSafe<String>("session")?.let { accountTo.session = it }
    map.getSafe<String>("accountNumber")?.let { accountTo.accountNumber = it }
    map.getSafe<String>("bank")?.let { accountTo.bank = it }

    return accountTo
  }

  private fun convertMapToDebitFrom(map: Map<String, Any>): DebitFrom {
    val debitFrom = DebitFrom()

    map.getSafe<String>("account")?.let { debitFrom.account = it }
    map.getSafe<String>("bank")?.let { debitFrom.bank = it }
    map.getSafe<String>("currency")?.let { debitFrom.currency = it }

    return debitFrom
  }

  private fun convertMapToCreditTo(map: Map<String, Any>): CreditTo {
    val creditTo = CreditTo()

    map.getSafe<String>("account")?.let { creditTo.account = it }
    map.getSafe<String>("bank")?.let { creditTo.bank = it }
    map.getSafe<String>("currency")?.let { creditTo.currency = it }

    return creditTo
  }

  private fun convertMapToCreditCard(map: Map<String, Any>): CreditCard {
    val creditCard = CreditCard()

    map.getSafe<String>("bin")?.let { creditCard.bin = it }
    map.getSafe<String>("hash")?.let { creditCard.hash = it }
    map.getSafe<String>("last4Digits")?.let { creditCard.last4Digits = it }
    map.getSafe<String>("token")?.let { creditCard.token = it }

    return creditCard
  }


  private fun convertMapToOrder(map: Map<String, Any>): Order {
    val order = Order()

    map.getSafe<Double>("amount")?.let { order.amount = it }
    map.getSafe<String>("currency")?.let { order.currency = it }

    return order
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun <T> Map<String, Any>.getSafe(key: String): T? {
    return if (this.containsKey(key) && this[key] != null) {
      this[key] as? T
    } else {
      null
    }
  }

}
