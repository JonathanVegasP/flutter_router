import 'package:flutter/widgets.dart';

import '../mixins/navigation_parser_mixin.dart';
import '../models/page_arguments.dart';

class NavigationParser extends RouteInformationParser<PageArguments>
    with NavigationParserMixin {
  const NavigationParser();
}
