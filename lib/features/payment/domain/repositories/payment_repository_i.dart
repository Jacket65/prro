import 'package:prro/features/payment/data/models/payment_request.dart';
import 'package:prro/features/payment/data/models/payment_result.dart';
import 'package:prro/features/payment/data/models/payment_token.dart';

/// Repository interface for payment operations.
abstract interface class PaymentRepositoryI {
  /// Creates a payment token via the backend.
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request);

  /// Verifies a payment by transaction ID.
  Future<PaymentResult> verifyPayment(String transactionId);
}
