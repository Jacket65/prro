import 'package:freezed_annotation/freezed_annotation.dart';

part 'finish_pending_order_state.freezed.dart';

/// What the resume banner should show right now.
sealed class PendingOrderState {
  const PendingOrderState();
}

/// Nothing is pending — the banner renders nothing at all.
@Freezed(toJson: false)
class PendingOrderHidden extends PendingOrderState with _$PendingOrderHidden {
  const PendingOrderHidden();
}

/// The stored order's receipt is being read.
@Freezed(toJson: false)
class PendingOrderResolving extends PendingOrderState
    with _$PendingOrderResolving {
  const PendingOrderResolving();
}

/// An unfinished card order, with the actions that can resolve it.
///
/// [totalKopecks] is null when the receipt could not be read; [message] is
/// null unless the last attempt to finish it failed, in which case the entry is
/// still pending and the actions remain the way to retry.
@Freezed(toJson: false)
class PendingOrderReady extends PendingOrderState with _$PendingOrderReady {
  const PendingOrderReady({
    required this.orderId,
    required this.createdAt,
    this.totalKopecks,
    this.message,
  });

  final String orderId;
  final DateTime createdAt;
  final int? totalKopecks;
  final String? message;
}

/// A finished outcome the seller should see once — the order was already
/// settled, it was just confirmed, or its shift is closed. The pending record
/// is gone; only the message is left to read.
@Freezed(toJson: false)
class PendingOrderNotice extends PendingOrderState with _$PendingOrderNotice {
  const PendingOrderNotice(this.message);

  final String message;
}
