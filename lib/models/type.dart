import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SpendingType {
  int? id;
  final String image;
  final String name;
  SpendingType({
    this.id,
    required this.image,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'name': name,
    };
  }

  factory SpendingType.fromMap(Map<String, dynamic> map) {
    return SpendingType(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpendingType.fromJson(String source) =>
      SpendingType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Type(id: $id, image: $image, name: $name)';
}
