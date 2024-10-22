import 'package:geolocator/geolocator.dart';

class PositionModel {
  final String date;
  final Position position;

  PositionModel({required this.date, required this.position});
}
