import 'package:flutter/widgets.dart';

import '../../data/mixins/navigation.dart';
import '../mixins/navigation_delegate_mixin.dart';
import '../mixins/navigation_mixin.dart';
import '../../data/models/page_arguments.dart';

/// [NavigationService] is the core class that is used to get the actual
/// [Navigation] instance
class NavigationService extends RouterDelegate<PageArguments>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageArguments>,
        Navigation,
        NavigationMixin,
        NavigationDelegateMixin {
  /// Is used internally
  NavigationService._();

  /// [NavigationService.instance] is the implementation of navigator 2.0
  static late final Navigation instance = NavigationService._();
}
