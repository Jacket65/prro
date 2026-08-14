import 'package:equatable/equatable.dart';

import 'package:prro/core/json.dart';

/// A shift as returned by the backend (`GET/POST .../shift/...`).
///
/// `status` is `"open"` while the shift is active, `"closed"` once closed.
/// `cashStart`/`cashEnd` are decimal **strings** (`shopspring/decimal`), kept
/// verbatim so we never lose precision to a double.
class ShiftResponse extends Equatable {
  const ShiftResponse({
    required this.id,
    required this.outletId,
    required this.openedBy,
    required this.openedAt,
    required this.cashStart,
    required this.status,
    this.closedBy,
    this.closedAt,
    this.cashEnd,
  });

  factory ShiftResponse.fromJson(Map<String, dynamic> json) {
    return ShiftResponse(
      id: parseInt(json['id']),
      outletId: parseInt(json['outlet_id']),
      openedBy: parseInt(json['opened_by']),
      closedBy: json['closed_by'] == null ? null : parseInt(json['closed_by']),
      openedAt: (json['opened_at'] ?? '').toString(),
      closedAt: json['closed_at']?.toString(),
      cashStart: (json['cash_start'] ?? '0.00').toString(),
      cashEnd: json['cash_end']?.toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
  final int id;
  final int outletId;
  final int openedBy;
  final int? closedBy;
  final String openedAt;
  final String? closedAt;
  final String cashStart;
  final String? cashEnd;
  final String status;

  bool get isOpen => status == 'open';

  @override
  List<Object?> get props => [
    id,
    outletId,
    openedBy,
    closedBy,
    openedAt,
    closedAt,
    cashStart,
    cashEnd,
    status,
  ];
}
