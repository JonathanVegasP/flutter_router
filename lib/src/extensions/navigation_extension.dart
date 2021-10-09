import 'package:flutter/widgets.dart';
import 'package:router_management/src/mixins/navigation.dart';
import 'package:router_management/src/services/navigation_service.dart';

/// [NavigationExtension] is used to get the current [Navigation] instance on
/// the [BuildContext]
extension NavigationExtension on BuildContext {
  /// [BuildContext.navigator] is used to get the current [Navigation] instance
  Navigation get navigator => NavigationService.instance;
}
