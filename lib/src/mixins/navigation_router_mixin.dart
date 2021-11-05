import 'package:flutter/widgets.dart';
import 'package:router_management/src/services/navigation_parser.dart';
import 'package:router_management/src/services/navigation_service.dart';
import 'package:router_management/src/widgets/navigation_router.dart';

mixin NavigationRouterMixin<T extends NavigationRouter> on State<T> {
  final service = NavigationService.instance as NavigationService;

  @override
  void initState() {
    super.initState();

    service.initialize(
      initialPage: widget.initialPage,
      pages: widget.pages,
      unknownPage: widget.unknownPage,
      transitionDuration: widget.transitionDuration,
      transitionsBuilder: widget.transitionsBuilder,
      observers: widget.navigatorObservers,
      restorationScopeId: widget.restorationScopeId,
      useHash: widget.useHash,
    );

    widget.child.routerDelegate = service;
    widget.child.routeInformationParser = const NavigationParser();
  }
}
