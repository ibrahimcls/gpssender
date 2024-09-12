import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/services/api_service.dart';
import 'package:gpssender/services/background_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _switchValue = false;

  void switched(bool value) async {
    setState(() {
      _switchValue = value;
    });

    if (value) {
      checkActiveTracking();
    } else {
      final service = FlutterBackgroundService();
      service.invoke("stop");
    }
  }

  void checkActiveTracking() {
    var userBox = Hive.box<LoginResponse>('user');
    var loginResponse = userBox.get('driver');

    ApiService apiService = ApiService();
    apiService
        .getActiveTracking(loginResponse!.token!, loginResponse.driver!.id)
        .then((value) {
      if (value.activeTracking != null) {
        saveActiveTracking(value.activeTracking!);
        initializeService();
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('There is no tracking Id')),
          );
          _switchValue = false;
        });
      }
    });
  }

  void saveActiveTracking(ActiveTracking active) {
    var activeTracking = Hive.box<ActiveTracking>('at');
    activeTracking.put('active', active);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: null,
        ),
        body: Center(
          child: CupertinoSwitch(
            value: _switchValue,
            onChanged: switched,
          ),
        ),
      ),
    );
  }
}
