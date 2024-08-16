import 'package:flutter/material.dart';
import 'package:gpssender/services/api_service.dart';
import 'package:gpssender/model/login_response_model.dart';

class LoginModel with ChangeNotifier {
  String _username = '';
  String _password = '';

  String get username => _username;
  String get password => _password;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<LoginResponse> login() async {
    ApiService authService = ApiService();
    return authService.login(username, password);
  }
}
