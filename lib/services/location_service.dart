import 'package:geolocator/geolocator.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/model/position_model.dart';
import 'package:gpssender/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

List<PositionModel> positionList = [];

void callback(String token, ActiveTracking activeTracking) async {
  String date = DateTime.now().toIso8601String();
  await _determinePosition().then((position) =>
      positionList.add(PositionModel(date: date, position: position)));

  if (positionList.length >= 30) {
    insertPosition(token, activeTracking, positionList);
    positionList.clear();
  }
}

insertPosition(
    String token, ActiveTracking at, List<PositionModel> positionList) {
  ApiService apiService = ApiService();
  apiService.insertTracking1(token, at.id, positionList).then((response) {
    print(
        'i-test insert response : ${response.success} message: ${response.message}');
  });
}

ActiveTracking? getActiveTracking() {
  var activeTracking = Hive.box<ActiveTracking>('at');
  return activeTracking.get('active');
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
