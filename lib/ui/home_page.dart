import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/services/api_service.dart';
import 'package:gpssender/services/background_service.dart';
import 'package:gpssender/ui/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _switchValue = false;
  String activeTrackingText = "";
  Location location = Location();
  bool? _serviceEnabled;

  @override
  void initState() {
    super.initState();
    checkIsOnTrip();
  }

  void checkIsOnTrip() {
    ActiveTracking? activeTracking = getActiveTracking();
    if (activeTracking != null) {
      setState(() {
        activeTrackingText = activeTracking.getText();
        _switchValue = true;
      });
    }
  }

  void switched(bool value) async {
    if (value) {
      checkLocationService().then((value) => {locationServiceResponse(value)});
    } else {
      final service = FlutterBackgroundService();
      service.invoke("stop");
      setState(() {
        _switchValue = false;
        activeTrackingText = "";
        deleteActiveTracking();
      });
    }
  }

  void locationServiceResponse(bool value) {
    if (value) {
      setState(() {
        _switchValue = value;
      });
      checkActiveTracking();
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
        setState(() {
          activeTrackingText = value.activeTracking!.getText();
        });
        saveActiveTracking(value.activeTracking!);
        initializeService(getToken()!, value.activeTracking!);
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

  String? getToken() {
    var user = Hive.box<LoginResponse>('user');
    var lrm = user.get('driver');
    return lrm?.token;
  }

  ActiveTracking? getActiveTracking() {
    var atBox = Hive.box<ActiveTracking>('at');
    var at = atBox.get('active');
    return at;
  }

  void saveActiveTracking(ActiveTracking active) {
    var activeTracking = Hive.box<ActiveTracking>('at');
    activeTracking.put('active', active);
  }

  void deleteActiveTracking() {
    var activeTracking = Hive.box<ActiveTracking>('at');
    activeTracking.delete('active');
  }

  Future<bool> checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      showLocationDisabledWarning();
      return false;
    } else {
      print('Konum servisi açık.');
      return true;
    }
  }

  void showLocationDisabledWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konum Servisi Kapalı'),
          content: Text('Konum servisiniz kapalı. Lütfen açın.'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  logout();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ];
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activeTrackingText.isEmpty
                      ? 'No Active Tracking'
                      : activeTrackingText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color:
                        activeTrackingText.isEmpty ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: switched,
                  activeColor: Colors.blueAccent,
                  trackColor: Colors.grey,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => switched(!_switchValue),
                  icon: Icon(_switchValue ? Icons.stop : Icons.play_arrow),
                  label: Text(_switchValue ? 'Stop Service' : 'Start Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _switchValue ? Colors.redAccent : Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logout() {
    var userBox = Hive.box<LoginResponse>('user');
    userBox.delete('driver');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
