mixin PathToRegex {
  static RegExp parse(String path, List<String> params) {
    final regExp = RegExp(r':(\w+)');
    final matches = regExp.allMatches(path);
    final buffer = StringBuffer(r'^');
    var start = 0;
    const _defaultRegex = '([^/]+?)';

    for (final match in matches) {
      if (match.start > start) {
        buffer.write(RegExp.escape(path.substring(start, match.start)));
      }

      final name = match[1]!;

      buffer.write(_defaultRegex);

      params.add(name);

      start = match.end;
    }

    if (start < path.length) {
      buffer.write(RegExp.escape(path.substring(start)));
    }

    buffer.write(r'$');

    return RegExp('$buffer', caseSensitive: false);
  }

  static Map<String, String> getParams(List<String> params, Match match) {
    final length = params.length;

    return {
      for (var i = 0; i < length; ++i)
        params[i]: Uri.decodeComponent(match.group(i + 1)!)
    };
  }
}
