import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'page_settings.dart';

class PageRouteNavigation extends PageRoute<void> {
  PageRouteNavigation(PageSettings settings)
      : super(fullscreenDialog: settings.fullscreenDialog, settings: settings);

  @override
  PageSettings get settings => super.settings as PageSettings;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: settings.child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if(animation.isCompleted || secondaryAnimation.isCompleted) return child;
    
    final transitionsBuilder = settings.transitionsBuilder;

    if (transitionsBuilder != null) {
      return transitionsBuilder(context, animation, secondaryAnimation, child);
    }

    final theme = Theme.of(context).pageTransitionsTheme;

    return theme.buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }

  @override
  bool get maintainState => settings.maintainState;

  @override
  Duration get transitionDuration => settings.transitionDuration;
}
