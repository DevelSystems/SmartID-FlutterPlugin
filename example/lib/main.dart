import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:smartid_flutter/models/account_model.dart';
import 'package:smartid_flutter/models/account_to_model.dart';
import 'package:smartid_flutter/models/credit_card_model.dart';
import 'package:smartid_flutter/models/credit_to_model.dart';
import 'package:smartid_flutter/models/debit_from_model.dart';
import 'package:smartid_flutter/models/device_model.dart';
import 'package:smartid_flutter/models/operation_model.dart';
import 'package:smartid_flutter/models/order_model.dart';
import 'package:smartid_flutter/models/transaction_model.dart';
import 'package:smartid_flutter/smartid_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController(text: 'test');
  TextEditingController licenseController = TextEditingController(text: 'HZYYaGB2Z3uubOfrwf8wMYBUi0MAneecMf8G0OB6O7F3');
  TextEditingController channelController = TextEditingController(text: '1');
  final SmartIdFlutter _smartIdFlutter = SmartIdFlutter();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SmartId flutter example app'),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: licenseController,
                    decoration: InputDecoration(
                      labelText: 'License',
                    ),
                  ),
                  TextFormField(
                    controller: channelController,
                    decoration: InputDecoration(
                      labelText: 'Channel',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the buttons to match the column width
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.initNativeInstance(licenseController.text, userNameController.text, false);
                          },
                          child: Text('Init Instance'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.linkNative(channelController.text, 'session');
                          },
                          child: Text('Link'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.unlinkNative(channelController.text, 'session');
                          },
                          child: Text('Unlink'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            OperationModel operationModel = OperationModel(
                                channelController.text,
                                DeviceModel(
                                    '',
                                    ''
                                ),
                                TransactionModel(
                                    'transfer',
                                    'CC to CA',
                                    'prueba',
                                    '',
                                    '',
                                    {}
                                ),
                                AccountModel(
                                    userNameController.text,
                                    0,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '123',
                                    ''
                                ),
                                AccountToModel(
                                    '',
                                    0,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    ''
                                ),
                                DebitFromModel(
                                    '123123123',
                                    '',
                                    ''
                                ),
                                CreditToModel(
                                    '123123124',
                                    '',
                                    ''
                                ),
                                CreditCardModel(
                                    '',
                                    '',
                                    '',
                                    ''
                                ),
                                OrderModel(
                                    10,
                                    'USD'
                                ),
                                'timeStamp'
                            );

                            SmartIdFlutter.createOperationNative(licenseController.text, operationModel, true);
                          },
                          child: Text('Create Operation'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
