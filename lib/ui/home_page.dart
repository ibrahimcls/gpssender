import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpssender/services/background_service.dart';

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
      await initializeService();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: CupertinoSwitch(
          value: _switchValue,
          onChanged: switched,
        ),
      ),
    );
  }
}
