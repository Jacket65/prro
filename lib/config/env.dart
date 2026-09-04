import 'package:flutter/foundation.dart';

/// Environment configuration.
///
/// The API base URL is overridable at build time:
///   flutter run --dart-define=API_BASE_URL=http://pos.grainsworld.click/api/v1
/// Defaults to the local dev backend.
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://pos.coffeebeans.space.test/api/v1',
  );

  /// True when the build did not provide an explicit `API_BASE_URL`.
  /// In release builds this is asserted at startup so a missing define
  /// cannot silently point production at a dead `.test` host.
  static const bool _baseUrlOverridden = bool.hasEnvironment('API_BASE_URL');

  /// Store name shown on the printed receipt. The order-create response does
  /// not carry the outlet name yet, so we fall back to this constant.
  static const String storeName = 'Coffee Beans';

  /// Call once at startup to fail fast on a missing build-time URL in release.
  static void assertBaseUrlConfigured() {
    if (!_baseUrlOverridden && kReleaseMode) {
      throw StateError(
        'API_BASE_URL was not provided at build time. '
        'Pass --dart-define=API_BASE_URL=... when building for release.',
      );
    }
  }
}
