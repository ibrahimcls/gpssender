import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/services/location_service.dart';

const notificationChannelId = 'my_foreground';
const notificationId = 888;

Future<void> initializeService(
    String token, ActiveTracking activeTracking) async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'GPS takip',
      initialNotificationContent: 'Keyifli Yolculukklar',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
  service.invoke(
      'start', {'activeTracking': activeTracking.toJson(), 'token': token});
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  service.on('start').listen((event) {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      ActiveTracking? activeTracking =
          ActiveTracking.fromJson(event?['activeTracking']);
      String token = event?['token'];
      callback(token, activeTracking);
    });
  });
  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  service.on('task').listen((event) {
    //callback();
  });
  Timer.periodic(const Duration(seconds: 50), (timer) {
    service.invoke('task');
  });
  return true;
}
