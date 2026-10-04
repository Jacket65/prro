import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'payment_token.freezed.dart';

/// Terminal token response from backend.
///
/// Contains the JWT token used to launch the PrivatBank POS Terminal
/// and its expiration timestamp.
///
/// Mixed mode (`class` with a plain constructor) rather than the
/// `const factory X(...) = _X` redirection is load-bearing here: in redirected
/// mode freezed generates a subclass that only *implements* this interface,
/// so a hand-written [toString] would be silently dropped and every log line
/// would print the JWT in full.
@Freezed(toJson: false)
class TerminalToken with _$TerminalToken {
  const TerminalToken({required this.token, required this.expiresAt});

  /// Decoding stays hand-written — a generated factory cannot express a
  /// clock-dependent fallback, and both fields go through the shared tolerant
  /// readers in `core/utils/json.dart` instead.
  factory TerminalToken.fromJson(Map<String, dynamic> json) => TerminalToken(
    token: stringOrEmpty(json['token']),
    // A missing or unparseable `expires` leaves the terminal the ten-minute
    // window the backend grants, so a bad timestamp degrades to "still valid"
    // rather than "already expired".
    expiresAt: parseLocalDateTime(
      json['expires'],
      fallback: DateTime.now().add(const Duration(minutes: 10)),
    ),
  );

  /// JWT token for the PrivatBank Terminal.
  final String token;

  /// Token expiration date/time.
  final DateTime expiresAt;

  /// Truncating on purpose: [token] is a bearer credential and must not reach a
  /// log line in full. freezed detects this override and generates none.
  @override
  String toString() =>
      'TerminalToken(token: ${token.substring(0, 10)}..., '
      'expiresAt: $expiresAt)';
}
