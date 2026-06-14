import 'package:equatable/equatable.dart';
import 'package:prro/core/json.dart';

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
class OptionGroup extends Equatable {
  final int id;
  final String name;
  final OptionSelectionType selectionType;
  final bool isRequired;
  final List<DrinkOption> options;

  const OptionGroup({
    required this.id,
    required this.name,
    required this.selectionType,
    this.isRequired = false,
    this.options = const [],
  });

  factory OptionGroup.fromJson(Map<String, dynamic> json) {
    return OptionGroup(
      // `GET /variants/:id/options` keys the id as `group_id`; admin/other
      // endpoints use `id`.
      id: parseInt(json['group_id'] ?? json['id']),
      name: (json['name'] ?? '').toString(),
      selectionType: OptionSelectionType.fromJson(json['selection_type']),
      isRequired: json['is_required'] == true,
      options: (json['options'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((m) => DrinkOption.fromJson(m.cast<String, dynamic>()))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, selectionType, isRequired, options];
}

/// A single selectable option with its (variant-effective) surcharge.
/// `price_delta` arrives as a decimal STRING — parse via [parseDouble].
class DrinkOption extends Equatable {
  final int id;
  final String name;
  final double priceDelta;

  /// Whether this option is preselected by default (the value the cashier gets
  /// without touching the group).
  final bool isDefault;

  const DrinkOption({
    required this.id,
    required this.name,
    this.priceDelta = 0,
    this.isDefault = false,
  });

  factory DrinkOption.fromJson(Map<String, dynamic> json) {
    return DrinkOption(
      // `GET /variants/:id/options` keys the id as `option_id`.
      id: parseInt(json['option_id'] ?? json['id']),
      name: (json['name'] ?? '').toString(),
      priceDelta: parseDouble(json['price_delta']),
      isDefault: json['is_default'] == true,
    );
  }

  @override
  List<Object?> get props => [id, name, priceDelta, isDefault];
}

/// An option the cashier picked for a cart line. [quantity] is the number of
/// portions (e.g. 2 syrups), each multiplying [priceDelta]. [name]/[priceDelta]
/// are kept for display and the local "Разом" approximation.
class SelectedOption extends Equatable {
  final int optionId;
  final String name;
  final double priceDelta;
  final int quantity;

  const SelectedOption({
    required this.optionId,
    required this.name,
    this.priceDelta = 0,
    this.quantity = 1,
  });

  SelectedOption copyWith({
    int? optionId,
    String? name,
    double? priceDelta,
    int? quantity,
  }) {
    return SelectedOption(
      optionId: optionId ?? this.optionId,
      name: name ?? this.name,
      priceDelta: priceDelta ?? this.priceDelta,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Cart → backend shape. `quantity` defaults to 1 server-side, but we always
  /// send it for clarity.
  Map<String, dynamic> toOrderJson() => {
    'option_id': optionId,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [optionId, name, priceDelta, quantity];
}
