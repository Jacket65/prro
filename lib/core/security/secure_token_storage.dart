import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/security/token_storage_i.dart';

@Environment('prod')
@Singleton(as: TokenStorageI)
class SecureTokenStorage implements TokenStorageI {
  SecureTokenStorage() : _secureStorage = const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  static const _keyAccessToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';

  final Map<String, String> _cache = {};

  Future<void> _ensureCache() async {
    if (_cache.isEmpty) {
      final access = await _secureStorage.read(key: _keyAccessToken);
      final refresh = await _secureStorage.read(key: _keyRefreshToken);
      if (access != null) _cache[_keyAccessToken] = access;
      if (refresh != null) _cache[_keyRefreshToken] = refresh;
    }
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
  }) async {
    _cache[_keyAccessToken] = accessToken;
    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    if (refreshToken != null) {
      _cache[_keyRefreshToken] = refreshToken;
      await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    _cache[_keyAccessToken] = accessToken;
    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
  }

  @override
  Future<String?> getAccessToken() async {
    await _ensureCache();
    return _cache[_keyAccessToken];
  }

  @override
  Future<String?> getRefreshToken() async {
    await _ensureCache();
    return _cache[_keyRefreshToken];
  }

  @override
  Future<void> clear() async {
    _cache.clear();
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  @override
  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
