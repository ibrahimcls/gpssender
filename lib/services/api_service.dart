import 'dart:convert';
import 'package:gpssender/model/active_tracking_response.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/model/position_model.dart';
import 'package:gpssender/model/response_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.mutasportal.com';
  final String _loginEP = '/Driver/Login';
  final String _getActiveTrackingEP = '/Tracking/GetActiveTracking';
  final String _trackingLogEP = '/TrackingLog/Insert';

  Future<LoginResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_loginEP'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);
    return LoginResponse.fromJson(responseBody);
  }

  Future<ActiveTrackingResponse> getActiveTracking(
      String token, int driverId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_getActiveTrackingEP')
          .replace(queryParameters: {'driverId': driverId.toString()}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    final responseBody = jsonDecode(response.body);
    return ActiveTrackingResponse.fromJson(responseBody);
  }

  Future<ResponseModel> insertTracking(
      String token, int trackingId, double long, double lat) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_trackingLogEP'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode({'trackingId': trackingId, 'lat': lat, 'long': long}),
    );

    final responseBody = jsonDecode(response.body);
    return ResponseModel.fromJson(responseBody);
  }

  Future<ResponseModel> insertTracking1(
      String token, int trackingId, List<PositionModel> locs) async {
    List<Map<String, String>> locations = locs.map((positionModel) {
      return {
        "trackingId": trackingId.toString(),
        "loc":
            "${positionModel.position.latitude},${positionModel.position.longitude}",
        "dateTime": positionModel.date,
      };
    }).toList();
    final response = await http.post(
      Uri.parse('$_baseUrl$_trackingLogEP'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(locations),
    );
    final responseBody = jsonDecode(response.body);
    return ResponseModel.fromJson(responseBody);
  }
}
