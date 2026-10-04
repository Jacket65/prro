import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prro/core/utils/json.dart';

part 'drink_option.freezed.dart';
part 'drink_option.g.dart';

/// How many options a customer may pick from an [OptionGroup].
/// `single` → radio (one option), `multi` → checkboxes (several).
enum OptionSelectionType {
  single,
  multi;

  static OptionSelectionType fromJson(dynamic raw) {
    return raw?.toString() == 'multi'
        ? OptionSelectionType.multi
        : OptionSelectionType.single;
  }
}

/// A group of options offered for a drink variant (e.g. "Молоко", "Сироп").
/// Mirrors a `groups[]` entry of `GET /variants/:id/options`.
@Freezed(toJson: false)
abstract class OptionGroup with _$OptionGroup {
  const factory OptionGroup({
    @JsonKey(readValue: groupIdValue, fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(name: 'selection_type', fromJson: OptionSelectionType.fromJson)
    required OptionSelectionType selectionType,
    @JsonKey(name: 'is_required', fromJson: boolOrFalse)
    @Default(false)
    bool isRequired,
    @JsonKey(fromJson: drinkOptionsFromJson)
    @Default(<DrinkOption>[])
    List<DrinkOption> options,
  }) = _OptionGroup;

  factory OptionGroup.fromJson(Map<String, dynamic> json) =>
      _$OptionGroupFromJson(json);
}

/// A single selectable option with its (variant-effective) surcharge.
/// `price_delta` arrives as a decimal STRING — parse via [parseDouble].
@Freezed(toJson: false)
abstract class DrinkOption with _$DrinkOption {
  const factory DrinkOption({
    @JsonKey(readValue: optionIdValue, fromJson: parseInt) required int id,
    @JsonKey(fromJson: parseString) required String name,
    @JsonKey(name: 'price_delta', fromJson: parseDouble)
    @Default(0)
    double priceDelta,

    /// Whether this option is preselected by default (the value the cashier
    /// gets without touching the group).
    @JsonKey(name: 'is_default', fromJson: boolOrFalse)
    @Default(false)
    bool isDefault,
  }) = _DrinkOption;

  factory DrinkOption.fromJson(Map<String, dynamic> json) =>
      _$DrinkOptionFromJson(json);
}

/// An option the cashier picked for a cart line. [quantity] is the number of
/// portions (e.g. 2 syrups), each multiplying [priceDelta]. [name]/[priceDelta]
/// are kept for display and the local "Разом" approximation.
///
/// Never serialized: the order wire is built by
/// `core/mock/order_request_dto.dart`.
@Freezed(toJson: false)
abstract class SelectedOption with _$SelectedOption {
  const factory SelectedOption({
    required int optionId,
    required String name,
    @Default(0) double priceDelta,
    @Default(1) int quantity,
  }) = _SelectedOption;
}

/// `GET /variants/:id/options` keys the group id as `group_id`; admin and other
/// endpoints use `id`. A static `@JsonKey(name:)` can only name one wire key,
/// so the fallback lives in a reader that receives the whole map — the caller
/// chains [parseInt] onto it.
Object? groupIdValue(Map<dynamic, dynamic> json, String key) =>
    json['group_id'] ?? json['id'];

/// Same two-name problem as [groupIdValue], for `option_id`.
Object? optionIdValue(Map<dynamic, dynamic> json, String key) =>
    json['option_id'] ?? json['id'];

/// Nested options arrive as a plain JSON array; a missing/non-list key decodes
/// to no options instead of throwing.
List<DrinkOption> drinkOptionsFromJson(Object? value) {
  return (value as List<dynamic>? ?? const [])
      .whereType<Map<dynamic, dynamic>>()
      .map((m) => DrinkOption.fromJson(m.cast<String, dynamic>()))
      .toList();
}
