/// Environment configuration.
///
/// The API base URL is overridable at build time:
///   flutter run --dart-define=API_BASE_URL=http://pos.grainsworld.click/api/v1
/// Defaults to the local dev backend.
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://pos.coffeebeans.space/api/v1',
  );

  /// Store name shown on the printed receipt. The order-create response does
  /// not carry the outlet name yet, so we fall back to this constant.
  static const String storeName = 'Coffee Beans';
}
