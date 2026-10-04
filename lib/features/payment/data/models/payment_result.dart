import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'payment_result.freezed.dart';

/// Payment verification result from backend.
///
/// Contains the final payment status after the customer completes
/// the transaction in the PrivatBank Terminal.
///
/// Decoding stays hand-written, as in `payment_token.dart`: every field maps
/// 1:1 through a shared tolerant reader, so a generated factory would only add
/// a `CheckedFromJsonException` path the hand-written shape does not have.
@Freezed(toJson: false)
class PaymentResult with _$PaymentResult {
  const PaymentResult({
    required this.success,
    required this.status,
    this.rrn,
    this.amount,
    this.transactionId,
    this.cardMask,
    this.authCode,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) => PaymentResult(
    success: boolOrFalse(json['success']),
    status: stringOrEmpty(json['status']),
    rrn: stringOrNull(json['rrn']),
    amount: parseNullableInt(json['amount']),
    transactionId: stringOrNull(json['transaction_id']),
    cardMask: stringOrNull(json['card_mask']),
    authCode: stringOrNull(json['auth_code']),
  );

  /// Whether the payment was successful.
  final bool success;

  /// Payment status string (e.g., 'SUCCESS', 'FAILED', 'CANCELLED').
  final String status;

  /// Retrieval Reference Number from the acquirer.
  final String? rrn;

  /// Payment amount in kopecks.
  final int? amount;

  /// Transaction ID from the terminal.
  final String? transactionId;

  /// Masked card number (e.g., '5168 **** **** 1234').
  final String? cardMask;

  /// Authorization code from the acquirer.
  final String? authCode;
}
