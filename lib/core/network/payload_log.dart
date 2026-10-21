import 'dart:convert';

const int maxLoggedPayloadLength = 4000;
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
  return _sensitiveKeys.contains(normalized) ||
      _sensitiveKeyFragments.any(normalized.contains);
}

String? describePayload(Object? data) {
  if (data == null) return null;

  final decoded = data is String ? _decodeJson(data) : data;
  if (decoded == null) return _truncate(data.toString());

  final redactedData = _redact(decoded);
  // A value the encoder cannot handle (a Decimal, say) must not break the
  // request that is being logged, so it is rendered through toString().
  const encoder = JsonEncoder.withIndent('  ', _toEncodable);

  return _truncate(encoder.convert(redactedData));
}

Object? _toEncodable(Object? object) => object.toString();

Object? _decodeJson(String value) {
  final trimmed = value.trim();
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return null;
  try {
    return jsonDecode(trimmed);
  } on FormatException {
    return null;
  }
}

Object? _redact(Object? value) {
  if (value is Map) {
    return value.map((k, v) {
      final keyStr = k.toString();
      return MapEntry(k, isSensitiveKey(keyStr) ? redactedValue : _redact(v));
    });
  }
  if (value is List) {
    return value.map(_redact).toList();
  }
  return value;
}

String _truncate(String value) {
  if (value.length <= maxLoggedPayloadLength) return value;
  return '${value.substring(0, maxLoggedPayloadLength)}… (truncated)';
}
