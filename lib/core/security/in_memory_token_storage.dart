import 'package:injectable/injectable.dart';
import 'package:prro/core/security/token_storage_i.dart';

@Environment('mock')
@Singleton(as: TokenStorageI)
class InMemoryTokenStorage implements TokenStorageI {
  final Map<String, String> _store = {};

  static const _keyAccessToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';

  @override
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
  }) async {
    _store[_keyAccessToken] = accessToken;
    if (refreshToken != null) {
      _store[_keyRefreshToken] = refreshToken;
    }
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    _store[_keyAccessToken] = accessToken;
  }

  @override
  Future<String?> getAccessToken() async => _store[_keyAccessToken];

  @override
  Future<String?> getRefreshToken() async => _store[_keyRefreshToken];

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<bool> hasValidSession() async {
    final token = _store[_keyAccessToken];
    return token != null && token.isNotEmpty;
  }
}
