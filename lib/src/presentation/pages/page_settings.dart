import 'package:flutter/widgets.dart';

import '../../data/models/page_arguments.dart';
import '../../data/models/page_settings.dart';
import 'page_route_navigation.dart';

class PageSettingsImpl<T> extends PageSettings<T> {
  PageSettingsImpl(
      String path,
      String? restorationId,
      String? name,
      PageArguments arguments,
      Widget child,
      bool fullscreenDialog,
      bool maintainState,
      Duration transitionDuration,
      RouteTransitionsBuilder? transitionsBuilder,
      bool isCompleted)
      : super(path, restorationId, name, arguments, child, fullscreenDialog,
            maintainState, transitionDuration, transitionsBuilder, isCompleted);

  PageSettingsImpl.initialPage(String path) : super.initialPage(path);

  @override
  Route<void> createRoute(BuildContext context) => PageRouteNavigation(this);
}
