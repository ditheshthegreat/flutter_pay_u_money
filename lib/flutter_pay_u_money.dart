import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_pay_u_money/pay_u_data.dart';

class FlutterPayUMoney {
  static const MethodChannel _channel = const MethodChannel('flutter_pay_u_money');
  final bool isTest;
  final PayUData payUData;
  Future successResponse;
  final Future failureResponse;

  FlutterPayUMoney.test({PayUData payUData, Future successResponse, Future failureResponse})
      : this.isTest = true,
        this.payUData = payUData,
        assert(payUData != null),
        assert(payUData.udfs.length <= 10),
        this.successResponse = successResponse,
        this.failureResponse = failureResponse;

  FlutterPayUMoney.production({PayUData payUData, Future successResponse, Future failureResponse})
      : this.isTest = false,
        this.payUData = payUData,
        this.successResponse = successResponse,
        this.failureResponse = failureResponse;

  void pay({Function(dynamic) successResponse, Function failureResponse}) async {
    List<String> createUDF = payUData.udfs;
    if (createUDF.length < 10) {
      for (int i = payUData.udfs.length; i < 10; i++) {
        createUDF.add("");
      }
    }
    print("UDF :: ${createUDF.length}  ${createUDF.join("|")}");
    print(
        "HASH :: ${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|${payUData.firstName}|${payUData.email}|${createUDF.join("|")}|Uvd6Mj7rDI");
    payUData.hash = await _channel.invokeMethod("hashIt",
        "${payUData.merchantKey}|${payUData.txnId}|${payUData.amount}|${payUData.productName}|${payUData.firstName}|${payUData.email}|${createUDF.join("|")}|Uvd6Mj7rDI");
    print("Hash:: ${payUData.hash}");
    var result = await _channel.invokeMethod('pay', payUData.toJson());
    print("result :: $result");
    if (result != null)
      successResponse(PayUData.fromJson(json.decode(result)));
    else
      failureResponse(result);
  }
}

///isConsentPayment=0&mihpayid=9084075383&mode=CC&status=success&unmappedstatus=captured&key=OlVevRfJ&
///txnid=adawohdenwdjas&amount=125.00&addedon=2020-11-22+01%3A45%3A27&productinfo=sdklashd&firstname=Dithesh&
///lastname=&address1=&address2=&city=&state=&country=&zipcode=&email=test%40gmail.com&phone=7012587943&udf1=&udf2=&
///udf3=&udf4=&udf5=&udf6=&udf7=&udf8=&udf9=&udf10=&hash=1951dc2514ac4d7beeffa086d940644c6016b49f681ab8c437fd405204c85fc29bf3195d0a190ff23f3492e732cfca4b1b9979fc4f4f61fc57f561f30aaf4a2e&
///field1=055662243412&field2=084334&field3=993176739697725&field4=MFJlVVZHWGpibUhmUE8ySEJPNmk%3D&field5=02&field6=
///&field7=AUTHPOSITIVE&field8=&field9=&giftCardIssued=true&PG_TYPE=HDFCPG&encryptedPaymentId=70A559BEDA67B2CE0F62D061A824716D
///&bank_ref_num=993176739697725&bankcode=MAST&error=E000&error_Message=No+Error&name_on_card=payu&cardnum=512345XXXXXX2346&
///cardhash=This+field+is+no+longer+supported+in+postback+params.&amount_split=%7B%22PAYU%22%3A%22125.00%22%7D&
///payuMoneyId=250656372&discount=0.00&net_amount_debit=125

///isConsentPayment=0&mihpayid=9084076989&mode=CC&status=success&unmappedstatus=captured&key=OlVevRfJ&txnid=adawohdenwdjas
///&amount=125.00&addedon=2020-11-24+09%3A01%3A04&productinfo=sdklashd&firstname=Dithesh&lastname=&address1=&address2=
///&city=&state=&country=&zipcode=&email=test%40gmail.com&phone=7012587943&udf1=vava1&udf2=vava2&udf3=vava3&udf4=vava4
///&udf5=vava5&udf6=&udf7=&udf8=&udf9=&udf10=&hash=0da28c3b563570c0f90e7855ab4b7b667a2419581f5ee92126c87f56a9ece45e2f28bd843257dcfe28c0585bd9ddd481be0f6ce017a18d295b6854bdf1e88217
///&field1=075691456561&field2=413397&field3=843275127173849&field4=S2RMb0JSbFd2TFN6b25PeVBsdWg%3D&field5=02&field6=
///&field7=AUTHPOSITIVE&field8=&field9=&giftCardIssued=true&PG_TYPE=HDFCPG&encryptedPaymentId=44A5B160ACA8CB8AE00FF545956A32CA&bank_ref_num=843275127173849
///&bankcode=MAST&error=E000&error_Message=No+Error&name_on_card=payu&cardnum=512345XXXXXX2346
///&cardhash=This+field+is+no+longer+supported+in+postback+params.&amount_split=%7B%22PAYU%22%3A%22125.00%22%7D
///&payuMoneyId=250659054&discount=0.00&net_amount_debit=125
