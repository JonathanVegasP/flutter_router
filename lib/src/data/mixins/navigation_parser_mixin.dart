import 'package:flutter/widgets.dart';

import '../models/page_arguments.dart';

mixin NavigationParserMixin on RouteInformationParser<PageArguments> {
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
