import 'dart:convert';
import 'package:gpssender/model/login_response_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.mutasportal.com';
  final String _loginEP = '/User/Login';

  Future<LoginResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_loginEP'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return LoginResponse.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to connect to the server. Status code: ${response.statusCode}');
    }
  }
}
