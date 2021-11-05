import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:router_management/src/mixins/navigation_router_mixin.dart';
import 'package:router_management/src/mixins/navigation_widget_mixin.dart';
import 'package:router_management/src/models/navigation_page.dart';

/// [NavigationRouter] is the widget core for navigator 2.0 implementation
class NavigationRouter extends StatefulWidget {
  /// [NavigationRouter.child] is used to build a [Router] to handle the
  /// navigator 2.0
  final NavigationWidgetMixin child;

  /// [NavigationRouter.pages] is used to create pages that can be accessed by
  /// the navigator 2.0
  final List<NavigationPage> pages;

  /// [NavigationRouter.initialPage] is used to render the page that has the
  /// same path. If the [PageWidget.build] returns a router
  /// without a [RouteInformationProvider] it will not work correctly.
  /// Defaults to "/"
  final String initialPage;

  /// [NavigationRouter.navigatorObservers] is used to observer the navigator
  /// 2.0 when navigating between screens. Defaults to [List.empty()]
  final List<NavigatorObserver> navigatorObservers;

  /// [NavigationRouter.useHash] If it is true then will be used the default url
  /// strategy that is a path with hash, for example:
  /// flutterexample.dev/#/path/to/screen, otherwise will be
  /// flutterexample.dev/path/to/screen. Defaults to [false]
  final bool useHash;

  /// [NavigationRouter.restorationScopeId] is used to save and restore the
  /// navigator 2.0 state, if it is [null] then the state will not be saved.
  /// Defaults to [null]
  final String? restorationScopeId;

  /// [NavigationRouter.unknownPage] is used to create an unknownPage with the
  /// given path
  final NavigationPage? unknownPage;

  /// [transitionDuration] is used to controls the animation
  /// transition. Defaults to [Duration(milliseconds: 400)]
  final Duration transitionDuration;

  /// [NavigationRouter.transitionsBuilder] is used to build a global custom
  /// animation transition when navigating to another page. Defaults: if the
  /// platform is web then will not have any transition else will be [null]
  final RouteTransitionsBuilder? transitionsBuilder;

  /// Is used to create a new instance of [NavigationRouter]
  const NavigationRouter({
    Key? key,
    required this.child,
    required this.pages,
    this.initialPage = '/',
    this.navigatorObservers = const <NavigatorObserver>[],
    this.useHash = false,
    this.restorationScopeId,
    this.unknownPage,
    this.transitionDuration = kIsWeb
        ? const Duration(microseconds: 1)
        : const Duration(milliseconds: 400),
    this.transitionsBuilder = kIsWeb ? defaultWebTransition : null,
  }) : super(key: key);

  /// [NavigationRouter.defaultWebTransition] is used to get the default web
  /// transition that means it does not have any transition when navigating
  /// between screens
  static Widget defaultWebTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }

  @override
  _NavigationRouterState createState() => _NavigationRouterState();
}

class _NavigationRouterState extends State<NavigationRouter>
    with NavigationRouterMixin {
  @override
  Widget build(BuildContext context) => widget.child;
}
