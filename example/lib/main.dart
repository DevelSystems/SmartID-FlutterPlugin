import 'package:flutter/material.dart';
import 'package:smartid_flutter/models/account_model.dart';
import 'package:smartid_flutter/models/credit_to_model.dart';
import 'package:smartid_flutter/models/debit_from_model.dart';
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
  TextEditingController userNameController =
      TextEditingController(text: 'test');
  TextEditingController licenseController = TextEditingController(
      text: 'AHvO67N79kYfp3Tsq09Wq4mOrhNCLCdhHjT5xWxA4crZ');
  TextEditingController channelController = TextEditingController(text: '1');

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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: licenseController,
                    decoration: const InputDecoration(
                      labelText: 'License',
                    ),
                  ),
                  TextFormField(
                    controller: channelController,
                    decoration: const InputDecoration(
                      labelText: 'Channel',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .stretch, // Stretch the buttons to match the column width
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.initNativeInstance(
                                licenseController.text,
                                userNameController.text,
                                false);
                          },
                          child: const Text('Init Instance'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.linkNative(
                                channelController.text, 'session');
                          },
                          child: const Text('Link'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            SmartIdFlutter.unlinkNative(
                                channelController.text, 'session');
                          },
                          child: const Text('Unlink'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            OperationModel operationModel = OperationModel(
                                channelId: channelController.text,
                                transaction: TransactionModel(
                                    category: 'transfer',
                                    type: 'CC to CA',
                                    description: 'prueba',
                                    details: {}),
                                account: AccountModel(
                                    client: userNameController.text,
                                    accountNumber: '123'),
                                debitFrom: DebitFromModel(
                                  account: '123123123',
                                ),
                                creditTo: CreditToModel(account: '123123124'),
                                order:
                                    OrderModel(amount: 10.0, currency: 'USD'),
                                timeStamp: 'timeStamp');

                            SmartIdFlutter.createOperationNative(
                                licenseController.text, operationModel, true);
                          },
                          child: const Text('Create Operation'),
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
