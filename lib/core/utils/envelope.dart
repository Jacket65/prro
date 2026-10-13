/// Helpers for decoding the backend's `{ "data": ... }` response envelope.
///
/// The backend normally wraps payloads in `{data, error, meta}`; single objects
/// land one level deeper in `data['data']`, and stub/legacy endpoints may
/// answer with a bare body. All four helpers live here — the only core layer
/// domain may import (`core/domain` uses them to unwrap order-history payloads
/// without reaching into `core/network`).
///
/// Two unwrapping flavours exist on purpose:
/// * [unwrapList] / [unwrapObject] / [unwrapPayload] are **type-directed** and
///   fall back to the envelope itself, so a model that also tolerates a bare
///   body keeps working.
/// * [unwrapData] is **presence-based** and returns `null` for
///   `{"data": null}` — that is how the backend's stub responses are detected.
library;

/// A `data` array of objects, or a bare array; anything else is empty.
List<T> unwrapList<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  final list = switch (raw) {
    final Map<String, dynamic> m when m['data'] is List =>
      m['data'] as List<dynamic>,
    final List<dynamic> l => l,
    _ => <dynamic>[],
  };
  return list.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

/// The object payload of a response: `data['data']` when that is an object,
/// otherwise the envelope map itself (tolerance for sibling top-level keys),
/// and `null` when the body carries no object at all.
T? unwrapObject<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
  final map = switch (raw) {
    final Map<String, dynamic> m when m['data'] is Map =>
      m['data'] as Map<String, dynamic>,
    final Map<String, dynamic> m => m,
    _ => null,
  };
  if (map == null) return null;
  return fromJson(map);
}

/// The object payload of a backend response, unwrapped from its
/// `{data, error, meta}` envelope.
///
/// Prefers `data` when it is itself an object and otherwise hands back the
/// envelope, so a caller that already tolerates a bare body (the order-history
/// models) keeps working. Returns `null` only when the body carries no object
/// at all — a call site that requires one fails loudly on that `null` rather
/// than defaulting to an empty payload.
Map<String, dynamic>? unwrapPayload(Object? raw) {
  if (raw is Map && raw['data'] is Map) {
    return (raw['data'] as Map).cast<String, dynamic>();
  }
  if (raw is Map) return raw.cast<String, dynamic>();
  return null;
}

/// The value of the envelope's `data` key, or [raw] itself when the body is not
/// an envelope.
///
/// Unlike [unwrapPayload] this is *presence*-based, not type-based: a
/// `{"data": null}` body yields `null`. That is what lets a caller detect the
/// backend's stub responses, which answer 200 with an explicitly empty payload.
Object? unwrapData(Object? raw) {
  if (raw is Map && raw.containsKey('data')) return raw['data'];
  return raw;
}
