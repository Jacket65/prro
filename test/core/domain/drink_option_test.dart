import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/domain/drink_option.dart';

void main() {
  group('DrinkOption.fromJson', () {
    test('prefers option_id and parses price_delta as a decimal string', () {
      final option = DrinkOption.fromJson(const {
        'option_id': 5,
        'id': 99,
        'name': 'Сироп',
        'price_delta': '7.50',
        'is_default': true,
      });
      expect(option.id, 5);
      expect(option.name, 'Сироп');
      expect(option.priceDelta, 7.5);
      expect(option.isDefault, isTrue);
    });

    test('falls back to the id key', () {
      expect(DrinkOption.fromJson(const {'id': 5, 'name': 'x'}).id, 5);
    });

    test('defaults price_delta, is_default and name when keys are missing', () {
      final option = DrinkOption.fromJson(const {});
      expect(option.id, 0);
      expect(option.name, isEmpty);
      expect(option.priceDelta, 0);
      expect(option.isDefault, isFalse);
    });

    test('treats a non-true is_default as false', () {
      expect(
        DrinkOption.fromJson(const {'id': 1, 'is_default': 'true'}).isDefault,
        isFalse,
      );
    });
  });

  group('OptionGroup.fromJson', () {
    test('prefers group_id and decodes selection_type', () {
      final group = OptionGroup.fromJson(const {
        'group_id': 3,
        'id': 99,
        'name': 'Молоко',
        'selection_type': 'multi',
        'is_required': true,
        'options': [
          {'option_id': 1, 'name': 'Овсяное'},
        ],
      });
      expect(group.id, 3);
      expect(group.name, 'Молоко');
      expect(group.selectionType, OptionSelectionType.multi);
      expect(group.isRequired, isTrue);
      expect(group.options.single.name, 'Овсяное');
    });

    test('falls back to the id key', () {
      expect(OptionGroup.fromJson(const {'id': 3, 'name': 'x'}).id, 3);
    });

    test('an unknown selection_type decodes as single', () {
      expect(
        OptionGroup.fromJson(const {'id': 1, 'selection_type': 'weird'})
            .selectionType,
        OptionSelectionType.single,
      );
      expect(
        OptionGroup.fromJson(const {'id': 1}).selectionType,
        OptionSelectionType.single,
      );
    });

    test('defaults is_required and options when keys are missing', () {
      final group = OptionGroup.fromJson(const {'id': 1});
      expect(group.isRequired, isFalse);
      expect(group.options, isEmpty);
    });
  });

  group('SelectedOption', () {
    test('defaults price_delta to 0 and quantity to 1', () {
      const option = SelectedOption(optionId: 1, name: 'Сироп');
      expect(option.priceDelta, 0);
      expect(option.quantity, 1);
    });

    test('copyWith keeps the omitted fields', () {
      const option = SelectedOption(
        optionId: 1,
        name: 'Сироп',
        priceDelta: 7.5,
        quantity: 2,
      );
      expect(option.copyWith(quantity: 3).priceDelta, 7.5);
      expect(option.copyWith(quantity: 3).quantity, 3);
    });

    test('equals another option with the same fields', () {
      expect(
        const SelectedOption(optionId: 1, name: 'Сироп'),
        const SelectedOption(optionId: 1, name: 'Сироп'),
      );
      const other = SelectedOption(optionId: 2, name: 'Сироп');
      expect(
        const SelectedOption(optionId: 1, name: 'Сироп'),
        isNot(other),
      );
    });
  });
}
