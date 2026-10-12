import 'dart:convert';

/// Whether a stored access token is usable, from its `exp` claim alone.
enum AccessTokenExpiry {
  /// The token carries an `exp` claim that is still in the future (allowing
  /// for [checkAccessTokenExpiry]'s skew).
  valid,

  /// The token carries an `exp` claim that has passed (allowing for skew).
  expired,

  /// The expiry could not be established: not a JWT, no `exp` claim, or an
  /// unparsable payload. Callers must treat this as "expiry unknown" and fall
  /// back to their own validity rule (presence), never as [expired].
  unknown,
}

/// Reads the `exp` claim of a JWT access token and classifies it.
///
/// Used at session restore so an expired token cannot re-enter a guarded
/// route: the app then behaves as if there were no session at all
/// ([AuthUnauthenticated(noSession)]) instead of letting the first request
/// 401 and tear the session down mid-navigation.
///
/// Deliberately dependency-free: the payload is base64url-decoded and read with
/// `jsonDecode`; the signature is **not** verified (the token was issued by the
/// server this client talks to, and verifying it here would need the key).
/// A token that is not a parsable JWT (mock tokens such as
/// `mock_token_123…`, or a token whose `exp` is missing) yields
/// [AccessTokenExpiry.unknown] so non-JWT environments keep working exactly as
/// before.
///
/// [now] is injectable for tests.
AccessTokenExpiry checkAccessTokenExpiry(
  String token, {
  DateTime? now,
}) {
  // A JWT is exactly three base64url segments: header.payload.signature.
  final segments = token.split('.');
  if (segments.length != 3 || segments[1].isEmpty) {
    return AccessTokenExpiry.unknown;
  }

  final Map<String, dynamic> claims;
  try {
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(segments[1])),
    );
    final decoded = jsonDecode(payload);
    if (decoded is! Map<String, dynamic>) return AccessTokenExpiry.unknown;
    claims = decoded;
  } on Object {
    // Malformed base64 or non-JSON payload — the expiry is simply unknown.
    return AccessTokenExpiry.unknown;
  }

  final exp = claims['exp'];
  if (exp is! num) return AccessTokenExpiry.unknown;

  final expAt = DateTime.fromMillisecondsSinceEpoch(
    (exp * 1000).round(),
    isUtc: true,
  );
  // 30 s of slack absorbs clock drift between device and server, so a token
  // that is about to expire is treated as expired rather than usable.
  const skew = Duration(seconds: 30);
  final nowUtc = (now ?? DateTime.now()).toUtc();
  return nowUtc.isAfter(expAt.subtract(skew))
      ? AccessTokenExpiry.expired
      : AccessTokenExpiry.valid;
}
