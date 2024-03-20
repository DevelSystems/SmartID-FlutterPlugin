
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:smartid_flutter/models/operation_model.dart';

class SmartIdFlutter {
  static const MethodChannel _channel = MethodChannel('smartid_flutter');

  static const String initInstance = 'initInstance';
  static const String link = 'link';
  static const String unlink = 'unlink';
  static const String createOperation = 'createOperation';

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> initNativeInstance(String license, String username, bool isProduction) async {
    var result = await _channel.invokeMethod(initInstance, {
      "license": license,
      "username": username,
      "isProduction": isProduction
    });
    print('Init result: $result');
  }

  static Future<void> linkNative(String channel, String session) async {
    var result = await _channel.invokeMethod(link, {
      "channel": channel,
      "session": session
    });
    print('Link result: $result');
  }

  static Future<void> unlinkNative(String channel, String session) async {
    var result = await _channel.invokeMethod(unlink, {
      "channel": channel,
      "session": session
    });
    print('UnLink result: $result');

  }

  static Future<void> createOperationNative(String license, OperationModel operationModel, bool isProduction) async {
    final Map<String, dynamic> operationMap = operationModel.toJson();
    var result = await _channel.invokeMethod(createOperation, {
      "license": license,
      "operation": operationMap,
      "isProduction": isProduction
    });
    print('Create operation result: $result');

  }
}
