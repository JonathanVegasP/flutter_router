import 'package:flutter/widgets.dart';

import '../../domain/models/page_arguments.dart';
import '../../domain/services/navigation.dart';
import '../mixins/navigation_mixin.dart';

mixin NavigationDelegateMixin
    on
        RouterDelegate<PageArguments>,
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageArguments>,
        Navigation,
        NavigationMixin {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  String? _restorationScopeId;

  set restorationScopeId(String? newValue) => _restorationScopeId = newValue;

  bool _onPopPage(Route route, result) {
    if (!route.didPop(result)) return false;

    popWithResult(result);

    notifyListeners();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      restorationScopeId: _restorationScopeId,
      observers: observers,
      pages: List.unmodifiable(activePages),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(PageArguments configuration) async {
    final page = getPage(configuration);

    if (page == null) {
      pushToUnknownPage();

      return;
    }

    if (!(await page(this, configuration))) return;

    activePages.clear();

    activePages.add(buildSettings(page, configuration));

    notifyListeners();
  }

  @override
  PageArguments? get currentConfiguration => activePages.last.arguments;
}
