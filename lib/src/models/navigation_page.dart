import 'package:flutter/widgets.dart';
import 'package:router_management/src/exceptions/navigation_exception.dart';
import 'package:router_management/src/mixins/navigation.dart';
import 'package:router_management/src/mixins/page_validator.dart';
import 'package:router_management/src/models/page_arguments.dart';

/// [NavigationPage] is used to create a page into the [NavigationRouter]
class NavigationPage {
  /// [path] is the page's path like: /home. To declare a page's
  /// param use this pattern "/:param-name" then use the
  /// [PageArguments.params['param-name']] to get the data from the path like:
  /// /profile/:id
  final String path;

  /// [builder] is used to build the page and create an active
  /// page
  final Widget Function() builder;

  /// [fullscreenDialog] is used to create a fullscreen dialog
  /// page. Defaults to [false]
  final bool fullscreenDialog;

  /// [maintainState] If it is false the state of the page will
  /// be discarded when navigating to another page. Defaults to [true]
  final bool maintainState;

  /// [transitionDuration] is used to controls the animation
  /// transition. Defaults to [NavigationRouter.transitionDuration]
  final Duration? transitionDuration;

  /// [validators] is used to controls the page's activation when
  /// it must has more than the basics arguments like an id or something else,
  /// if it returns false then the page will be redirect to the initial page or
  /// use the [Navigation] to redirect to another page. Defaults to
  /// [List.empty()]
  final List<PageValidator> validators;

  /// [NavigationPage.restorationId] is used to save and restore the page's
  /// state, if it is [null] then the state will not be saved. Defaults to
  /// [null]
  final String? restorationId;

  /// [name] is used to name the page. Defaults to [null]
  final String? name;

  /// [NavigationPage.transitionsBuilder] is used to create a custom transition
  /// to the page. Defaults to System's Animation Transition
  final RouteTransitionsBuilder? transitionsBuilder;

  /// This is used internally
  final bool hasPathParams;

  /// Is used to create a new instance of [NavigationPage]
  NavigationPage({
    required this.path,
    required this.builder,
    this.fullscreenDialog = false,
    this.maintainState = true,
    this.transitionDuration,
    this.validators = const <PageValidator>[],
    this.restorationId,
    this.name,
    this.transitionsBuilder,
  })  : assert(() {
          if (path.isEmpty || path[0] != '/') {
            throw const NavigationException(
              'NavigationPage.path must begin with "/"',
            );
          }

          return true;
        }()),
        hasPathParams = path.contains('/:');

  /// Is used internally
  Future<bool> call(Navigation navigation, PageArguments arguments) async {
    for (final validator in validators) {
      if (!(await validator(this, navigation, arguments))) return false;
    }

    return true;
  }
}
