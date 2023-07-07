class Wallet {
  final int id;
  final String name;
  final String currencyUnit;
  final int money;

  Wallet({
    required this.id,
    required this.name,
    required this.currencyUnit,
    required this.money,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      name: json['name'],
      currencyUnit: json['currencyUnit'],
      money: json['money'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currencyUnit': currencyUnit,
      'money': money,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currencyUnit': currencyUnit,
      'money': money,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'],
      name: map['name'],
      currencyUnit: map['currencyUnit'],
      money: map['money'],
    );
  }
}
