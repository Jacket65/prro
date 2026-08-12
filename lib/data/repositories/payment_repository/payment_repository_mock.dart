import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';

/// Mock implementation of [PaymentRepositoryI] for testing.
@LazySingleton(
  as: PaymentRepositoryI,
  env: [Environment.mock],
)
class PaymentRepositoryMock implements PaymentRepositoryI {
  PaymentRepositoryMock();

  CreatePaymentRequest? _lastRequest;
  PaymentResult? _lastResult;

  CreatePaymentRequest? get lastRequest => _lastRequest;
  PaymentResult? get lastResult => _lastResult;

  @override
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) async {
    _lastRequest = request;
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Return a mock token
    return TerminalToken(
      token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // Return a successful mock result
    final result = PaymentResult(
      success: true,
      status: 'SUCCESS',
      rrn: '123456789012',
      amount: _lastRequest?.amount,
      transactionId: transactionId,
      cardMask: '5168 **** **** 1234',
      authCode: '123456',
    );
    _lastResult = result;
    return result;
  }
}
