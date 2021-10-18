import 'package:flutter/widgets.dart';

class NavigationParser extends RouteInformationParser<String> {
  const NavigationParser();

  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    return routeInformation.location!;
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    return RouteInformation(location: configuration);
  }
}
