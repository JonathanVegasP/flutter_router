/// [PageArguments] is used to get the current page's arguments
class PageArguments {
  /// [PageArguments.uri] is used to get the path's data
  final Uri uri;

  /// [PageArguments.data] is used to get the data that can be passed into the
  /// [Navigation] push methods
  final Object? data;

  /// [PageArguments.params] is used to get the path's params
  late final Map<String, String> params = {};

  /// [PageArguments.path] is a shortcut from [Uri.path] to get the current path
  late final path = uri.path;

  /// [PageArguments.paths] is a shortcut from [Uri.pathSegments] to get the
  /// current paths segments
  late final paths = uri.pathSegments;

  /// [PageArguments.paths] is a shortcut from [Uri.toString()] to get the
  /// current complete path
  late final completePath = uri.toString();

  /// [PageArguments.paths] is a shortcut from [Uri.queryParameters] to get the
  /// current query as a [Map<String,String>] object
  late final query = uri.queryParameters;

  /// [PageArguments.paths] is a shortcut from [Uri.queryParametersAll] to get
  /// the current list of queries as a [Map<String,List<String>>] object
  late final queries = uri.queryParametersAll;

  /// Is used to create a new instance of [PageArguments]
  PageArguments(this.uri, [this.data]);

  @override
  String toString() => completePath;
}
