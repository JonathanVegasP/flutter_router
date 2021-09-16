import 'dart:async';

import 'package:flutter/widgets.dart';

import 'page_arguments.dart';

abstract class PageSettings<T> extends Page<void> {
  final Widget child;
  final bool fullscreenDialog;
  final bool maintainState;
  final Duration transitionDuration;
  final RouteTransitionsBuilder? transitionsBuilder;
  final Completer<T?>? completer;
  final bool isInitialPage;

  PageSettings(
    String path,
    String? restorationId,
    String? name,
    PageArguments arguments,
    this.child,
    this.fullscreenDialog,
    this.maintainState,
    this.transitionDuration,
    this.transitionsBuilder,
    bool isCompleted,
  )   : completer = isCompleted ? null : Completer(),
        isInitialPage = false,
        super(
          key: ValueKey<String>(path),
          name: name,
          restorationId: restorationId,
          arguments: arguments,
        );

  PageSettings.initialPage(String path)
      : child = const SizedBox(),
        fullscreenDialog = false,
        maintainState = true,
        transitionDuration = const Duration(milliseconds: 400),
        transitionsBuilder = null,
        completer = null,
        isInitialPage = true,
        super(key: ValueKey<String>(path));

  @override
  ValueKey<String> get key => super.key as ValueKey<String>;

  @override
  PageArguments? get arguments => super.arguments as PageArguments?;

  String get path => key.value;
}
