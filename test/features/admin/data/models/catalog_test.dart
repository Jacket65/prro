import 'package:flutter_test/flutter_test.dart';
import 'package:prro/features/admin/data/models/catalog.dart';

void main() {
  group('RecipeIngredient.fromJson', () {
    test('reads ingredient_name (the real wire shape)', () {
      final line = RecipeIngredient.fromJson(const {
        'ingredient_id': 7,
        'ingredient_name': 'Кава зерно',
        'quantity': '0.020',
      });

      expect(line.ingredientId, 7);
      expect(line.name, 'Кава зерно');
      expect(line.quantity, 0.02);
    });

    test('falls back to the legacy name key', () {
      final line = RecipeIngredient.fromJson(const {
        'ingredient_id': 7,
        'name': 'Кава зерно',
        'quantity': '1',
      });

      expect(line.name, 'Кава зерно');
    });

    test('prefers ingredient_name when both keys are present', () {
      final line = RecipeIngredient.fromJson(const {
        'ingredient_id': 7,
        'ingredient_name': 'Нова назва',
        'name': 'Стара назва',
        'quantity': '2',
      });

      expect(line.name, 'Нова назва');
    });
  });

  group('AdminIngredient.fromJson', () {
    test('parses id, name and nullable unit_id', () {
      final ingredient = AdminIngredient.fromJson(const {
        'id': 3,
        'name': 'Молоко',
        'unit_id': 2,
      });

      expect(ingredient.id, 3);
      expect(ingredient.name, 'Молоко');
      expect(ingredient.unitId, 2);
    });

    test('tolerates a missing unit_id', () {
      final ingredient = AdminIngredient.fromJson(const {
        'id': 3,
        'name': 'Молоко',
      });

      expect(ingredient.unitId, isNull);
    });
  });

  group('AdminVariant.fromJson', () {
    test('parses a decimal price string into kopecks', () {
      final variant = AdminVariant.fromJson(const {
        'id': 5,
        'name': '250 мл',
        'price': '45.50',
        'product_id': 101,
      });

      expect(variant.priceKopecks, 4550);
      expect(variant.productId, 101);
    });
  });
}
