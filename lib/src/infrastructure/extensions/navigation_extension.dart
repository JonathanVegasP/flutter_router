import 'package:flutter/widgets.dart';

import '../../data/services/navigation_service.dart';
import '../../domain/services/navigation.dart';

/// [NavigationExtension] is used to get the current [Navigation] instance on
/// the [BuildContext]
extension NavigationExtension on BuildContext {
  /// [BuildContext.navigator] is used to get the current [Navigation] instance
  Navigation get navigator => NavigationService.instance;
}
