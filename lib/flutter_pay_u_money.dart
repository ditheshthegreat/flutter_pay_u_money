import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pay_u_money/pay_u_data.dart';

final MethodChannel _channel = MethodChannel('flutter_pay_u_money');

class FlutterPayUMoney {
  ///whether it is test or live.
  final bool _isTest;

  ///Object data.
  final PayUData payUData;

  ///For sandbox use test method or use production method
  FlutterPayUMoney.test({
    @required PayUData payUData,
  })  : _isTest = true,
        payUData = payUData,
        assert(payUData != null),
        assert(payUData.udf.length <= 10);

  ///For sandbox use test method or use production method
  FlutterPayUMoney.production({@required PayUData payUData})
      : _isTest = false,
        payUData = payUData,
        assert(payUData != null),
        assert(payUData.udf.length <= 10);

  ///call to launch payumoney gateway.
  ///Before calling this method make sure the hash is not null.
  /// For generating hash natively call.
  /// ```
  /// await flutterPayUMoney.hashIt();
  /// ```
  ///
  /// StatusCode
  /// ```
  /// 200 = Success
  /// 400 = Failed
  /// 401 = Validation Error
  /// 402 = User Payment Cancelled
  /// ```
  Future<void> pay(
      {Function(String statusCode, dynamic) paymentResponse}) async {
    assert(payUData.hash != null && payUData.hash.isNotEmpty,
        'payUData.hash was called on null or empty. generate hash from server side or call method hashIt before calling pay method');

    _generateUDF();
    var result;
    if (_isTest) {
      try {
        result = await _channel
            .invokeMethod('testPay', payUData.toJson())
            .catchError((onError) {
          debugPrint(
              'Payment Failed :: ${(onError as PlatformException).toString()}');
          paymentResponse((onError as PlatformException).code,
              (onError as PlatformException).details);
        });
      } on Exception catch (e) {
        throw 'Something went wrong ${e.toString()}';
      }
    } else {
      try {
        result = await _channel
            .invokeMethod('livePay', payUData.toJson())
            .catchError((onError) {
          debugPrint(
              'Payment Failed :: ${(onError as PlatformException).toString()}');
          paymentResponse((onError as PlatformException).code,
              (onError as PlatformException).details);
        });
      } on Exception catch (e) {
        throw 'Something went wrong ${e.toString()}';
      }
    }
    debugPrint('transaction result :: $result');
    if (result != null) {
      paymentResponse('200', result);
    }
  }

  ///To generate hash natively.
  Future<void> hashIt() async {
    debugPrint(
        'hashData :: ${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|'
        "${payUData.firstName}|${payUData.email}|${_generateUDF().join("|")}|${payUData.salt}");

    try {
      payUData.hash = await _channel
          .invokeMethod(
              'hashIt',
              '${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|${payUData.firstName}|'
                  "${payUData.email}|${_generateUDF().join("|")}|${payUData.salt}")
          .catchError((onError) {
        throw (onError as PlatformException).toString();
      });
    } on Exception catch (e) {
      throw 'Hashing error ${e.toString()}';
    }

    debugPrint('hashedIt:: ${payUData.hash}');
  }

  ///Generate UDF up to ten when user gives blank udf.
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
