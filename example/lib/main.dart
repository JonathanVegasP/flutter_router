import 'package:example/page_validators/profile_validator.dart';
import 'package:example/ui/home_screen.dart';
import 'package:example/ui/not_found.dart';
import 'package:example/ui/profile_screen.dart';
import 'package:example/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:router_management/router_management.dart';

void main() {
  runApp(NavigationRouter(
    child: const App(), // The PageWidget that builds a Router
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
        builder: () => const ProfileScreen(),
        name: ProfileScreen.name,
        validators: const [ProfileValidator()],
      )
    ], // The pages
    initialPage: SplashScreen.path, // The initial page's path. Defaults to "/"
    unknownPage: NavigationPage(
      path: NotFound.path,
      builder: () => const NotFound(),
      name: NotFound.name,
    ), // A page that is built when an unknown path is passed
  ));
}

class App extends PageWidget {
  const App();

  @override
  void onInit(BuildContext context) {
    print('onInit');
    super.onInit(context);
  }

  @override
  void onChangedDependencies(BuildContext context) {
    print('onChangedDependencies');
    super.onChangedDependencies(context);
  }

  @override
  void onDeactivate(BuildContext context) {
    print('onDeactivate');
    super.onDeactivate(context);
  }

  @override
  void onDispose(BuildContext context) {
    print('onDispose');
    super.onDispose(context);
  }

  @override
  Widget build(
      BuildContext context,
      RouteInformationParser<Object> routeInformationParser,
      RouterDelegate<Object> routerDelegate) {
    return MaterialApp.router(
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      title: 'Router Management Example',
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }
}
