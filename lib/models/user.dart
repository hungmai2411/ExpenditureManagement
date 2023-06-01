// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

const defaultAvatar =
    "https://firebasestorage.googleapis.com/v0/b/spending-management-c955a.appspot.com/o/FVK7wz5aIAA25l8.jpg?alt=media&token=ddceb8f7-7cf7-4c42-a806-5d0d48ce58f5";

class User {
  final String email;
  final String password;
  final String name;
  final String birthday;
  String avatar;
  bool gender;
  int money;
  int? id;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.birthday,
    this.avatar = defaultAvatar,
    this.gender = true,
    this.money = 0,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'name': name,
      'dateOfBirth': birthday,
      //'avatar': avatar,
      'gender': gender,
      //'money': money,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      birthday: map['dateOfBirth'] as String,
      avatar: map['avatar'] ?? defaultAvatar,
      gender: map['gender'] as bool,
      money: map['money'] ?? 0,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? email,
    String? password,
    String? name,
    String? birthday,
    String? avatar,
    bool? gender,
    int? money,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      money: money ?? this.money,
    );
  }
}
