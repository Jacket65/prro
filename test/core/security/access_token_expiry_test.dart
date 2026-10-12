import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/security/access_token_expiry.dart';

/// Builds an unsigned JWT-shaped token with the given claims.
String _jwt(Map<String, dynamic> claims) {
  String segment(Map<String, dynamic> map) =>
      base64Url.encode(utf8.encode(jsonEncode(map))).replaceAll('=', '');
  return '${segment({'alg': 'HS256', 'typ': 'JWT'})}.${segment(claims)}.sig';
}

/// `exp` is seconds since the epoch.
String _jwtExp(DateTime at) => _jwt({
  'exp': at.millisecondsSinceEpoch ~/ 1000,
});

void main() {
  final now = DateTime.utc(2026, 1, 1, 12);

  group('checkAccessTokenExpiry', () {
    test('a token expiring in the future is valid', () {
      expect(
        checkAccessTokenExpiry(
          _jwtExp(now.add(const Duration(hours: 1))),
          now: now,
        ),
        AccessTokenExpiry.valid,
      );
    });

    test('a token whose exp has passed is expired', () {
      expect(
        checkAccessTokenExpiry(
          _jwtExp(now.subtract(const Duration(seconds: 1))),
          now: now,
        ),
        AccessTokenExpiry.expired,
      );
    });

    test('a token expiring within the skew is expired', () {
      expect(
        checkAccessTokenExpiry(
          _jwtExp(now.add(const Duration(seconds: 29))),
          now: now,
        ),
        AccessTokenExpiry.expired,
      );
    });

    test('a token expiring just past the skew boundary is valid', () {
      expect(
        checkAccessTokenExpiry(
          _jwtExp(now.add(const Duration(seconds: 31))),
          now: now,
        ),
        AccessTokenExpiry.valid,
      );
    });

    test('a local (non-UTC) now is compared against the UTC exp', () {
      expect(
        checkAccessTokenExpiry(
          _jwtExp(now.add(const Duration(hours: 1))),
          now: now.toLocal(),
        ),
        AccessTokenExpiry.valid,
      );
    });

    test('a token with no exp claim is unknown', () {
      final token = _jwt({'sub': 'cashier', 'iat': 1767000000});

      expect(
        checkAccessTokenExpiry(token, now: now),
        AccessTokenExpiry.unknown,
      );
    });

    test('a token with a non-numeric exp claim is unknown', () {
      final token = _jwt({'exp': 'never'});

      expect(
        checkAccessTokenExpiry(token, now: now),
        AccessTokenExpiry.unknown,
      );
    });

    test('a non-JWT token (mock tokens, opaque strings) is unknown', () {
      expect(
        checkAccessTokenExpiry('mock_token_1767000000000', now: now),
        AccessTokenExpiry.unknown,
      );
      expect(
        checkAccessTokenExpiry('a.b', now: now),
        AccessTokenExpiry.unknown,
      );
    });

    test('a token with a malformed payload segment is unknown', () {
      expect(
        checkAccessTokenExpiry('header.!!!not-base64!!!.sig', now: now),
        AccessTokenExpiry.unknown,
      );
      expect(
        checkAccessTokenExpiry(
          'header.${base64Url.encode(utf8.encode('"a string"'))}.sig',
          now: now,
        ),
        AccessTokenExpiry.unknown,
      );
    });

    test('an empty token is unknown', () {
      expect(checkAccessTokenExpiry('', now: now), AccessTokenExpiry.unknown);
    });
  });
}
