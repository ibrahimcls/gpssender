import 'package:flutter/material.dart';
import 'package:gpssender/model/active_tracking.dart';
import 'package:gpssender/model/active_tracking_response.dart';
import 'package:gpssender/model/login_model.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/model/driver_model.dart';
import 'package:gpssender/ui/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.initFlutter();
  Hive.registerAdapter(LoginResponseAdapter());
  Hive.registerAdapter(ActiveTrackingAdapter());
  Hive.registerAdapter(ActiveTrackingResponseAdapter());
  Hive.registerAdapter(DriverAdapter());
  await Hive.openBox<LoginResponse>('user');
  await Hive.openBox<ActiveTracking>('at');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
