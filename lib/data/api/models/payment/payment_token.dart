import 'package:meta/meta.dart';

/// Terminal token response from backend.
///
/// Contains the JWT token used to launch the PrivatBank NFC POS Terminal
/// and its expiration timestamp.
@immutable
class TerminalToken {
  const TerminalToken({
    required this.token,
    required this.expiresAt,
  });

  factory TerminalToken.fromJson(Map<String, dynamic> json) {
    return TerminalToken(
      token: (json['token'] ?? '').toString(),
      expiresAt:
          DateTime.tryParse((json['expires'] ?? '').toString()) ??
          DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  /// JWT token for the PrivatBank Terminal.
  final String token;

  /// Token expiration date/time.
  final DateTime expiresAt;

  Map<String, dynamic> toJson() => {
    'token': token,
    'expires': expiresAt.toIso8601String(),
  };

  @override
  String toString() =>
      'TerminalToken(token: ${token.substring(0, 10)}..., '
      'expiresAt: $expiresAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerminalToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          expiresAt == other.expiresAt;

  @override
  int get hashCode => token.hashCode ^ expiresAt.hashCode;
}
