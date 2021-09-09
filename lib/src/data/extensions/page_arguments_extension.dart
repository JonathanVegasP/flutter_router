import 'package:flutter/widgets.dart';

import '../models/page_arguments.dart';

/// [PageArgumentsExtension] is used to get the current [PageArguments] on the
/// [BuildContext]
extension PageArgumentsExtension on BuildContext {
  /// [BuildContext.arguments] is used to get the current [PageArguments]
  PageArguments get arguments {
    return ModalRoute.of(this)!.settings.arguments as PageArguments;
  }
}
