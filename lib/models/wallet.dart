import 'dart:convert';

class Wallet {
  int? userId;
  String? Name;
  String? currencyUnit;
  String? money;

  Wallet({
    this.userId,
    this.Name,
    this.currencyUnit,
    this.money,
  });
  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      userId: map['userId'] != null ? map['userId'] as int : null,
      Name: map['Name'] != null ? map['Name'] as String : null,
      currencyUnit:
          map['currencyUnit'] != null ? map['currencyUnit'] as String : null,
      money: map['money'] != null ? map['money'] as String : null,
    );
  }
}
