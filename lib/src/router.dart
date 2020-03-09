import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Router {
  final _routes = <Route>[];

  void define(
    String name,
    Widget screen, {
    bool dialog = false,
    bool initialRoute = false,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionsBuilder,
    bool nativeTransition = true,
  }) {
    final route = kIsWeb || !Platform.isIOS
        ? nativeTransition
            ? MaterialPageRoute(
                builder: (_) => screen,
                fullscreenDialog: dialog,
                settings: RouteSettings(
                  name: name,
                  isInitialRoute: initialRoute,
                ),
              )
            : PageRouteBuilder(
                pageBuilder: (_, __, ___) => screen,
                fullscreenDialog: dialog,
                settings: RouteSettings(
                  name: name,
                  isInitialRoute: initialRoute,
                ),
                transitionDuration: transitionDuration,
                transitionsBuilder: transitionsBuilder ??
                    (_, animation, __, child) => SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: const Offset(0.0, 0.0),
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        ),
              )
        : transitionsBuilder != null
            ? PageRouteBuilder(
                pageBuilder: (_, __, ___) => screen,
                fullscreenDialog: dialog,
                settings: RouteSettings(
                  name: name,
                  isInitialRoute: initialRoute,
                ),
                transitionDuration: transitionDuration,
                transitionsBuilder: transitionsBuilder,
              )
            : CupertinoPageRoute(
                builder: (_) => screen,
                title: name,
                settings: RouteSettings(
                  name: name,
                  isInitialRoute: initialRoute,
                ),
                fullscreenDialog: dialog,
              );

    _routes.add(route);
  }

  Route generator(RouteSettings routeSettings) {
    for (var route in _routes) {
      if (routeSettings.name == route.settings.name) {
        return route;
      } else
        continue;
    }
  }
}
