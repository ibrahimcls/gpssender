import 'package:hive_flutter/hive_flutter.dart';

part 'driver_model.g.dart';

@HiveType(typeId: 2)
class Driver {
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
  @HiveField(5)
  final String systemRole;

  Driver(
      {required this.id,
      required this.nameSurname,
      required this.username,
      required this.phoneNumber,
      required this.email,
      required this.systemRole});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nameSurname: json['nameSurname'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      systemRole: 'systemRole',
    );
  }
}
