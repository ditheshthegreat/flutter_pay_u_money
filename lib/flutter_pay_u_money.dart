import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pay_u_money/pay_u_data.dart';

class FlutterPayUMoney {
  static const MethodChannel _channel = MethodChannel('flutter_pay_u_money');
  final bool isTest;
  final PayUData payUData;

  ///For sandbox use test method or use production method
  FlutterPayUMoney.test({
    @required PayUData payUData,
  })  : isTest = true,
        payUData = payUData,
        assert(payUData != null),
        assert(payUData.udf.length <= 10);

  FlutterPayUMoney.production({@required PayUData payUData})
      : isTest = false,
        payUData = payUData,
        assert(payUData != null),
        assert(payUData.udf.length <= 10);

  Future<void> pay({Function(dynamic) successResponse, Function failureResponse}) async {
    _generateUDF();
    var result;
    if (isTest) {
      result = await _channel.invokeMethod('testPay', payUData.toJson());
    } else {
      result = await _channel.invokeMethod('livePay', payUData.toJson());
    }
    print('transaction result :: $result');
    if (result != null) {
      successResponse(result);
    } else {
      failureResponse(result);
    }
  }

  Future<String> hashIt() async {
    print('hashData :: ${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|'
        "${payUData.firstName}|${payUData.email}|${_generateUDF().join("|")}|${payUData.salt}");

    payUData.hash = await _channel.invokeMethod(
        'hashIt',
        '${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|${payUData.firstName}|'
            "${payUData.email}|${_generateUDF().join("|")}|${payUData.salt}");

    print('hashedIt:: ${payUData.hash}');
    return payUData.hash;
  }

  List<String> _generateUDF() {
    var createUDF = payUData.udf;
    if (createUDF.length < 10) {
      for (var i = payUData.udf.length; i < 10; i++) {
        createUDF.add('');
      }
    }
    return createUDF;
  }
}
