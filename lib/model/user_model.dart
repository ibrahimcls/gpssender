import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class User {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String nameSurname;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String phoneNumber;
  @HiveField(4)
  final String email;

  User({
    required this.id,
    required this.nameSurname,
    required this.username,
    required this.phoneNumber,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nameSurname: json['nameSurname'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}
