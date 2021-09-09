import 'package:flutter/widgets.dart';

import '../models/page_arguments.dart';

mixin NavigationParserMixin on RouteInformationParser<PageArguments> {
  String get initialPage;

  @override
  Future<PageArguments> parseRouteInformation(
      RouteInformation routeInformation) async {
    var location = routeInformation.location!;

    if (location == '/') {
      location = initialPage;
    }

    return PageArguments(Uri.parse(location));
  }

  @override
  RouteInformation? restoreRouteInformation(PageArguments configuration) {
    return RouteInformation(location: configuration.completePath);
  }
}
