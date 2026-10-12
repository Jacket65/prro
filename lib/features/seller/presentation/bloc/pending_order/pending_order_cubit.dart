import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_outcome.dart';
import 'package:prro/features/seller/domain/usecases/finish_pending_order_use_case.dart';
import 'package:prro/features/seller/presentation/bloc/pending_order/finish_pending_order_state.dart';

/// Drives the resume banner for a card order a previous session left
/// unfinished.
///
/// A single instance is owned by `SellerScreen`, not by the banner widget: the
/// banner has to be visible in two scopes (the check column while a shift is
/// open, and the open-shift gate when it is not) and two instances would run
/// the same resolution twice.
class PendingOrderCubit extends Cubit<PendingOrderState> {
  PendingOrderCubit(this._finishPendingOrder, this._pendingOrderStore)
    : super(const PendingOrderHidden());

  final FinishPendingOrderUseCase _finishPendingOrder;
  final PendingOrderStoreI _pendingOrderStore;

  /// What [load] learned about the pending order.
  ///
  /// Kept so a failed confirm can put the banner back exactly as it was: the
  /// use case reports *that* the confirm failed, not the order it failed on,
  /// and re-reading the amount would mean another round-trip for a value that
  /// has not changed.
  PendingOrderUnfinished? _unfinished;

  /// Resolves what the stored record refers to. Call once on screen entry.
  Future<void> load() async {
    final pending = _pendingOrderStore.read();
    if (pending == null) {
      _unfinished = null;
      emit(const PendingOrderHidden());
      return;
    }

    emit(const PendingOrderResolving());
    final outcome = await _finishPendingOrder.load();
    if (isClosed) return;

    switch (outcome) {
      case NoPendingOrder():
        _unfinished = null;
        emit(const PendingOrderHidden());
      case PendingOrderAlreadySettled(:final message):
        _unfinished = null;
        emit(PendingOrderNotice(message));
      case PendingOrderUnfinished(:final totalKopecks):
        _unfinished = outcome;
        emit(
          PendingOrderReady(
            orderId: pending.orderId,
            totalKopecks: totalKopecks,
            createdAt: pending.createdAt,
          ),
        );
      // Confirm outcomes are produced only by confirm(); load never sees them.
      case PendingOrderConfirmed() ||
      PendingOrderShiftClosed() ||
      PendingOrderConfirmFailed():
        break;
    }
  }

  /// Confirms the pending order. The record is only cleared by the use case
  /// when the answer is final, so a failure keeps the entry and the actions
  /// that retry it.
  Future<void> confirm() async {
    final pending = _pendingOrderStore.read();
    if (pending == null) return;
    if (state is PendingOrderResolving) return;

    emit(const PendingOrderResolving());
    final outcome = await _finishPendingOrder.confirm(pending);
    if (isClosed) return;

    switch (outcome) {
      case PendingOrderConfirmed(:final message) ||
          PendingOrderShiftClosed(:final message):
        _unfinished = null;
        emit(PendingOrderNotice(message));
      case PendingOrderConfirmFailed(:final message):
        // The record survives, so the banner and its actions come back.
        final unfinished = _unfinished;
        emit(
          PendingOrderReady(
            orderId: pending.orderId,
            createdAt: pending.createdAt,
            totalKopecks: unfinished?.totalKopecks,
            message: message,
          ),
        );
      // load() is the only producer of the remaining three.
      case NoPendingOrder() ||
          PendingOrderAlreadySettled() ||
          PendingOrderUnfinished():
        break;
    }
  }

  /// Rejects the pending order locally. The server-side order stays pending
  /// and unfindable — the caller asks the seller about that first.
  Future<void> reject() async {
    await _finishPendingOrder.reject();
    if (isClosed) return;
    _unfinished = null;
    emit(const PendingOrderHidden());
  }

  /// Dismisses a notice that has been read.
  void dismissNotice() {
    _unfinished = null;
    emit(const PendingOrderHidden());
  }
}
