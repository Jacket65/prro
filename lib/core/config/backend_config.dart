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

  /// The release rule, as a pure function so it can be unit-tested.
  ///
  /// Deliberately checks the resolved *value*, not whether the define was
  /// passed: `backendType` falls back to `'mock'`, so asserting on presence
  /// alone would let an explicit `--dart-define=BACKEND_TYPE=mock` ship the
  /// mock bindings (`MockApiClient` and every `*RepositoryMock`) in a release
  /// APK.
  static bool isReleaseSafe({
    required String type,
    required bool isRelease,
  }) =>
      !isRelease || type == 'real';

  /// Call once at startup to fail fast on a non-production backend type in
  /// release: without `--dart-define=BACKEND_TYPE=real` the mock bindings win.
  static void assertBackendTypeConfigured() {
    if (!isReleaseSafe(type: backendType, isRelease: kReleaseMode)) {
      throw StateError(
        'BACKEND_TYPE=real is required in release, got "$backendType". '
        'Pass --dart-define=BACKEND_TYPE=real when building for release.',
      );
    }
  }
}
