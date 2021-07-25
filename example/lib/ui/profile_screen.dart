import 'package:flutter/material.dart';
import 'package:router_management/router_management.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const path = '/profile';

  static const name = 'Profile';

  @override
  Widget build(BuildContext context) {
    final arguments = context.arguments;

    return Scaffold(
      body: Center(
        child: Text('Hello, ${arguments.query['name']!}'),
      ),
    );
  }
}
