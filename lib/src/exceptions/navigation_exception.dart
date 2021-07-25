class NavigationException implements Exception {
  final String message;

  const NavigationException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}
