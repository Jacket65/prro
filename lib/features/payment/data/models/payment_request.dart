import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_request.freezed.dart';
part 'payment_request.g.dart';

/// Request to create a payment token.
///
/// Sent to the backend which signs the request and calls PrivatBank
/// to obtain a JWT token for the NFC POS Terminal.
@freezed
abstract class CreatePaymentRequest with _$CreatePaymentRequest {
  const factory CreatePaymentRequest({
    /// Payment amount in kopecks (1/100 of currency unit).
    required int amount,

    /// Currency code (e.g., 'UAH').
    required String currency,

    /// Payment description shown to the customer.
    required String description,

    /// Optional order ID to associate with this payment.
    @JsonKey(name: 'order_id') String? orderId,

    /// Optional additional metadata.
    Map<String, dynamic>? metadata,
  }) = _CreatePaymentRequest;

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestFromJson(json);
}
