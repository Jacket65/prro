import 'package:flutter/foundation.dart';

/// Backend configuration for the application.
/// Determines whether to use real API or mock backend.
class BackendConfig {
  BackendConfig._();

  /// Type of backend to use: 'real' or 'mock'
  static const String backendType = String.fromEnvironment(
    'BACKEND_TYPE',
    defaultValue: 'mock',
  );

  /// Whether to use mock backend
  static bool get useMock => backendType == 'mock';

  /// True when the build did not provide an explicit `BACKEND_TYPE`.
  static const bool _backendTypeOverridden = bool.hasEnvironment(
    'BACKEND_TYPE',
  );

  /// Call once at startup to fail fast on a missing build-time backend type in
  /// release: without the define [backendType] falls back to `mock`, so a
  /// release APK could silently ship against `MockApiClient`.
  static void assertBackendTypeConfigured() {
    if (!_backendTypeOverridden && kReleaseMode) {
      throw StateError(
        'BACKEND_TYPE was not provided at build time. '
        'Pass --dart-define=BACKEND_TYPE=real when building for release.',
      );
    }
  }
}
