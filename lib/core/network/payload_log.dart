/// Formatting helpers for request/response payloads written to the log.
///
/// The payload that leaves the app is the single most useful artefact when
/// the backend rejects a call (a 500 on `/orders`, a 422 on a malformed
/// body), so the API client logs it — with two caveats:
///
/// * credentials are redacted, so an auth call can be logged safely;
/// * the output is truncated, so a large order does not flood the log.
library;

import 'dart:convert';

const int maxLoggedPayloadLength = 4000;

/// Placeholder written instead of a redacted value.
const String redactedValue = '***';

const Set<String> _sensitiveKeys = {
  'authorization',
  'card_number',
  'cvc',
  'cvv',
  'id_token',
  'otp',
  'pan',
  'pin',
  'secret',
  'token',
};

const List<String> _sensitiveKeyFragments = [
  'password',
  'token',
  'secret',
  'apikey',
  'api_key',
];

bool isSensitiveKey(String key) {
  final normalized = key.toLowerCase();
  if (_sensitiveKeys.contains(normalized)) return true;
  return _sensitiveKeyFragments.any(normalized.contains);
}

/// Renders [data] as a loggable, human-readable string.
///
/// Returns `null` for a `null` payload so callers can skip the log line
/// entirely (a GET has no body). Maps and lists are pretty-printed, a JSON
/// string is decoded first, and anything else falls back to `toString()`.
/// Sensitive values are replaced with [redactedValue], and the result is
/// truncated to [maxLoggedPayloadLength].
String? describePayload(Object? data) {
  if (data == null) return null;

  final decoded = data is String ? _decodeJson(data) : data;
  if (decoded == null) return _truncate(data.toString());

  return _truncate(_pretty(decoded, 0));
}

/// Decodes a JSON string, or returns `null` when it is not JSON.
Object? _decodeJson(String value) {
  final trimmed = value.trim();
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return null;
  try {
    return jsonDecode(trimmed);
  } on FormatException {
    return null;
  }
}

/// Pretty-prints a decoded payload, redacting credentials on the way.
///
/// Written by hand rather than with `JsonEncoder` because payloads may carry
/// values that are not JSON-encodable (`Decimal`, for instance); those are
/// rendered through `toString()` instead of throwing.
String _pretty(Object? value, int indent) {
  final pad = ' ' * indent;
  final childPad = ' ' * (indent + 2);

  if (value is Map) {
    if (value.isEmpty) return '{}';
    final buffer = StringBuffer('{\n');
    var first = true;
    for (final entry in value.entries) {
      if (!first) buffer.write(',\n');
      first = false;
      final key = entry.key.toString();
      buffer
        ..write('$childPad"${_escape(key)}": ')
        ..write(
          isSensitiveKey(key)
              ? jsonEncode(redactedValue)
              : _pretty(entry.value, indent + 2),
        );
    }
    buffer.write('\n$pad}');
    return buffer.toString();
  }

  if (value is List) {
    if (value.isEmpty) return '[]';
    final buffer = StringBuffer('[\n');
    var first = true;
    for (final item in value) {
      if (!first) buffer.write(',\n');
      first = false;
      buffer
        ..write(childPad)
        ..write(_pretty(item, indent + 2));
    }
    buffer.write('\n$pad]');
    return buffer.toString();
  }

  if (value == null) return 'null';
  if (value is num || value is bool) return value.toString();
  if (value is String) return jsonEncode(value);
  return jsonEncode(value.toString());
}

/// Escapes a key for use inside a quoted JSON key, without the quotes.
String _escape(String value) {
  final encoded = jsonEncode(value);
  return encoded.substring(1, encoded.length - 1);
}

String _truncate(String value) {
  if (value.length <= maxLoggedPayloadLength) return value;
  return '${value.substring(0, maxLoggedPayloadLength)}… (truncated)';
}
