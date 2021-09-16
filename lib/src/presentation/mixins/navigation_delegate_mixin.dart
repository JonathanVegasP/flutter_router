import 'package:flutter/material.dart';

import 'navigation_mixin.dart';
import '../../data/models/page_arguments.dart';

mixin NavigationDelegateMixin
    on
        RouterDelegate<PageArguments>,
        PopNavigatorRouterDelegateMixin<PageArguments>,
        NavigationMixin {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  final _observers = <NavigatorObserver>[
    MaterialApp.createMaterialHeroController()
  ];
  String? _restorationScopeId;

  /// Is used internally
  set restorationScopeId(String? newValue) => _restorationScopeId = newValue;

  /// Is used internally
  set navigationObservers(List<NavigatorObserver> newValue) {
    _observers.addAll(newValue);
  }

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
      observers: _observers,
      pages: List.unmodifiable(activePages),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(PageArguments configuration) async {
    final page = getPage(configuration);

    void onCantActivate() {
      final lastPage = activePages.last;

      if (lastPage.isInitialPage) pushReplacement(lastPage.path);
    }

    if (page == null) {
      pushToUnknownPage();

      onCantActivate();

      return;
    }

    if (!(await page(this, configuration))) {
      onCantActivate();

      return;
    }

    activePages.clear();

    final length = configuration.paths.length - 1;

    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write('/');
      buffer.write(configuration.paths[i]);

      final arguments = PageArguments(Uri.parse(buffer.toString()));

      final page = getPage(arguments);

      if (page == null) continue;

      if (!(await page(this, configuration))) return;

      activePages.add(buildSettings(page, arguments));
    }

    activePages.add(buildSettings(page, configuration));

    notifyListeners();
  }

  @override
  PageArguments? get currentConfiguration => activePages.last.arguments;
}
