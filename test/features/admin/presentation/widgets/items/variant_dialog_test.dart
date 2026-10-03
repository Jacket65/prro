import 'package:flutter_test/flutter_test.dart';
// `material_ui` is a material-library fork: its `showDialog` looks up its own
// `MaterialLocalizations`, so the widget tree must be built with its
// `MaterialApp` too (this is what the app itself uses).
import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/presentation/widgets/items/variant_dialog.dart';

const List<AdminIngredient> _ingredients = [
  AdminIngredient(id: 1, name: 'Кава зерно'),
  AdminIngredient(id: 2, name: 'Молоко'),
];

void main() {
  late (String, int, List<RecipeIngredient>)? result;

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showVariantDialog(
                  context,
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

  /// The dialog renders its fields in order: name, price, then one quantity
  /// field per recipe line.
  Finder fieldAt(int index) => find.byType(TextField).at(index);
  Finder saveButton() => find.widgetWithText(FilledButton, 'Зберегти');
  bool saveEnabled(WidgetTester tester) =>
      tester.widget<FilledButton>(saveButton()).onPressed != null;

  Future<void> pickIngredient(WidgetTester tester, String label) async {
    await tester.tap(find.byType(DropdownButton<AdminIngredient>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
    // The dropdown only selects; the `+` button adds the line.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
  }

  group('showVariantDialog', () {
    testWidgets('save stays disabled until a line has quantity > 0', (
      tester,
    ) async {
      await openDialog(tester);

      expect(saveEnabled(tester), isFalse);

      // A name and a price alone are not enough: the backend rejects a recipe
      // with no lines at all (`min=1` on `dto.VariantRequest.ingredients`).
      await tester.enterText(fieldAt(0), 'Еспресо');
      await tester.enterText(fieldAt(1), '35');
      await tester.pump();
      expect(saveEnabled(tester), isFalse);

      // A line with quantity 0 is still rejected (`gt=0` on RecipeItem).
      await pickIngredient(tester, 'Кава зерно');
      expect(fieldAt(2), findsOneWidget);
      expect(saveEnabled(tester), isFalse);

      await tester.enterText(fieldAt(2), '0,02');
      await tester.pump();
      expect(saveEnabled(tester), isTrue);
    });

    testWidgets('returns the name, price in kopecks and the recipe lines', (
      tester,
    ) async {
      await openDialog(tester);

      await tester.enterText(fieldAt(0), 'Еспресо');
      await tester.enterText(fieldAt(1), '35,50');
      await pickIngredient(tester, 'Кава зерно');
      await tester.enterText(fieldAt(2), '0.020');
      await tester.pump();

      await tester.tap(saveButton());
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      final (name, priceKopecks, ingredients) = result!;
      expect(name, 'Еспресо');
      expect(priceKopecks, 3550);
      expect(ingredients, hasLength(1));
      expect(ingredients.single.ingredientId, 1);
      expect(ingredients.single.name, 'Кава зерно');
      expect(ingredients.single.quantity, 0.02);
    });

    testWidgets('cancelling returns null', (tester) async {
      await openDialog(tester);

      await tester.tap(find.widgetWithText(TextButton, 'Скасувати'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });
  });
}
