import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'bean.freezed.dart';
part 'bean.g.dart';

/// A coffee bean a cashier can pick for a drink (e.g. "Арабіка Колумбія").
/// Beans don't change the price for now, but mirror the option shape so a
/// surcharge can be added later if the backend introduces one.
///
/// Decoded in, never encoded out: domain models are read models, the order wire
/// is built by `core/mock/order_request_dto.dart`.
@Freezed(toJson: false)
abstract class Bean with _$Bean {
  const factory Bean({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
  }) = _Bean;

  factory Bean.fromJson(Map<String, dynamic> json) => _$BeanFromJson(json);
}

/// A category of beans (Купаж / Ароматизовані / Арабіка / Без кофеїну). The
/// cashier expands a group and picks one specific bean; selection is single
/// across all groups.
@Freezed(toJson: false)
abstract class BeanGroup with _$BeanGroup {
  const factory BeanGroup({
    @JsonKey(fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(fromJson: beansFromJson)
    @Default(<Bean>[])
    List<Bean> beans,
  }) = _BeanGroup;

  factory BeanGroup.fromJson(Map<String, dynamic> json) =>
      _$BeanGroupFromJson(json);
}

/// Nested beans arrive as a plain JSON array; a missing/!list key decodes to no
/// beans instead of throwing.
List<Bean> beansFromJson(Object? value) {
  return (value as List<dynamic>? ?? const [])
      .whereType<Map<dynamic, dynamic>>()
      .map((m) => Bean.fromJson(m.cast<String, dynamic>()))
      .toList();
}
