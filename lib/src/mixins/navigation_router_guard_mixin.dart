import 'package:flutter/widgets.dart';
import 'package:router_management/src/extensions/navigation_extension.dart';
import 'package:router_management/src/extensions/page_arguments_extension.dart';
import 'package:router_management/src/widgets/navigation_router_guard.dart';

List<Future<bool> Function()>? _tasks;

mixin NavigationRouterGuardMixin<T extends NavigationRouterGuard> on State<T> {
  var canActivate = false;

  Future<bool> _init() async {
    canActivate = await widget.validation(context.arguments);

    if (canActivate) {
      setState(() {});
    } else if (!widget.redirectToUnknownPageOnInvalidate ||
        !context.navigator.pushToUnknownPage()) {
      context.navigator.pushAndReplaceUntil(
        widget.pathToRedirectOnInvalidate,
        (p0) => false,
      );
    }

    return canActivate;
  }

  @override
  void initState() {
    super.initState();

    if (_tasks == null) {
      _tasks = [];

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        for (final task in _tasks!) {
          final result = await task();

          if (!result) {
            break;
          }
        }

        _tasks = null;
      });
    }

    _tasks!.add(_init);
  }
}
