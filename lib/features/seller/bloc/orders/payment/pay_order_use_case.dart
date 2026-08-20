import 'package:injectable/injectable.dart';
import 'package:prro/core/money.dart';
import 'package:prro/data/api/models/models.dart';
import 'package:prro/data/repositories/orders_repository/orders_repository.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/card_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/cash_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/handlers/nfc_payment_handler.dart';
import 'package:prro/features/seller/bloc/orders/payment/pay_order_request.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_exceptions.dart';
import 'package:prro/features/seller/bloc/orders/payment/payment_method_handler.dart';

/// Coordinates a single payment: picks the [PaymentMethodHandler] for the
/// requested method, runs its method-specific [PaymentMethodHandler.pay], then
/// places the order via [OrdersRepositoryI.placeOrder].
///
/// Owns the single `_activeHandler` so an in-flight payment can be cancelled
/// through [cancel]. The handler is always cleared in a `try/finally` so a
/// stale cancel can never reach a completed (or future) payment session.
///
/// This use case is the final boundary before the UI/bloc: any failure from
/// `placeOrder` (the actual charge for cash/card, and the order record for
/// NFC) is translated into [PaymentException] so the bloc only ever sees
/// [PaymentException] or [PaymentCancelledException].
@injectable
class PayOrderUseCase {
  PayOrderUseCase({
    required this._ordersRepository,
    required CashPaymentHandler cash,
    required CardPaymentHandler card,
    required NfcPaymentHandler nfc,
  })  : _handlers = [cash, card, nfc];

  final OrdersRepositoryI _ordersRepository;
  final List<PaymentMethodHandler> _handlers;

  /// The handler for the currently in-flight payment, or `null` when idle.
  PaymentMethodHandler? _activeHandler;

  Future<OrderReceipt> call(PayOrderRequest request) async {
    final handler = _handlers.firstWhere(
      (h) => h.method == request.method,
      orElse: () => throw const PaymentException(
        'Невідомий спосіб оплати.',
      ),
    );

    _activeHandler = handler;
    try {
      await handler.pay(
        PaymentRequest(
          amountKopecks: uahToKopecks(_ordersRepository.totalPrice),
          tenderedKopecks: request.tenderedKopecks,
          currency: 'UAH',
        ),
      );
      try {
        return await _ordersRepository.placeOrder(
          method: request.method,
          tenderedKopecks: request.tenderedKopecks,
          idempotencyKey: request.idempotencyKey,
        );
      } on PaymentCancelledException {
        rethrow;
      } on PaymentException {
        rethrow;
      } on Object catch (e, st) {
        throw PaymentException(
          'Не вдалося оформити замовлення.',
          reason: PaymentFailureReason.verificationFailed,
          cause: e,
          stackTrace: st,
        );
      }
    } finally {
      _activeHandler = null;
    }
  }

  /// Cancels the in-flight payment, if any. Delegates to the active handler
  /// (a no-op for cash/card; terminates the NFC terminal session otherwise).
  /// Safe to call when no payment is active.
  void cancel() => _activeHandler?.cancel();
}
