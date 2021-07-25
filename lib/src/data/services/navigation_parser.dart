import 'package:flutter/widgets.dart';

import '../../domain/models/page_arguments.dart';
import '../mixins/navigation_parser_mixin.dart';

class NavigationParser extends RouteInformationParser<PageArguments>
    with NavigationParserMixin {
  @override
  final String initialPage;

  const NavigationParser(this.initialPage);
}
