import 'package:flutter/widgets.dart';
import 'package:router_management/src/models/page_arguments.dart';

class NavigationParser extends RouteInformationParser<PageArguments> {
  const NavigationParser();

  @override
  Future<PageArguments> parseRouteInformation(
      RouteInformation routeInformation) async {
    return PageArguments(Uri.parse(routeInformation.location!));
  }

  @override
  RouteInformation? restoreRouteInformation(PageArguments configuration) {
    return RouteInformation(location: configuration.completePath);
  }
}
