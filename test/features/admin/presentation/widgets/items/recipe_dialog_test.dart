import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/presentation/widgets/items/recipe_dialog.dart';

const List<AdminIngredient> _ingredients = [
  AdminIngredient(id: 1, name: 'Кава зерно'),
  AdminIngredient(id: 2, name: 'Молоко'),
];

void main() {
  late List<RecipeIngredient>? result;

  Future<void> openDialog(
    WidgetTester tester, {
    required List<RecipeIngredient> initial,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showRecipeDialog(
                  context,
                  initial: initial,
                  ingredients: _ingredients,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('showRecipeDialog', () {
    testWidgets('returns the initial lines untouched when nothing changes', (
      tester,
    ) async {
      await openDialog(
        tester,
        initial: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава зерно', quantity: 0.02),
        ],
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Зберегти'));
      await tester.pumpAndSettle();

      expect(result, hasLength(1));
      expect(result!.single.ingredientId, 1);
      expect(result!.single.quantity, 0.02);
    });

    testWidgets('adds a line and updates its quantity', (tester) async {
      await openDialog(tester, initial: const []);

      await tester.tap(find.byType(DropdownButton<AdminIngredient>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Молоко').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Молоко'), findsWidgets);
      await tester.enterText(find.byType(TextField), '0,1');
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Зберегти'));
      await tester.pumpAndSettle();

      expect(result, hasLength(1));
      expect(result!.single.ingredientId, 2);
      expect(result!.single.name, 'Молоко');
      expect(result!.single.quantity, 0.1);
    });

    testWidgets('removes a line', (tester) async {
      await openDialog(
        tester,
        initial: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава зерно', quantity: 0.02),
        ],
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Зберегти'));
      await tester.pumpAndSettle();

      expect(result, isEmpty);
    });

    testWidgets('cancelling returns null', (tester) async {
      await openDialog(
        tester,
        initial: const [
          RecipeIngredient(ingredientId: 1, name: 'Кава зерно', quantity: 0.02),
        ],
      );

      await tester.tap(find.widgetWithText(TextButton, 'Скасувати'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });
  });
}
