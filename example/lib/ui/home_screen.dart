import 'package:flutter/material.dart';
import 'package:router_management/router_management.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Declare the path as constant
  static const path = '/home/:name';

  // Declare the name as constant
  static const name = 'Home';

  @override
  Widget build(BuildContext context) {
    final arguments = context.arguments;

    return Scaffold(
      body: Center(
        child: Hero(
          tag: const Object(),
          child: Text(
            'Welcome ${arguments.params['name']}',
            style: const TextStyle(fontSize: 32, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
