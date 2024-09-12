import 'package:geolocator/geolocator.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void callback() async {
  await _determinePosition().then((position) => insertPosition(position));
}

insertPosition(Position position) {
  print('long: ${position.longitude} lat: ${position.latitude}');
  var token = getToken();
  var activeTracking = getActiveTracking();
  ApiService apiService = ApiService();
  apiService
      .insertTracking(
          token!, activeTracking!.id, position.longitude, position.latitude)
      .then((response) {
    print(
        'i-test insert response : ${response.success} message: ${response.message}');
  });
}

ActiveTracking? getActiveTracking() {
  var activeTracking = Hive.box<ActiveTracking>('at');
  return activeTracking.get('active');
}

String? getToken() {
  var user = Hive.box<LoginResponse>('user');
  var lrm = user.get('driver');
  return lrm?.token;
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
