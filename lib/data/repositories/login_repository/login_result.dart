class LoginResult {
  const LoginResult({
    required this.accessToken,
    this.refreshToken,
    this.role,
    this.userId,
    this.outletId,
  });

  final String accessToken;
  final String? refreshToken;
  final String? role;
  final int? userId;
  final int? outletId;
}
