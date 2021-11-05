import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:router_management/router_management.dart';

import 'ui/home_screen.dart';
import 'ui/not_found.dart';
import 'ui/profile_screen.dart';
import 'ui/splash_screen.dart';

void main() {
  runApp(
    NavigationRouter(
      child: App(), // The NavigationWidgetMixin that builds a Router
      pages: [
        NavigationPage(
          path: SplashScreen.path,
          builder: () => const SplashScreen(),
          name: SplashScreen.name,
        ),
        NavigationPage(
          path: HomeScreen.path,
          builder: () => const HomeScreen(),
          name: HomeScreen.name,
        ),
        NavigationPage(
          path: ProfileScreen.path,
          builder: () => NavigationRouterGuard(
            child: const ProfileScreen(),
            validation: (args) async {
              if (args.query['name'] == null) return false;

              return true;
            },
          ),
          name: ProfileScreen.name,
        ),
      ], // The pages
      // The initial page's path. Defaults to "/"
      initialPage: SplashScreen.path,
      unknownPage: NavigationPage(
        path: NotFound.path,
        builder: () => const NotFound(),
        name: NotFound.name,
      ), // A page that is built when an unknown path is passed
    ),
  );
}

class App extends StatelessWidget with NavigationWidgetMixin {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      title: 'Router Management Example',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}

// or

// class App extends StatefulWidget with NavigationWidgetMixin {
//   App({Key? key}) : super(key: key);
//
//   @override
//   _AppState createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routeInformationParser: widget.routeInformationParser,
//       routerDelegate: widget.routerDelegate,
//       title: 'Router Management Example',
//       localizationsDelegates: GlobalMaterialLocalizations.delegates,
//     );
//   }
// }
