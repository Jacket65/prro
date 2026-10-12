import 'package:injectable/injectable.dart';
import 'package:prro/core/domain/order_history.dart';
import 'package:prro/core/domain/repositories/order_history_repository_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_outcome.dart';

/// Resolves the card order a previous session left unfinished.
///
/// The design is forced by what the backend actually offers: only `completed`
/// orders are listed, `POST /orders/{id}/confirm` 404s once the order's shift
/// is closed, there is no cancel/void route, and nothing can tell the client
/// whether money moved. So the app can neither rediscover a pending order on
/// its own nor ask the terminal about the charge. The only handle it has is the
/// record it wrote itself, which is what this use case consumes.
///
/// Consequences that are deliberate, not oversights:
///
/// * No re-charge is ever attempted. Re-charging to "make sure" would double a
///   payment that may already have succeeded; without charge↔order correlation
///   there is no way to tell. Only a confirm (idempotent, safe to repeat) is
///   offered.
/// * Nothing declares the charge state. The banner says the *order* is
///   unfinished, never that the card was or was not charged.
/// * Rejecting only clears the local record. The server-side order stays
///   `pending` and unfindable until a cancel/void route exists (B7); the seller
///   is told that in the confirmation.
///
/// All wording lives here, at the boundary that already owns the words the
/// seller reads.
@injectable
class FinishPendingOrderUseCase {
  FinishPendingOrderUseCase({
    required this._pendingOrderStore,
    required this._orderHistoryRepository,
    required this._ordersRepository,
  });

  final PendingOrderStoreI _pendingOrderStore;
  final OrderHistoryRepositoryI _orderHistoryRepository;
  final OrdersRepositoryI _ordersRepository;

  /// Reads the stored record and, when there is one, resolves what the server
  /// thinks of it.
  ///
  /// [PendingOrderAlreadySettled] is the case where the interrupted flow did
  /// finish before the process died, so the record is stale and dropped.
  Future<FinishPendingOrderOutcome> load() async {
    final pending = _pendingOrderStore.read();
    if (pending == null) return const NoPendingOrder();

    final OrderDetail detail;
    try {
      detail = await _orderHistoryRepository.getOrder(
        int.parse(pending.orderId),
      );
    } on Object {
      // The receipt is unreadable (offline, server error, an order the history
      // route no longer serves). The order is still unfinished, so offer the
      // actions with the amount unknown rather than pretending it is settled.
      return PendingOrderUnfinished(
        orderId: pending.orderId,
        idempotencyKey: pending.idempotencyKey,
        createdAt: pending.createdAt,
      );
    }

    if (detail.status == 'completed') {
      await _pendingOrderStore.clear();
      return const PendingOrderAlreadySettled('Оплату вже підтверджено.');
    }

    return PendingOrderUnfinished(
      orderId: pending.orderId,
      idempotencyKey: pending.idempotencyKey,
      createdAt: pending.createdAt,
      totalKopecks: detail.totalKopecks,
    );
  }

  /// Confirms the pending order (`POST /orders/{id}/confirm`), which is safe to
  /// repeat.
  ///
  /// 404 means the shift is closed and the record is cleared — nothing more can
  /// be done client-side. Every other failure keeps the record so the seller
  /// can retry.
  Future<FinishPendingOrderOutcome> confirm(PendingOrder pending) async {
    final orderId = int.tryParse(pending.orderId);
    if (orderId == null) {
      // Not a server-side id we could confirm; leaving the entry in place would
      // only ever reproduce this, so it is dropped and reported.
      await _pendingOrderStore.clear();
      return const PendingOrderConfirmFailed(
        'Не вдалося підтвердити оплату. Спробувати ще раз?',
      );
    }

    try {
      await _ordersRepository.confirmOrder(orderId);
      await _pendingOrderStore.clear();
      return const PendingOrderConfirmed('Оплату підтверджено.');
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await _pendingOrderStore.clear();
        return const PendingOrderShiftClosed(
          'Зміну закрито — зверніться до менеджера.',
        );
      }
      return const PendingOrderConfirmFailed(
        'Не вдалося підтвердити оплату. Спробувати ще раз?',
      );
    } on Object {
      return const PendingOrderConfirmFailed(
        'Не вдалося підтвердити оплату. Спробувати ще раз?',
      );
    }
  }

  /// Rejects the pending order: the local record is dropped and nothing else
  /// happens. The server-side order stays `pending` and unfindable (B7), which
  /// the caller must say before calling.
  Future<void> reject() => _pendingOrderStore.clear();
}
