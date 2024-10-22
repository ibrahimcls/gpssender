import 'package:hive_flutter/hive_flutter.dart';

part 'active_tracking.g.dart';

@HiveType(typeId: 4)
class ActiveTracking {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String startDate;
  @HiveField(4)
  final String finishDate;

  ActiveTracking(
      {required this.id,
      required this.title,
      required this.description,
      required this.startDate,
      required this.finishDate});

  factory ActiveTracking.fromJson(Map<String, dynamic> json) {
    return ActiveTracking(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        startDate: json['startDate'],
        finishDate: json['finishDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'finishDate': finishDate,
    };
  }

  String getText() {
    return '$title\n$description\nbaşlangıç tarihi: $startDate\nbitiş tarihi: $finishDate\n';
  }
}
