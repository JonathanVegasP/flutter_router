import 'package:flutter/widgets.dart';
import 'package:url_strategy/url_strategy.dart';

import '../../data/services/navigation_parser.dart';
import '../../data/services/navigation_service.dart';
import '../../exceptions/navigation_exception.dart';
import '../ui/navigation_router.dart';

mixin NavigationRouterMixin<T extends NavigationRouter> on State<T> {
  final service = NavigationService.instance as NavigationService;
  late final NavigationParser parser;

  @override
  void initState() {
    super.initState();

    if (!widget.useHash) setPathUrlStrategy();

    parser = NavigationParser(widget.initialPage);

    service.addInitialPage(widget.initialPage);

    bool? hasInitialPage;

    for (final page in widget.pages) {
      service.addPage(page);

      assert(() {
        if (hasInitialPage != true) {
          hasInitialPage = page.path == widget.initialPage;
        }

        return true;
      }());
    }

    assert(() {
      if (hasInitialPage == false) {
        throw NavigationException(
            'Was not found any page with the path "${widget.initialPage}"');
      }

      return true;
    }());

    assert(() {
      final list = widget.pages.map((e) => e.path).toList();

      if (list.length != list.toSet().length) {
        throw const NavigationException(
          'There are some pages with the same path',
        );
      }

      return true;
    }());

    service.navigationObservers = widget.navigatorObservers;
    service.restorationScopeId = widget.restorationScopeId;
    service.unknownPage = widget.unknownPage;
    service.transitionsBuilder = widget.transitionsBuilder;

    widget.child.onInit(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.child.onChangedDependencies(context);
  }

  @override
  void deactivate() {
    widget.child.onDeactivate(context);

    super.deactivate();
  }

  @override
  void dispose() {
    widget.child.onDispose(context);

    super.dispose();
  }
}
