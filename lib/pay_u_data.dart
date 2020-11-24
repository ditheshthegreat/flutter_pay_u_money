// To parse this JSON data, do
//
//     final testData = testDataFromJson(jsonString);

import 'dart:convert';

PayUData testDataFromJson(String str) => PayUData.fromJson(json.decode(str));

String testDataToJson(PayUData data) => json.encode(data.toJson());

class PayUData {
  PayUData({
    this.environment,
    this.amount,
    this.txnId,
    this.phone,
    this.merchantKey,
    this.merchantId,
    this.productName,
    this.firstName,
    this.email,
    this.hash,
    this.udfs,
  });

  bool environment;
  String amount;
  String txnId;
  String phone;
  String merchantKey;
  String merchantId;
  String productName;
  String firstName;
  String email;
  String hash;
  ///maximum 10 udf
  List<String> udfs;

  factory PayUData.fromJson(Map<String, dynamic> json) => PayUData(
        environment: json["environment"] == null ? null : json["environment"],
        merchantKey: json["merchantKey"] == null ? null : json["merchantKey"],
        merchantId: json["merchantId"] == null ? null : json["merchantId"],
        firstName: json["firstName"] == null ? null : json["firstName"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
        txnId: json["txnId"] == null ? null : json["txnId"],
        productName: json["productName"] == null ? null : json["productName"],
        amount: json["amount"] == null ? null : json["amount"],
        hash: json["hash"] == null ? null : json["hash"],
        udfs: json["udfs"] == null ? List<String>.generate(10, (index) => "|") : List<String>.from(json["udfs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "environment": environment == null ? null : environment,
        "merchantKey": merchantKey == null ? null : merchantKey,
        "merchantId": merchantId == null ? null : merchantId,
        "firstName": firstName == null ? null : firstName,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
        "txnId": txnId == null ? null : txnId,
        "productName": productName == null ? null : productName,
        "amount": amount == null ? null : amount,
        "hash": hash == null ? null : hash,
        "udfs": udfs == null ? null : List<dynamic>.from(udfs.map((x) => x)),
      };
}
