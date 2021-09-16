import 'dart:async';

import 'package:flutter/material.dart';
import 'package:router_management/router_management.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const path = '/';

  static const name = 'Splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      context.navigator.pushReplacement('/home/John Doe');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ColoredBox(
        color: Colors.blue,
        child: Center(
          child: Text(
            'Hello World',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}
