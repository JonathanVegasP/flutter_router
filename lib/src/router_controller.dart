import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:router_management/src/route_settings.dart';

class RouterController {
  final _routes = <RouterSettings>[];

  void addRoute(
    String name,
    WidgetBuilder builder, {
    bool useNativeTransitions: true,
    RouteTransitionsBuilder transitionsBuilder,
    Duration transitionDuration: const Duration(milliseconds: 250),
    bool fullscreenDialog: false,
  }) {
    _routes.add(
      RouterSettings(
        name: name,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
        transitionsBuilder: transitionsBuilder,
      ),
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    for (var route in _routes) {
      if (settings.name == route.name) {
        return kIsWeb || !route.useNativeTransitions
            ? PageRouteBuilder(
                pageBuilder: (context, _, __) => route.builder(context),
                transitionsBuilder: route.transitionsBuilder ??
                    (_, animation, secondaryAnimation, child) =>
                        animation.isCompleted
                            ? child
                            : SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset.zero,
                                  end: const Offset(-1.0 / 3.0, 0.0),
                                ).animate(secondaryAnimation),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.black54,
                                            spreadRadius: 2.0,
                                            blurRadius: 4.0,
                                          )
                                        ],
                                      ),
                                      child: child,
                                    ),
                                  ),
                                ),
                              ),
                settings: settings,
                transitionDuration: route.transitionDuration,
                fullscreenDialog: route.fullscreenDialog,
              )
            : Platform.isIOS
                ? CupertinoPageRoute(
                    title: route.name.replaceFirst('/', '').toUpperCase(),
                    builder: route.builder,
                    fullscreenDialog: route.fullscreenDialog,
                    settings: settings,
                  )
                : MaterialPageRoute(
                    builder: route.builder,
                    settings: settings,
                    fullscreenDialog: route.fullscreenDialog,
                  );
      }
    }
  }
}
