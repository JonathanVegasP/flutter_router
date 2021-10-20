import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:router_management/src/exceptions/navigation_exception.dart';
import 'package:router_management/src/mixins/navigation.dart';
import 'package:router_management/src/models/navigation_page.dart';
import 'package:router_management/src/models/page_arguments.dart';
import 'package:router_management/src/ui/page_settings.dart';

/// [NavigationService] is the core class that is used to get the actual
/// [Navigation] instance
class NavigationService extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String>, Navigation {
  final _activePages = <PageSettings>[];
  late final List<NavigationPage> pages;
  late final NavigationPage? unknownPage;
  late final Duration transitionDuration;
  late final RouteTransitionsBuilder? transitionsBuilder;
  late final List<NavigatorObserver> observers;
  late final String? restorationScopeId;
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  /// Is used internally
  NavigationService._();

  /// [NavigationService.instance] is the implementation of navigator 2.0
  static late final Navigation instance = NavigationService._();

  /// This is used internally
  void initialize(String path) {
    _activePages.add(PageSettings(
      path: '',
      arguments: _buildArgs(path),
      child: const SizedBox(),
      isCompleted: true,
    ));
  }

  PageArguments _buildArgs(String page, [Object? data]) {
    return PageArguments(Uri.parse(page), data);
  }

  @protected
  NavigationPage? _getPage(PageArguments arguments) {
    final length = arguments.paths.length;

    for (final page in pages) {
      if (page.path == arguments.path) return page;

      if (!page.hasPathParams) continue;

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
      transitionDuration: page.transitionDuration ?? transitionDuration,
      transitionsBuilder: page.transitionsBuilder ?? transitionsBuilder,
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
  void pushToUnknownPage([bool shouldResetPages = true]) {
    final unknownPage = this.unknownPage;

    if (unknownPage == null) return;

    if (shouldResetPages) _activePages.clear();

    _activePages.add(_buildSettings(unknownPage, _buildArgs(unknownPage.path)));

    notifyListeners();
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
      restorationScopeId: restorationScopeId,
      observers: observers,
      pages: List.unmodifiable(_activePages),
      onPopPage: _onPopPage,
      transitionDelegate: const _DefaultTransitionDelegate(),
    );
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    final args = _buildArgs(configuration);

    final page = _getPage(args);

    if (page == null) {
      pushToUnknownPage();

      final last = _activePages.last;

      if (last.isInitialPage) pushReplacement(last.arguments.path);

      return;
    }

    if (!(await page(this, args))) return;

    _activePages.clear();

    final length = args.paths.length - 1;

    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      buffer.write('/');
      buffer.write(args.paths[i]);

      final arguments = _buildArgs(buffer.toString());

      final page = _getPage(arguments);

      if (page == null) continue;

      if (!(await page(this, args))) return;

      _activePages.add(_buildSettings(page, arguments));
    }

    _activePages.add(_buildSettings(page, args));

    notifyListeners();
  }

  @override
  String? get currentConfiguration => _activePages.last.arguments.path;
}

class _DefaultTransitionDelegate<T> extends TransitionDelegate<T> {
  const _DefaultTransitionDelegate() : super();

  static late var _shouldAnimate = false;

  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
        locationToExitingPageRoute,
    required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    final results = <RouteTransitionRecord>[];

    void handleExistingRoute(RouteTransitionRecord? key, bool isLast) {
      final exitingPageRoute = locationToExitingPageRoute[key];

      if (exitingPageRoute == null) return;

      if (exitingPageRoute.isWaitingForExitingDecision) {
        final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        final hasPagelessRoutes = pagelessRoutes != null;
        final isLastExistingPageRoute =
            isLast && !locationToExitingPageRoute.containsKey(exitingPageRoute);

        if (isLastExistingPageRoute && !hasPagelessRoutes) {
          exitingPageRoute.markForPop(exitingPageRoute.route.currentResult);
        } else {
          exitingPageRoute
              .markForComplete(exitingPageRoute.route.currentResult);
        }

        if (hasPagelessRoutes) {
          final length = pagelessRoutes!.length - 1;

          for (var i = 0; i <= length; i++) {
            final route = pagelessRoutes[i];

            if (route.isWaitingForExitingDecision) {
              if (isLastExistingPageRoute && i == length) {
                route.markForPop(route.route.currentResult);
              } else {
                route.markForComplete(route.route.currentResult);
              }
            }
          }
        }
      }

      results.add(exitingPageRoute);

      handleExistingRoute(exitingPageRoute, isLast);
    }

    handleExistingRoute(null, newPageRouteHistory.isEmpty);

    final length = newPageRouteHistory.length - 1;

    for (var i = 0; i <= length; i++) {
      final isLast = i == length;
      final pageRoute = newPageRouteHistory[i];

      if (pageRoute.isWaitingForEnteringDecision) {
        if (!_shouldAnimate) {
          _shouldAnimate = true;

          pageRoute.markForAdd();
        } else if (isLast &&
            !locationToExitingPageRoute.containsKey(pageRoute)) {
          pageRoute.markForPush();
        } else {
          pageRoute.markForAdd();
        }
      }

      results.add(pageRoute);

      handleExistingRoute(pageRoute, isLast);
    }

    return results;
  }
}
