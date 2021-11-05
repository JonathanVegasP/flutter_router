import 'dart:async' show scheduleMicrotask;

import 'package:flutter/widgets.dart';
import 'package:router_management/src/exceptions/navigation_exception.dart';
import 'package:router_management/src/mixins/navigation.dart';
import 'package:router_management/src/models/navigation_page.dart';
import 'package:router_management/src/models/page_arguments.dart';
import 'package:router_management/src/widgets/page_settings.dart';
import 'package:url_strategy/url_strategy.dart';

/// [NavigationService] is the core class that is used to get the actual
/// [Navigation] instance
class NavigationService extends RouterDelegate<PageArguments>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageArguments>,
        Navigation {
  final _activePages = <PageSettings>[];
  late final String _initialPage;
  late final List<NavigationPage> _pages;
  late final NavigationPage? _unknownPage;
  late final Duration _transitionDuration;
  late final RouteTransitionsBuilder? _transitionsBuilder;
  late final List<NavigatorObserver> _observers;
  late final String? _restorationScopeId;
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  /// Is used internally
  NavigationService._();

  /// [NavigationService.instance] is the implementation of navigator 2.0
  static late final Navigation instance = NavigationService._();

  @override
  Future<void> setInitialRoutePath(PageArguments configuration) async {}

  @override
  void notifyListeners() {
    scheduleMicrotask(super.notifyListeners);
  }

  /// This is used internally
  void initialize({
    required String initialPage,
    required List<NavigationPage> pages,
    required NavigationPage? unknownPage,
    required Duration transitionDuration,
    required RouteTransitionsBuilder? transitionsBuilder,
    required List<NavigatorObserver> observers,
    required String? restorationScopeId,
    required bool useHash,
  }) {
    if (!useHash) setPathUrlStrategy();

    var path = _initialPage = initialPage;

    assert(() {
      final hasInitialPage = pages.any((p) => p.path == path);

      if (!hasInitialPage) {
        throw NavigationException(
            'Was not found any page with the path "$path"');
      }

      return true;
    }());

    assert(() {
      final list = pages.map((p) => p.path).toList();

      if (list.length != list.toSet().length) {
        throw const NavigationException(
          'There are some pages with the same path',
        );
      }

      return true;
    }());

    final route = WidgetsBinding.instance!.window.defaultRouteName;

    if (route != Navigator.defaultRouteName) path = route;

    _pages = pages;
    _unknownPage = unknownPage;
    _transitionDuration = transitionDuration;
    _transitionsBuilder = transitionsBuilder;
    _observers = observers;
    _restorationScopeId = restorationScopeId;

    setNewRoutePath(_buildArgs(path));
  }

  PageArguments _buildArgs(String page, [Object? data]) {
    return PageArguments(Uri.parse(page), data);
  }

  @protected
  NavigationPage? _getPage(PageArguments arguments) {
    for (final page in _pages) {
      if (page(arguments)) return page;
    }
  }

  @protected
  PageSettings<T> _buildSettings<T>(
      NavigationPage page, PageArguments arguments) {
    return PageSettings<T>(
      path: page.path,
      restorationId: page.restorationId,
      name: page.name,
      arguments: arguments,
      child: page.builder(),
      fullscreenDialog: page.fullscreenDialog,
      maintainState: page.maintainState,
      transitionDuration: page.transitionDuration ?? _transitionDuration,
      transitionsBuilder: page.transitionsBuilder ?? _transitionsBuilder,
      isCompleted: _activePages.isEmpty,
    );
  }

  Future<T?> _push<T>(PageArguments arguments, NavigationPage page) async {
    final activePage = _buildSettings<T>(page, arguments);

    _activePages.add(activePage);

    notifyListeners();

    return activePage.completer?.future;
  }

  @protected
  void _popWithResult<T>([T? result]) {
    final completer = _activePages.removeLast().completer;

    if (completer?.isCompleted == false) completer!.complete(result);
  }

  @override
  Future<T?> push<T>(String page, [Object? data]) async {
    final arguments = _buildArgs(page, data);

    final route = _getPage(arguments);

    if (route == null) return null;

    return _push<T>(arguments, route);
  }

  @override
  Future<T?> pushReplacement<T>(String page, [Object? data]) async {
    final arguments = _buildArgs(page, data);

    final route = _getPage(arguments);

    if (route == null) return null;

    _popWithResult();

    return _push<T>(arguments, route);
  }

  @override
  Future<T?> pushAndReplaceUntil<T>(
    String page,
    bool Function(PageSettings) predicate, [
    Object? data,
  ]) async {
    final arguments = _buildArgs(page, data);

    final route = _getPage(arguments);

    if (route == null) return null;

    while (_activePages.isNotEmpty && !predicate(_activePages.last)) {
      _popWithResult();
    }

    return _push<T>(arguments, route);
  }

  @override
  void pop<T>([T? result]) {
    assert(() {
      if (!canPop) {
        final last = _activePages.last;
        final name = last.name ?? last.path;

        throw NavigationException('The page $name cannot be popped');
      }

      return true;
    }());

    _popWithResult<T>(result);

    notifyListeners();
  }

  @override
  Future<R?> popAndPush<T, R>(String page, {T? result, Object? data}) async {
    assert(() {
      if (!canPop) {
        final last = _activePages.last;
        final name = last.name ?? last.path;

        throw NavigationException('The page $name cannot be popped');
      }

      return true;
    }());

    final arguments = _buildArgs(page, data);

    final route = _getPage(arguments);

    if (route == null) return null;

    _popWithResult<T>(result);

    return _push<R>(arguments, route);
  }

  @override
  void popUntil(bool Function(PageSettings) predicate) {
    assert(() {
      if (!canPop) {
        final last = _activePages.last;
        final name = last.name ?? last.path;

        throw NavigationException('The page $name cannot be popped');
      }

      return true;
    }());

    while (canPop && !predicate(_activePages.last)) {
      _popWithResult();
    }

    notifyListeners();
  }

  @override
  bool pushToUnknownPage([bool shouldResetPages = true]) {
    final unknownPage = _unknownPage;

    if (unknownPage == null) return false;

    if (shouldResetPages) _activePages.clear();

    _activePages.add(_buildSettings(unknownPage, _buildArgs(unknownPage.path)));

    notifyListeners();

    return true;
  }

  @override
  bool get canPop => _activePages.length > 1;

  bool _onPopPage(Route route, result) {
    if (!route.didPop(result)) return false;

    _popWithResult(result);

    notifyListeners();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      restorationScopeId: _restorationScopeId,
      observers: _observers,
      pages: List.unmodifiable(_activePages),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(PageArguments configuration) async {
    final page = _getPage(configuration);

    if (page == null) {
      pushToUnknownPage();

      return;
    }

    final length = configuration.paths.length - 1;

    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write('/');
      buffer.write(configuration.paths[i]);

      final arguments = _buildArgs(buffer.toString());

      final page = _getPage(arguments);

      if (page == null) continue;

      _activePages.add(_buildSettings(page, arguments));
    }

    _activePages.add(_buildSettings(page, configuration));

    notifyListeners();
  }

  @override
  PageArguments? get currentConfiguration => _activePages.last.arguments;
}
