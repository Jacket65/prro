import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';

/// Repository interface for payment operations.
abstract interface class PaymentRepositoryI {
  /// Creates a payment token via the backend.
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request);

  /// Verifies a payment by transaction ID.
  Future<PaymentResult> verifyPayment(String transactionId);
}
