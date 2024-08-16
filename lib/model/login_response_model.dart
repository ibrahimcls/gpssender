import 'package:gpssender/model/user_model.dart';
import 'package:hive_flutter/adapters.dart';

@HiveType(typeId: 1)
class LoginResponse {
  @HiveField(0)
  final User? user;
  @HiveField(1)
  final String? token;
  @HiveField(2)
  final bool success;
  @HiveField(3)
  final String? message;

  LoginResponse({
    this.user,
    this.token,
    required this.success,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: json['data'] != null ? User.fromJson(json['data']['item1']) : null,
      token: json['data'] != null ? json['data']['item2'] : null,
      success: json['success'],
      message: json['message'],
    );
  }
}
