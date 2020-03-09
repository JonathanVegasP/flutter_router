# Flutter Router

A plugin that generate defined routes.

# Instructions

## Define your AppRoutes class

```dart
import 'package:flutter/material.dart';
import 'package:flutter_router/flutter_router.dart';

class AppRoutes {
  AppRoutes._();

  //Object that controls routes
  static final router = Router();

  //variables that contains the name of yours screens
  static const intro = '/';

  static const home = '/home';

  //function that allow flutter generate defined routes.
  static void setRoutes() {
    //Define the route with this function
    router.define(
    //define the name of your screen
      intro,
     //define the screen like a widget
      new IntroScreen(),
      //define the app initial screen
      initialRoute: true,
      //use another transition than native
      nativeTransition: false,
      //define your custom transition (in android it has already a default custom transition, but if you don't define this the iOS platform will be native)
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      //define a custom transition duration
      transitionDuration: const Duration(milliseconds: 300),
      //define if the screen will be a fullscreenDialog
      dialog: false,
    );
    router.define(
      home,
      HomeScreen(),
      nativeTransition: false,
    );
  }
}
```

## Define the generator to flutter generate the routes

```dart
import 'package:brydge/configuration/routes.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    //initialize the routes
    AppRoutes.setRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'title',
      //put the generator into a material app
      onGenerateRoute: AppRoutes.router.generator,
    );
  }
}

void main() => runApp(App());
```

## Navigation between screens

```dart
 //Navigate to your named screen with params
    Map<String,dynamic> params = <String,dynamic>{};
    Navigator.pushNamed(context, AppRoutes.home, arguments: params);
    Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: params);

    //Get params in the build
     @override
      Widget build(BuildContext context) {
        final Map<String,dynamic> params = ModalRoute.of(context).settings.arguments;
        return Container(
          color: Colors.blue,
        );
      }

      //Get params in the didChangeDependencies
      @override
        void didChangeDependencies() {
          final Map<String,dynamic> params = ModalRoute.of(context).settings.arguments;
          super.didChangeDependencies();
        }
```