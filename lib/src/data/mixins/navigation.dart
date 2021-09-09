import '../../presentation/pages/page_settings.dart';

/// [Navigation] is the core navigation interface and is used to controls the
/// navigator 2.0
mixin Navigation {
  /// [Navigation.push] is used to navigate to another screen maintaining the
  /// previous screen
  Future<T?> push<T>(String page, [Object? data]);

  /// [Navigation.pushReplacement] is used to navigate to another screen
  /// replacing the previous screen
  Future<T?> pushReplacement<T>(String page, [Object? data]);

  /// [Navigation.pushAndReplaceUntil] is used to navigate to another screen
  /// and replaces the previous screens until the condition returns [true]
  Future<T?> pushAndReplaceUntil<T>(
    String page,
    bool Function(PageSettings) predicate, [
    Object? data,
  ]);

  /// [Navigation.pop] is used to navigate back to the previous screen
  void pop<T>([T? result]);

  /// [Navigation.popAndPush] is used to navigate back to the previous screen
  /// and navigate to another screen
  Future<R?> popAndPush<T, R>(String page, {T? result, Object? data});

  /// [Navigation.popUntil] is used to navigate back until the condition
  /// returns true
  void popUntil(bool Function(PageSettings) predicate);

  /// [Navigation.pushToUnknownPage] is used to navigate to the unknown page
  void pushToUnknownPage([bool shouldResetPages = true]);

  /// [Navigation.canPop] is used to know when the page can be popped
  bool get canPop;
}
