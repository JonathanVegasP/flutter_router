import 'package:flutter/widgets.dart';

/// [PageWidget] is used to create a [Router] to handle the navigator 2.0.
/// For example into the build we can use the default implementation
/// [MaterialApp.router]
@immutable
abstract class PageWidget {
  /// Is the default constructor implementation for creating a new instance of a
  /// that is abstracting the [PageWidget]
  const PageWidget();

  /// [PageWidget.onInit] is a shortcut for the method [State.initState]
  void onInit(BuildContext context) {}

  /// [PageWidget.onChangedDependencies] is a shortcut for the method
  /// [State.didChangeDependencies]
  void onChangedDependencies(BuildContext context) {}

  /// [PageWidget.onDeactivate] is a shortcut for the method [State.deactivate]
  void onDeactivate(BuildContext context) {}

  /// [PageWidget.onDispose] is a shortcut for the method [State.dispose]
  void onDispose(BuildContext context) {}

  /// [PageWidget.build] must be used to render a [Router] that handle the
  /// navigator 2.0. For example
  ///
  /// Widget build(
  ///
  /// BuildContext context,
  ///
  /// RouteInformationParser<Uri> routeInformationParser,
  ///
  /// RouterDelegate<Uri> routerDelegate) {
  ///
  ///   return MaterialApp.router(
  ///
  ///   routeInformationParser: routeInformationParser,
  ///
  ///   routerDelegate: routerDelegate,
  ///
  ///   title: 'Hello World',
  ///
  ///   );
  ///
  /// }
  Widget build(
    BuildContext context,
    RouteInformationParser<Object> routeInformationParser,
    RouterDelegate<Object> routerDelegate,
  );
}
