import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:prro/core/utils/json.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

/// A shift as returned by the backend (`GET/POST .../shift/...`).
///
/// `status` is `"open"` while the shift is active, `"closed"` once closed.
/// `cashStart`/`cashEnd` are decimal **strings** (`shopspring/decimal`), kept
/// verbatim so we never lose precision to a double — which also applies to the
/// timestamps, kept as the text the backend sent.
@Freezed(toJson: false)
abstract class ShiftResponse with _$ShiftResponse {
  const factory ShiftResponse({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(name: 'outlet_id', fromJson: parseInt) required int outletId,
    @JsonKey(name: 'opened_by', fromJson: parseInt) required int openedBy,
    @JsonKey(name: 'opened_at', fromJson: stringOrEmpty)
    required String openedAt,
    @JsonKey(name: 'cash_start', fromJson: cashStartOrZero)
    required String cashStart,
    @JsonKey(fromJson: parseString) required String status,
    @JsonKey(name: 'closed_by', fromJson: parseNullableInt) int? closedBy,
    @JsonKey(name: 'closed_at', fromJson: stringOrNull) String? closedAt,
    @JsonKey(name: 'cash_end', fromJson: stringOrNull) String? cashEnd,
  }) = _ShiftResponse;

  factory ShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$ShiftResponseFromJson(json);

  const ShiftResponse._();

  bool get isOpen => status == 'open';
}

/// `cash_start` is a decimal string on the wire; a missing one means an empty
/// till.
String cashStartOrZero(Object? value) => stringOr(value, '0.00');
