import 'package:injectable/injectable.dart';
import 'package:prro/core/domain/order.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/payment/domain/payment_exceptions.dart';
import 'package:prro/features/seller/domain/payment/handlers/cash_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/handlers/terminal_payment_handler.dart';
import 'package:prro/features/seller/domain/payment/pay_order_request.dart';
import 'package:prro/features/seller/domain/payment/payment_method_handler.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_use_case.dart'
    show FinishPendingOrderUseCase;
import 'package:talker/talker.dart';

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
/// That makes it the only place a repository failure can still become words the
/// seller reads — a message thrown from a repository is discarded by the
/// catch-all below, so repositories report facts (see [ShiftClosedException])
/// and the wording lives here.
///
/// It also owns the interrupted-card-order record: a terminal order that is
/// placed but not yet confirmed must survive the process dying, or the sale is
/// unreachable from the app's side afterwards (see
/// [FinishPendingOrderUseCase] for why the client cannot recover it any other
/// way).
@injectable
class PayOrderUseCase {
  PayOrderUseCase({
    required this._ordersRepository,
    required this._pendingOrderStore,
    required CashPaymentHandler cash,
    required TerminalPaymentHandler terminal,
    required this._talker,
  }) : _handlers = [cash, terminal];

  final OrdersRepositoryI _ordersRepository;
  final PendingOrderStoreI _pendingOrderStore;
  final List<PaymentMethodHandler> _handlers;
  final Talker _talker;

  /// The handler for the currently in-flight payment, or `null` when idle.
  PaymentMethodHandler? _activeHandler;

  Future<OrderReceipt> call(PayOrderRequest request) async {
    final handler = _handlers.firstWhere(
      (h) => h.method == request.method,
      orElse: () => throw const PaymentException('Невідомий спосіб оплати.'),
    );

    _activeHandler = handler;
    try {
      final paymentRequest = PaymentRequest(
        amountKopecks: kopecksFromDecimal(_ordersRepository.totalPrice),
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
      } on ShiftClosedException {
        // The shift was closed elsewhere: say what to do about it, and note
        // that no money moved — for a card order the charge only runs in
        // [PaymentMethodHandler.afterOrderCreated], which never happened. The
        // freshly-created order is not recorded either, because a shift that is
        // closed will 404 its confirm anyway.
        throw const PaymentException(
          'Зміну закрито — відкрийте зміну, щоб продавати.',
          reason: PaymentFailureReason.verificationFailed,
        );
      } on Object catch (e, st) {
        throw PaymentException(
          'Не вдалося оформити замовлення.',
          reason: PaymentFailureReason.verificationFailed,
          cause: e,
          stackTrace: st,
        );
      }

      // The order exists server-side; only the payment is unfinished. A card
      // order stays `pending` until confirmed, so this is the moment a process
      // death would make the sale unreachable from the app's side — record it
      // before anything else can fail.
      if (request.method == PaymentMethod.terminal &&
          order.status != 'completed') {
        await _rememberPendingOrder(order, request);
      }

      try {
        final receipt = await handler.afterOrderCreated(order, paymentRequest);
        // A confirmed order needs no resume offer. A terminal flow that failed
        // to confirm returns the pending receipt (the handler prefers that
        // over failing a paid sale), which is exactly the case the record was
        // written for — so it is kept, deliberately.
        if (receipt.status == 'completed') {
          await _pendingOrderStore.clear();
        }
        return receipt;
      } on PaymentCancelledException {
        // The one failure that means money demonstrably did not move, so
        // there is nothing to resume. Leaving the record behind would offer to
        // confirm an order that was never charged — and since cancellation
        // keeps the cart, the next attempt is a fresh order, so order #1 would
        // sit `pending` with a live "finish me" offer for a sale with no
        // payment behind it.
        try {
          await _pendingOrderStore.clear();
        } on Object catch (e) {
          // Never mask the cancellation behind a storage failure.
          _talker.warning(
            '[PAYMENT] pending order not cleared on cancel: $e',
          );
        }
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

  /// Writes the interrupted-card-order record. Best-effort on purpose: the
  /// order is already recorded server-side and the charge has not started, so
  /// failing the sale here would leave an order the client can neither confirm
  /// nor find. Losing the record is the lesser of the two failures, so it is
  /// logged for diagnosis instead of thrown.
  Future<void> _rememberPendingOrder(
    OrderReceipt order,
    PayOrderRequest request,
  ) async {
    try {
      await _pendingOrderStore.save(
        orderId: order.orderId,
        idempotencyKey: request.idempotencyKey,
      );
    } on Object catch (e) {
      _talker.warning(
        '[PAYMENT] could not record the pending card order '
        '${order.orderId}: $e',
      );
    }
  }

  /// Cancels the in-flight payment, if any. Delegates to the active handler
  /// (a no-op for cash; terminates the terminal session while the charge is in
  /// flight). Safe to call when no payment is active.
  void cancel() => _activeHandler?.cancel();
}
