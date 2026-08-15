import 'package:injectable/injectable.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/payment/payment_request.dart';
import 'package:prro/data/api/models/payment/payment_result.dart';
import 'package:prro/data/api/models/payment/payment_token.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';

/// Mock implementation of [PaymentRepositoryI] for testing.
///
/// Transaction-based: each `createPaymentToken` mints a fresh transaction id
/// and stores the originating request in `_pendingTransactions`.
/// `verifyPayment` is the single source of truth and only succeeds for a
/// transaction that was actually created (and not yet consumed), mirroring how
/// the real backend owns payment state.
@LazySingleton(
  as: PaymentRepositoryI,
  env: [Environment.mock],
)
class PaymentRepositoryMock implements PaymentRepositoryI {
  PaymentRepositoryMock();

  final Map<String, CreatePaymentRequest> _pendingTransactions = {};
  PaymentResult? _lastResult;

  /// Id minted by the most recent [createPaymentToken] call. Tests read this to
  /// drive [verifyPayment] with the exact transaction id the mock produced.
  String? lastTransactionId;

  /// Last verification result, for assertions in tests.
  PaymentResult? get lastResult => _lastResult;

  @override
  Future<TerminalToken> createPaymentToken(CreatePaymentRequest request) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final transactionId = 'mock_txn_${uuidV4()}';
    _pendingTransactions[transactionId] = request;
    lastTransactionId = transactionId;

    // Return a mock token
    return TerminalToken(
      token: 'mock_jwt_$transactionId',
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
  }

  @override
  Future<PaymentResult> verifyPayment(String transactionId) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final request = _pendingTransactions[transactionId];
    if (request == null) {
      throw PaymentUnknownTransactionException(
        'No pending transaction for transactionId: $transactionId',
      );
    }

    // The backend verification is authoritative: success/amount/status come
    // solely from the verified transaction, never from the terminal callback.
    final result = PaymentResult(
      success: true,
      status: 'SUCCESS',
      rrn: '123456789012',
      amount: request.amount,
      transactionId: transactionId,
      cardMask: '5168 **** **** 1234',
      authCode: '123456',
    );

    // Consume the transaction so a duplicate verify throws (idempotent-by-
    // expiry: the real backend is naturally idempotent for a settled one).
    _pendingTransactions.remove(transactionId);
    _lastResult = result;
    return result;
  }
}

/// Thrown by `PaymentRepositoryMock` when `verifyPayment` is called with a
/// transaction id that was never created (or was already consumed).
///
/// This is a mock-only concern: the real backend's behavior for an unknown id
/// is undefined/backend-driven, so it is intentionally not part of the
/// `PaymentRepositoryI` contract.
class PaymentUnknownTransactionException implements Exception {
  const PaymentUnknownTransactionException(this.message);
  final String message;
  @override
  String toString() => 'PaymentUnknownTransactionException: $message';
}
