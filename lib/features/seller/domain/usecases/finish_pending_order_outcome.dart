import 'package:freezed_annotation/freezed_annotation.dart';

part 'finish_pending_order_outcome.freezed.dart';

/// What FinishPendingOrderUseCase found or did about the pending card order.
///
/// A sealed union rather than a status enum so each case carries exactly what
/// the resume UI needs, and so an exhaustive `switch` over the result cannot
/// silently forget a case.
sealed class FinishPendingOrderOutcome {
  const FinishPendingOrderOutcome();
}

/// Nothing is pending — there is no order to finish or to say anything about.
@Freezed(toJson: false)
class NoPendingOrder extends FinishPendingOrderOutcome
    with _$NoPendingOrder {
  const NoPendingOrder();
}

/// The stored order is already `completed` server-side: the record was dropped,
/// because the charge and the confirm both landed before the app died.
@Freezed(toJson: false)
class PendingOrderAlreadySettled extends FinishPendingOrderOutcome
    with _$PendingOrderAlreadySettled {
  const PendingOrderAlreadySettled(this.message);

  /// Wording owned here, at the boundary the rest of the app already treats as
  /// the single source of words (see PayOrderUseCase).
  final String message;
}

/// An unfinished card order the seller can finish or reject.
///
/// [totalKopecks] is `null` when the receipt could not be read — the order is
/// still unfinished and still resolvable, only the amount is unknown, so the
/// banner must not invent one.
@Freezed(toJson: false)
class PendingOrderUnfinished extends FinishPendingOrderOutcome
    with _$PendingOrderUnfinished {
  const PendingOrderUnfinished({
    required this.orderId,
    required this.idempotencyKey,
    required this.createdAt,
    this.totalKopecks,
  });

  final String orderId;

  /// The key the order was placed with; kept identical on any re-placement so
  /// the backend resolves it to the same order instead of a new one.
  final String idempotencyKey;

  final DateTime createdAt;

  final int? totalKopecks;
}

/// `POST /orders/{id}/confirm` succeeded: the record was cleared.
@Freezed(toJson: false)
class PendingOrderConfirmed extends FinishPendingOrderOutcome
    with _$PendingOrderConfirmed {
  const PendingOrderConfirmed(this.message);

  final String message;
}

/// Confirm answered 404 — the order's shift is closed, so nothing further can
/// be confirmed. The record was cleared: there is no cancel/void route to call
/// and no way to find the order again.
@Freezed(toJson: false)
class PendingOrderShiftClosed extends FinishPendingOrderOutcome
    with _$PendingOrderShiftClosed {
  const PendingOrderShiftClosed(this.message);

  final String message;
}

/// Confirm failed for any other reason. The record is **kept**, so the seller
/// can retry; nothing is claimed about the charge either way.
@Freezed(toJson: false)
class PendingOrderConfirmFailed extends FinishPendingOrderOutcome
    with _$PendingOrderConfirmFailed {
  const PendingOrderConfirmFailed(this.message);

  final String message;
}
