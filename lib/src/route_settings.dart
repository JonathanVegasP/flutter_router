import 'package:flutter/widgets.dart';

class RouterSettings {
  final String name;
  final WidgetBuilder builder;
  final bool useNativeTransitions;
  final bool fullscreenDialog;
  final Duration transitionDuration;
  final RouteTransitionsBuilder transitionsBuilder;

  RouterSettings({
    this.name,
    this.builder,
    this.useNativeTransitions: true,
    this.fullscreenDialog: false,
    this.transitionDuration: const Duration(milliseconds: 250),
    this.transitionsBuilder,
  });
}
