import 'package:meta/meta.dart';

/// A card order the client knows is unfinished: the order record exists
/// server-side (so the charge can still be confirmed) but the flow was
/// interrupted before it completed — the app was killed mid-terminal-charge,
/// the callback never arrived, or the confirm call failed.
///
/// This is the client's only handle on such an order. The backend lists only
/// `completed` orders (`GET /shifts/{id}/orders`), exposes no cancel/void
/// route, and cannot be asked whether money moved, so an interrupted card
/// order is unfindable and un-cancellable from the app's side — the record
/// below is what keeps it resolvable after a process death.
@immutable
final class PendingOrder {
  const PendingOrder({
    required this.orderId,
    required this.idempotencyKey,
    required this.createdAt,
  });

  /// The order the terminal charge was started for.
  final String orderId;

  /// The key the order was placed with. Replacing it with a confirmed order is
  /// impossible by design: the backend treats a repeated key as the same
  /// order, so it is what a resume must keep using.
  final String idempotencyKey;

  /// When the pending record was written. Not used for any decision (a stale
  /// entry is as unfinished as a fresh one — the order's own state decides
  /// that); it exists so the record can be diagnosed after the fact.
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingOrder &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          idempotencyKey == other.idempotencyKey &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(orderId, idempotencyKey, createdAt);

  @override
  String toString() =>
      'PendingOrder(orderId: $orderId, '
      'idempotencyKey: $idempotencyKey, createdAt: $createdAt)';
}

/// Persistence for the single [PendingOrder] of the current session.
///
/// The contract lives in the domain layer and the implementation in data
/// (it is SharedPreferences-backed) because both callers that need it are
/// outside the data layer: `PayOrderUseCase` writes the record, and
/// `AuthBloc` clears it at every session boundary.
abstract interface class PendingOrderStoreI {
  /// Records [orderId] as pending, replacing any previous record.
  ///
  /// A suspended or completed order must never overwrite an entry that is
  /// still needed, so callers only invoke this for an interrupted card order.
  Future<void> save({
    required String orderId,
    required String idempotencyKey,
  });

  /// The recorded pending order, or `null` when there is none.
  PendingOrder? read();

  /// Drops the record. Safe to call when there is nothing to drop.
  Future<void> clear();
}
