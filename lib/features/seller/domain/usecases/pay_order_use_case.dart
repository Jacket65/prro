import 'package:injectable/injectable.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';
import 'package:prro/features/seller/domain/payment/handlers/cash_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/handlers/terminal_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/pay_order_request.dart';
import 'package:prro/features/seller/domain/payment/payment_method_handler.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';

/// Coordinates a single payment: picks the [PaymentMethodHandler] for the
/// requested method, runs its method-specific [PaymentMethodHandler.pay],
/// places the order via [OrdersRepositoryI.placeOrder], then finalizes through
/// [PaymentMethodHandler.afterOrderCreated] (identity for cash; terminal
/// charge + confirm for [PaymentMethod.terminal]).
///
/// Owns the single `_activeHandler` so an in-flight payment can be cancelled
/// through [cancel]. The handler is always cleared in a `try/finally` so a
/// stale cancel can never reach a completed (or future) payment session.
///
/// This use case is the final boundary before the UI/bloc: any failure from
/// `placeOrder` or the handler hooks is translated into [PaymentException] so
/// the bloc only ever sees [PaymentException] or [PaymentCancelledException].
@injectable
class PayOrderUseCase {
  PayOrderUseCase({
    required this._ordersRepository,
    required CashPaymentHandler cash,
    required TerminalPaymentHandler terminal,
  }) : _handlers = [cash, terminal];

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
      final paymentRequest = PaymentRequest(
        amountKopecks: uahToKopecks(_ordersRepository.totalPrice),
        tenderedKopecks: request.tenderedKopecks,
        currency: 'UAH',
      );
      await handler.pay(paymentRequest);

      final OrderReceipt order;
      try {
        order = await _ordersRepository.placeOrder(
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

      try {
        return await handler.afterOrderCreated(order, paymentRequest);
      } on PaymentCancelledException {
        rethrow;
      } on PaymentException {
        rethrow;
      } on Object catch (e, st) {
        throw PaymentException(
          'Не вдалося завершити оплату.',
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
  /// (a no-op for cash; terminates the terminal session while the charge is in
  /// flight). Safe to call when no payment is active.
  void cancel() => _activeHandler?.cancel();
}
