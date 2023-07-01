// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Spending {
  int? walletId;
  int? typeId;
  int? moneySpend;
  String? timeSpend;
  String? note;
  String? location;
  String? image;
  List<int>? listFriendId;
  String? type;
  String? imageType;
  int? id;

  Spending({
    this.walletId,
    this.typeId,
    this.moneySpend,
    this.timeSpend,
    this.note,
    this.location,
    this.image,
    this.listFriendId,
    this.type,
    this.imageType,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'waletId': walletId,
      'typeId': typeId,
      'moneySpend': moneySpend,
      'timeSpend': timeSpend,
      'note': note,
      'location': location,
      'image': image,
      'listFriendId': listFriendId,
    };
  }

  factory Spending.fromMap(Map<String, dynamic> map) {
    return Spending(
      walletId: map['waletId'] != null ? map['waletId'] as int : null,
      typeId: map['typeId'] != null ? map['typeId'] as int : null,
      moneySpend: map['moneySpend'] != null ? map['moneySpend'] as int : null,
      timeSpend: map['timeSpend'] != null ? map['timeSpend'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      listFriendId: map['listFriendId'] != null
          ? List<int>.from((map['listFriendId'] as List<int>))
          : null,
      type: map['type']['name'] ?? '',
      imageType: map['type']['image'] ?? '',
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Spending.fromJson(String source) =>
      Spending.fromMap(json.decode(source) as Map<String, dynamic>);
}
