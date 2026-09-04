abstract interface class TokenStorageI {
  Future<void> saveSession({required String accessToken, String? refreshToken});

  Future<void> saveAccessToken(String accessToken);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clear();

  Future<bool> hasValidSession();
}
