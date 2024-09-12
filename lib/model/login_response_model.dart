import 'package:gpssender/model/driver_model.dart';
import 'package:hive_flutter/adapters.dart';

part 'login_response_model.g.dart';

@HiveType(typeId: 1)
class LoginResponse extends HiveObject {
  @HiveField(0)
  final Driver? driver;
  @HiveField(1)
  final String? token;
  @HiveField(2)
  final bool success;
  @HiveField(3)
  final String? message;

  LoginResponse({
    required this.driver,
    required this.token,
    required this.success,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      driver:
          json['data'] != null ? Driver.fromJson(json['data']['item1']) : null,
      token: json['data'] != null ? json['data']['item2'] : null,
      success: json['success'],
      message: json['message'],
    );
  }
}
