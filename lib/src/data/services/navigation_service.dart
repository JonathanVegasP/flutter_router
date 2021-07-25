import 'package:flutter/widgets.dart';

import '../../domain/models/page_arguments.dart';
import '../../domain/services/navigation.dart';
import '../mixins/navigation_delegate_mixin.dart';
import '../mixins/navigation_mixin.dart';

/// [NavigationService] is the core class that is used to get the actual
/// [Navigation] instance
class NavigationService extends RouterDelegate<PageArguments>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageArguments>,
        Navigation,
        NavigationMixin,
        NavigationDelegateMixin {
  NavigationService._();

  /// [NavigationService.instance] is the implementation of navigator 2.0
  static late final Navigation instance = NavigationService._();
}
