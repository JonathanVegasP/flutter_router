import 'package:flutter/widgets.dart';
import 'package:router_management/src/mixins/navigation_router_guard_mixin.dart';
import 'package:router_management/src/models/page_arguments.dart';

/// [NavigationRouterValidation] is used to validate the route
typedef NavigationRouterValidation = Future<bool> Function(
  PageArguments arguments,
);

/// [NavigationRouterGuard] is used to validate the page, if the page can't be
/// activated, then will be redirected to another page.
class NavigationRouterGuard extends StatefulWidget {
  /// [child] is used to build the page when it can be activated
  final Widget child;

  /// [validation] is used to process if the page can be activated or not
  final NavigationRouterValidation validation;

  /// [placeholder] is used to build a placeholder while is activating. Defaults
  /// to [SizedBox.shrink()]
  final Widget placeholder;

  /// [pathToRedirectOnInvalidate] is used to redirect to a page when
  /// [redirectToUnknownPageOnInvalidate] is [false] or if was not set an
  /// unknown page in the [NavigationRouter]. Defaults to ["/"]
  final String pathToRedirectOnInvalidate;

  /// [redirectToUnknownPageOnInvalidate] is used to redirect to the unknown
  /// page, if it was not set or the value is [false], then will be redirect
  /// using [pathToRedirectOnInvalidate]. Defaults to [true]
  final bool redirectToUnknownPageOnInvalidate;

  /// Create a new instance of [NavigationRouterGuard]
  const NavigationRouterGuard({
    Key? key,
    required this.child,
    required this.validation,
    this.placeholder = const SizedBox.shrink(),
    this.pathToRedirectOnInvalidate = '/',
    this.redirectToUnknownPageOnInvalidate = true,
  }) : super(key: key);

  @override
  State<NavigationRouterGuard> createState() => _NavigationRouterGuardState();
}

class _NavigationRouterGuardState extends State<NavigationRouterGuard>
    with NavigationRouterGuardMixin {
  @override
  Widget build(BuildContext context) {
    if (canActivate) return widget.child;

    return widget.placeholder;
  }
}
