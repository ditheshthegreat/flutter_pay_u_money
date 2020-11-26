import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var _resultData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initPlatformState() async {
    PayUData _payuData = PayUData(
      ///your merchant ID
      merchantId: "",

      ///your merchant key
      merchantKey: "",

      ///your salt
      salt: "",

      ///product name
      productName: "blah blah",

      /// custom transaction id
      txnId: "some1234thing",

      ///optional you can add an hash from server side or you can generate from here
      ///the hash sequence should be => key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||salt;
      //hash: "",

      ///this udfs[User Defined Field] is optional you can add up to 10 if you want extra field to pass
      // udf: ["udf1", "udf2", "udf3", "udf4", "udf5", "udf6", "udf7", "udf8", "udf9", "udf10"],
      amount: "125",
      firstName: "tester",
      email: "test@gmail.com",
      phone: "9876543210",
    );

    ///for sandbox
    FlutterPayUMoney _flutterPayUMoney = FlutterPayUMoney.test(payUData: _payuData);

    ///for live
    // FlutterPayUMoney _flutterPayUMoney = FlutterPayUMoney.production(payUData: _payuData);

    ///if you want generate hash call [hashIt()]
    await _flutterPayUMoney.hashIt();
    await _flutterPayUMoney.pay(successResponse: (data) {
      setState(() {
        _resultData = data;
      });
    }, failureResponse: (data) {
      print(data);
      setState(() {
        _resultData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter PayUMoney example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RaisedButton(
                  onPressed: () {
                    initPlatformState();
                  },
                  child: Text("Pay")),
            ),
            Text("Result: $_resultData"),
          ],
        ),
      ),
    );
  }
}
