import 'package:flutter/material.dart';
import 'package:gpssender/model/login_model.dart';
import 'package:gpssender/model/login_response_model.dart';
import 'package:gpssender/ui/home_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  var username = "";
  var pwd = "";

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();

    _usernameController = TextEditingController(text: username);
    _passwordController = TextEditingController(text: pwd);

    if (isAlreadyLogin()) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    }
  }

  Future<void> checkLocationPermission() async {
    var status = await Permission.locationAlways.status;
    if (status.isDenied) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        if (await Permission.locationAlways.request().isGranted) {
          print("granted");
        } else {
          checkLocationPermission();
        }
      } else {
        showLocationPermissionPopUp();
      }
    } else if (status.isGranted) {
      if (await Permission.locationAlways.request().isGranted) {
        print("granted");
      }
    } else if (status.isPermanentlyDenied) {
      showLocationPermissionPopUp();
    }
  }

  void showLocationPermissionPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lokasyon izni'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Uygulama kullanılabilmesi için daima konum izni gerekmektedir.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                clickedPopUpOk();
              },
            ),
          ],
        );
      },
    );
  }

  void clickedPopUpOk() async {
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      openAppSettings().then((_) {
        checkPermissionAfterSettings();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void checkPermissionAfterSettings() async {
    var status = await Permission.locationAlways.status;
    if (status.isGranted) {
      Navigator.of(context).pop();
      print("Lokasyon izni granted");
    } else {
      print("Lokasyon izni hala denied");
    }
  }

  void loginPressed(BuildContext context, LoginModel loginModel) {
    loginModel.login().then(
          (value) => {
            if (value.success)
              loginSuccess(context, value)
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Credentials')),
                )
              }
          },
        );
  }

  Future<void> loginSuccess(
      BuildContext context, LoginResponse loginResponse) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successful')),
    );
    saveLoginModel(loginResponse);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void saveLoginModel(LoginResponse loginResponse) {
    var userBox = Hive.box<LoginResponse>('user');
    userBox.put('driver', loginResponse);
  }

  bool isAlreadyLogin() {
    var user = Hive.box<LoginResponse>('user');
    var lrm = user.get('driver');
    return lrm != null;
  }

  @override
  Widget build(BuildContext context) {
    final loginModel = Provider.of<LoginModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                'Hoşgeldiniz',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Lütfen giriş yapın',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.person, color: Colors.blueAccent),
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => loginModel.setUsername(value),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                onChanged: (value) => loginModel.setPassword(value),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                ),
                onPressed: () => loginPressed(context, loginModel),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
