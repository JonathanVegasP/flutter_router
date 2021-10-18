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
  late final List<NavigationPage> _pages;
  late final NavigationPage? _unknownPage;
  late final Duration _transitionDuration;
  late final RouteTransitionsBuilder? _transitionsBuilder;
  late final List<NavigatorObserver> _observers;
  String? _restorationScopeId;
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  /// Is used internally
  NavigationService._();

  /// [NavigationService.instance] is the implementation of navigator 2.0
  static late final Navigation instance = NavigationService._();

  /// This is used internally
  void addInitialPage(String path) {
    _activePages.add(
      PageSettings(
        '',
        null,
        null,
        _buildArgs(path),
        const SizedBox(),
        false,
        false,
        Duration.zero,
        null,
        true,
      ),
    );
  }

  /// This is used internally
  set pages(List<NavigationPage> newValue) => _pages = newValue;

  /// This is used internally
  set unknownPage(NavigationPage? newValue) => _unknownPage = newValue;

  /// Is used internally
  set restorationScopeId(String? newValue) => _restorationScopeId = newValue;

  /// Is used internally
  set navigationObservers(List<NavigatorObserver> newValue) {
    _observers = newValue;
  }

  /// This is used internally
  set transitionDuration(Duration newValue) => _transitionDuration = newValue;

  /// This is used internally
  set transitionsBuilder(RouteTransitionsBuilder? newValue) {
    _transitionsBuilder = newValue;
  }

  PageArguments _buildArgs(String page, [Object? data]) {
    return PageArguments(Uri.parse(page), data);
  }

  @protected
  NavigationPage? _getPage(PageArguments arguments) {
    final length = arguments.paths.length;

    for (final page in _pages) {
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
      page.path,
      page.restorationId,
      page.name,
      arguments,
      page.builder(),
      page.fullscreenDialog,
      page.maintainState,
      page.transitionDuration ?? _transitionDuration,
      page.transitionsBuilder ?? _transitionsBuilder,
      _activePages.isEmpty,
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
    final unknownPage = _unknownPage;

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
      restorationScopeId: _restorationScopeId,
      observers: _observers,
      pages: List.unmodifiable(_activePages),
      onPopPage: _onPopPage,
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
  String? get currentConfiguration => _activePages.last.arguments.completePath;
}
