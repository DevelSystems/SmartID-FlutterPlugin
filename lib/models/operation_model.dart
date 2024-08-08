import 'package:smartid_flutter/models/account_model.dart';
import 'package:smartid_flutter/models/account_to_model.dart';
import 'package:smartid_flutter/models/credit_card_model.dart';
import 'package:smartid_flutter/models/credit_to_model.dart';
import 'package:smartid_flutter/models/debit_from_model.dart';
import 'package:smartid_flutter/models/device_model.dart';
import 'package:smartid_flutter/models/order_model.dart';
import 'package:smartid_flutter/models/transaction_model.dart';

class OperationModel {
  String? channelId;
  DeviceModel? device;
  TransactionModel? transaction;
  AccountModel? account;
  AccountToModel? accountTo;
  DebitFromModel? debitFrom;
  CreditToModel? creditTo;
  CreditCardModel? creditCard;
  OrderModel? order;
  String? timeStamp;

  OperationModel({
    this.channelId,
    this.device,
    this.transaction,
    this.account,
    this.accountTo,
    this.debitFrom,
    this.creditTo,
    this.creditCard,
    this.order,
    this.timeStamp,
  });

  Map<String, dynamic> toJson() => {
        'channelId': channelId,
        'device': device?.toJson(),
        'transaction': transaction?.toJson(),
        'account': account?.toJson(),
        'accountTo': accountTo?.toJson(),
        'debitFrom': debitFrom?.toJson(),
        'creditTo': creditTo?.toJson(),
        'creditCard': creditCard?.toJson(),
        'order': order?.toJson(),
        'timeStamp': timeStamp,
      };
}
