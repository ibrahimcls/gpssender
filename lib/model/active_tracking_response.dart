import 'package:gpssender/model/active_tracking.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'active_tracking_response.g.dart';

@HiveType(typeId: 3)
class ActiveTrackingResponse extends HiveObject {
  @HiveField(0)
  final bool success;
  @HiveField(1)
  final String? message;
  @HiveField(2)
  final ActiveTracking? activeTracking;

  ActiveTrackingResponse(
      {required this.success, required this.message, this.activeTracking});

  factory ActiveTrackingResponse.fromJson(Map<String, dynamic> json) {
    return ActiveTrackingResponse(
      activeTracking:
          json['data'] != null ? ActiveTracking.fromJson(json['data']) : null,
      success: json['success'],
      message: json['message'],
    );
  }
}
