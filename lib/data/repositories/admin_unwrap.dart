/// Helpers for parsing admin API responses that wrap payloads in a
/// `{ "data": ... }` envelope (and single objects in `data['data']`).
///
/// Mirrors the convention already used by `orders_repository_impl`.
List<T> unwrapList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  final list = switch (raw) {
    final Map<String, dynamic> m when m['data'] is List =>
      m['data'] as List<dynamic>,
    final List<dynamic> l => l,
    _ => <dynamic>[],
  };
  return list.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

T? unwrapObject<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  final map = switch (raw) {
    final Map<String, dynamic> m when m['data'] is Map =>
      m['data'] as Map<String, dynamic>,
    final Map<String, dynamic> m => m,
    _ => null,
  };
  if (map == null) return null;
  return fromJson(map);
}
