/// Backend configuration for the application.
/// Determines whether to use real API or mock backend.
class BackendConfig {
  BackendConfig._();

  /// Type of backend to use: 'real' or 'mock'
  static const String backendType = String.fromEnvironment(
    'BACKEND_TYPE',
    defaultValue: 'real',
  );

  /// Whether to use mock backend
  static bool get useMock => backendType == 'mock';

  /// Whether to use real backend
  static bool get useReal => backendType == 'real';
}
