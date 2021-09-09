import 'package:example/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:router_management/router_management.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const path = '${HomeScreen.path}/profile';

  static const name = 'Profile';

  @override
  Widget build(BuildContext context) {
    final arguments = context.arguments;

    return GestureDetector(
      onTap: () {
        context.navigator.pop();
      },
      child: Scaffold(
        body: Center(
          child: Text('Hello, ${arguments.query['name']}'),
        ),
      ),
    );
  }
}
