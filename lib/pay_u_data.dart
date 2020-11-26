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
    udf,
  }) : udf = udf ?? List<String>.generate(10, (index) => '');

  String amount;
  String txnId;
  String phone;
  String merchantKey;
  String merchantId;
  String productName;
  String firstName;
  String email;
  String hash;
  String salt;
  String sUrl;
  String fUrl;

  ///maximum 10 udf
  List<String> udf;

  factory PayUData.fromJson(Map<String, dynamic> json) => PayUData(
        merchantKey: json['merchantKey'],
        merchantId: json['merchantId'],
        firstName: json['firstName'],
        email: json['email'],
        phone: json['phone'],
        txnId: json['txnId'],
        productName: json['productName'],
        amount: json['amount'],
        hash: json['hash'],
        salt: json['salt'],
        sUrl: json['sUrl'],
        fUrl: json['fUrl'],
        udf: json['udf'] == null
            ? List<String>.generate(10, (index) => '')
            : List<String>.from(json['udf'].map((x) => x)),
      );

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
