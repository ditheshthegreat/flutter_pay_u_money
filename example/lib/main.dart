import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pay_u_money/flutter_pay_u_money.dart';
import 'package:flutter_pay_u_money/pay_u_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _platformVersion;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    PayUData _payuData = PayUData(
      environment: true,
      merchantId: "Uvd6Mj7rDI",
      merchantKey: "OlVevRfJ",
      productName: "sdklashd",
      txnId: "adawohdenwdjas",
      udfs: [
        "vava1",
        "vava2",
        "vava3",
        "vava4",
        "vava5",
        "vava6",
        "vava7",
        "vava8",
        "vava9",
      ],
      amount: "125",
      firstName: "Dithesh",
      email: "test@gmail.com",
      phone: "7012587943",
    );

    print(_payuData.udfs.join("|"));
    var result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      FlutterPayUMoney.test(payUData: _payuData).pay(successResponse: (data) {
        setState(() {
          _platformVersion = data;
        });
      }, failureResponse: (data) {
        print(data);
      });
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
              onPressed: () {
                initPlatformState();
              },
              child: Text("Pay")),
        ),
      ),
    );
  }
}
