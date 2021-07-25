import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/models/navigation_page.dart';
import '../../domain/models/page_arguments.dart';
import '../../domain/models/page_settings.dart';
import '../../domain/services/navigation.dart';

mixin NavigationMixin on Navigation, ChangeNotifier {
  final activePages = <PageSettings>[];
  final _pages = <NavigationPage>[];
  final observers = <NavigatorObserver>[
    MaterialApp.createMaterialHeroController()
  ];
  NavigationPage? _unknownPage;
  RouteTransitionsBuilder? _transitionsBuilder;

  PageSettings<T> buildSettings<T>(
      NavigationPage page, PageArguments arguments) {
    return PageSettings<T>(
      page.path,
      page.restorationId,
      page.name,
      arguments,
      page.builder(),
      page.fullscreenDialog,
      page.maintainState,
      page.transitionDuration,
      page.transitionsBuilder ?? _transitionsBuilder,
      activePages.isEmpty,
    );
  }

  void addInitialPage(String page) {
    activePages.add(PageSettings.initialPage(page));
  }

  void addPage(NavigationPage page) {
    _pages.add(page);
  }

  set navigationObservers(List<NavigatorObserver> newValue) {
    observers.addAll(newValue);
  }

  set unknownPage(NavigationPage? newValue) => _unknownPage = newValue;

  set transitionsBuilder(RouteTransitionsBuilder? newValue) {
    _transitionsBuilder = newValue;
  }

  PageArguments _buildArgs(String page, [Object? data]) {
    return PageArguments(Uri.parse(page), data);
  }

  NavigationPage? getPage(PageArguments arguments) {
    final length = arguments.paths.length;

    for (final page in _pages) {
      if (page.path == arguments.path) return page;

      final paths = page.path.substring(1).split('/');

      if (length != paths.length) continue;

      var hasFound = false;

      for (var i = 0; i < length; i++) {
        final path = paths[i];
        final current = arguments.paths[i];

        if (path == current) {
          hasFound = true;
        } else if (path.isNotEmpty && path[0] == ':') {
          arguments.params[path.substring(1)] = current;
        } else {
          hasFound = false;
          break;
        }
      }

      if (hasFound) return page;
    }

    return null;
  }

  Future<T?> _push<T>(PageArguments arguments, NavigationPage page) async {
    final activePage = buildSettings<T>(page, arguments);

    activePages.add(activePage);

    notifyListeners();

    return activePage.completer?.future;
  }

  void popWithResult<T>([T? result]) {
    final completer = activePages.removeLast().completer;

    if (completer?.isCompleted == false) completer!.complete(result);
  }

  @override
  Future<T?> push<T>(String page, [Object? data]) async {
    final arguments = _buildArgs(page, data);

    final route = getPage(arguments);

    if (route == null) return null;

    return _push<T>(arguments, route);
  }

  @override
  Future<T?> pushReplacement<T>(String page, [Object? data]) async {
    final arguments = _buildArgs(page, data);

    final route = getPage(arguments);

    if (route == null) return null;

    popWithResult();

    return _push<T>(arguments, route);
  }

  @override
  Future<T?> pushAndReplaceUntil<T>(
    String page,
    bool Function(PageSettings) predicate, [
    Object? data,
  ]) async {
    final arguments = _buildArgs(page, data);

    final route = getPage(arguments);

    if (route == null) return null;

    while (activePages.isNotEmpty && !predicate(activePages.last)) {
      popWithResult();
    }

    return _push<T>(arguments, route);
  }

  @override
  void pop<T>([T? result]) {
    if (!canPop) return;

    popWithResult<T>(result);

    notifyListeners();
  }

  @override
  Future<R?> popAndPush<T, R>(String page, {T? result, Object? data}) async {
    if (!canPop) return null;

    final arguments = _buildArgs(page, data);

    final route = getPage(arguments);

    if (route == null) return null;

    popWithResult<T>(result);

    return _push<R>(arguments, route);
  }

  @override
  void popUntil(bool Function(PageSettings) predicate) {
    if (!canPop) return;

    while (canPop && !predicate(activePages.last)) {
      popWithResult();
    }

    notifyListeners();
  }

  @override
  void pushToUnknownPage([bool shouldResetPages = true]) {
    if (_unknownPage != null) {
      if (shouldResetPages) activePages.clear();

      activePages.add(
        buildSettings(_unknownPage!, _buildArgs(_unknownPage!.path, null)),
      );

      notifyListeners();
    }
  }

  @override
  bool get canPop => activePages.length > 1;
}
