import 'package:flutter/widgets.dart';

mixin NavigationWidgetMixin on Widget {
  late final RouteInformationProvider routeInformationProvider;
  late final RouteInformationParser<Object> routeInformationParser;
  late final RouterDelegate<Object> routerDelegate;
}
