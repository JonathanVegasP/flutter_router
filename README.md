## Flutter Router
---
A Router Management

### Instructions

#### Define your Route Management class

```dart
class AppRoutes {
  AppRoutes._();

  //A controller to manage the app routes
  static final router = RouterController();

  //Variables that contains screen's name
  static const intro = '/';

  static const home = '/home';

  //Function that add routes to RouterController manage routes
  static void setRoutes() {
    //Create app routes
    router.addRoute(
      //Screen name
      intro,
      //WidgetBuilder
      (context) => IntroScreen(),
      //Define if the screen will be a fullscreenDialog (Default false)
      fullscreenDialog: false,
      //Define a custom transition duration. Native transitions won't be affected (Default 250 milliseconds)
      transitionDuration: const Duration(milliseconds: 300),
      //Define a custom transition. A custom transition only works if useNativeTransitions is false or the platform is Web (Default right to left with fade in)
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
      //Define if you want or don't want use native transitions (Default true)
      useNativeTransitions: !kIsWeb || Platform.isIOS,
    );
  }
}
```

#### Configure your MaterialApp

```dart
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    //initialize the routes
    AppRoutes.setRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Initialize the generator into a material app
      onGenerateRoute: AppRoutes.router.onGenerateRoute,
      //Define the app initial route
      initialRoute: AppRoutes.intro,
    );
  }
}

void main() => runApp(App());
```

#### Navigation between screens

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
  super.didChangeDependencies();
  final Map<String,dynamic> params = ModalRoute.of(context).settings.arguments;
}
```