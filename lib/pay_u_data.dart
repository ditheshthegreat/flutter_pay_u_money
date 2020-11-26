import 'package:flutter/material.dart';

class PayUData {
  PayUData({
    @required this.merchantKey,
    @required this.merchantId,
    @required this.salt,
    this.txnId,
    this.firstName,
    this.email,
    this.phone,
    this.productName,
    this.amount,
    this.hash,
    this.sUrl,
    this.fUrl,
    List<String> udf,
  }) : udf = udf ?? List<String>.generate(10, (index) => '');

  /// [merchantId], [merchantKey] and [salt] will only get when registered in payUmoney
  /// [payu.in](https://www.payu.in/)
  ///
  /// Give merchantId from payumoney.
  String merchantId;

  /// Give merchantKey from payumoney.
  String merchantKey;

  ///There is no need of specific txnId you can provide custom alphanumeric.
  String txnId;

  ///Provide customer name.
  String firstName;

  ///Provide customer email.
  String email;

  ///Provide customer phone.
  String phone;

  ///Provide product name.
  String productName;

  ///Amount you want to pay.
  String amount;

  ///If you generate hash from server provide in this field. Otherwise keep it blank.
  ///
  /// For generating hash natively call.
  /// ```
  /// await flutterPayUMoney.hashIt();
  /// ```
  String hash;

  /// Give salt from payumoney.
  String salt;

  /// success url optional.
  /// default url is [https://www.payumoney.com/mobileapp/payumoney/success.php](https://www.payumoney.com/mobileapp/payumoney/success.php)
  String sUrl;

  /// failure url optional.
  /// default url is [https://www.payumoney.com/mobileapp/payumoney/failure.php](https://www.payumoney.com/mobileapp/payumoney/failure.php)
  String fUrl;

  ///User can add extra field to pass from your app to your server. If nothing leave it blank.
  ///maximum 10 udf
  List<String> udf;

  ///Convert Object to Map
  Map<String, dynamic> toJson() => {
        'merchantKey': merchantKey,
        'merchantId': merchantId,
        'firstName': firstName,
        'email': email,
        'phone': phone,
        'txnId': txnId,
        'productName': productName,
        'amount': amount,
        'hash': hash,
        'salt': salt,
        'sUrl': sUrl,
        'fUrl': fUrl,
        'udf': udf == null ? null : List<dynamic>.from(udf.map((x) => x)),
      };

  @override
  String toString() {
    return 'PayUData{amount: $amount, txnId: $txnId, phone: $phone, merchantKey: $merchantKey, merchantId: $merchantId, '
        'productName: $productName, firstName: $firstName, email: $email, hash: $hash, salt: $salt, udf: $udf}';
  }
}
