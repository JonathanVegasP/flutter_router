import 'package:flutter/widgets.dart';
import 'package:router_management/src/exceptions/navigation_exception.dart';
import 'package:router_management/src/services/navigation_service.dart';
import 'package:router_management/src/ui/navigation_router.dart';
import 'package:url_strategy/url_strategy.dart';

mixin NavigationRouterMixin<T extends NavigationRouter> on State<T> {
  final service = NavigationService.instance as NavigationService;
  late final provider = PlatformRouteInformationProvider(
    initialRouteInformation: RouteInformation(location: widget.initialPage),
  );

  @override
  void initState() {
    super.initState();

    if (!widget.useHash) setPathUrlStrategy();

    final pages = widget.pages;

    assert(() {
      final hasInitialPage = pages.any((p) => p.path == widget.initialPage);

      if (!hasInitialPage) {
        throw NavigationException(
            'Was not found any page with the path "${widget.initialPage}"');
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

    service.pages = pages;
    service.unknownPage = widget.unknownPage;
    service.restorationScopeId = widget.restorationScopeId;
    service.navigationObservers = widget.navigatorObservers;
    service.transitionDuration = widget.transitionDuration;
    service.transitionsBuilder = widget.transitionsBuilder;
    service.addInitialPage(widget.initialPage);
  }
}
