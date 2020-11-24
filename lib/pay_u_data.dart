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
    udf,
  }) : this.udf = udf == null ? List<String>.generate(10, (index) => "") : udf;

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

  ///maximum 10 udf
  List<String> udf;

  factory PayUData.fromJson(Map<String, dynamic> json) => PayUData(
        merchantKey: json["merchantKey"] == null ? null : json["merchantKey"],
        merchantId: json["merchantId"] == null ? null : json["merchantId"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        txnId: json["txnId"] == null ? null : json["txnId"],
        productName: json["productName"] == null ? null : json["productName"],
        amount: json["amount"] == null ? null : json["amount"],
        hash: json["hash"] == null ? null : json["hash"],
        salt: json["salt"] == null ? null : json["salt"],
        udf: json["udf"] == null
            ? List<String>.generate(10, (index) => "")
            : List<String>.from(json["udf"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "merchantKey": merchantKey == null ? null : merchantKey,
        "merchantId": merchantId == null ? null : merchantId,
        "firstName": firstName == null ? null : firstName,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "txnId": txnId == null ? null : txnId,
        "productName": productName == null ? null : productName,
        "amount": amount == null ? null : amount,
        "hash": hash == null ? null : hash,
        "salt": salt == null ? null : salt,
        "udf": udf == null ? null : List<dynamic>.from(udf.map((x) => x)),
      };

  @override
  String toString() {
    return 'PayUData{amount: $amount, txnId: $txnId, phone: $phone, merchantKey: $merchantKey, merchantId: $merchantId, '
        'productName: $productName, firstName: $firstName, email: $email, hash: $hash, salt: $salt, udf: $udf}';
  }
}
