import 'package:meta/meta.dart';

/// Payment verification result from backend.
///
/// Contains the final payment status after the customer completes
/// the transaction in the PrivatBank Terminal.
@immutable
class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.status,
    this.rrn,
    this.amount,
    this.transactionId,
    this.cardMask,
    this.authCode,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      success: json['success'] == true,
      status: (json['status'] ?? '').toString(),
      rrn: json['rrn']?.toString(),
      amount: json['amount'] != null
          ? int.tryParse(json['amount'].toString())
          : null,
      transactionId: json['transaction_id']?.toString(),
      cardMask: json['card_mask']?.toString(),
      authCode: json['auth_code']?.toString(),
    );
  }

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

  Map<String, dynamic> toJson() => {
    'success': success,
    'status': status,
    if (rrn != null) 'rrn': rrn,
    if (amount != null) 'amount': amount,
    if (transactionId != null) 'transaction_id': transactionId,
    if (cardMask != null) 'card_mask': cardMask,
    if (authCode != null) 'auth_code': authCode,
  };

  @override
  String toString() =>
      'PaymentResult(success: $success, status: $status, '
      'rrn: $rrn, amount: $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResult &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          status == other.status &&
          rrn == other.rrn &&
          amount == other.amount &&
          transactionId == other.transactionId &&
          cardMask == other.cardMask &&
          authCode == other.authCode;

  @override
  int get hashCode =>
      success.hashCode ^
      status.hashCode ^
      rrn.hashCode ^
      amount.hashCode ^
      transactionId.hashCode ^
      cardMask.hashCode ^
      authCode.hashCode;
}
