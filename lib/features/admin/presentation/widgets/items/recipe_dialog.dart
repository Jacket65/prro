import 'package:material_ui/material_ui.dart';
import 'package:prro/core/domain/measure_unit.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/presentation/widgets/items/recipe_lines_editor.dart';

/// Edits the recipe (ingredient lines) for a variant. Returns the updated
/// [RecipeIngredient] list, or `null` if cancelled.
///
/// Reuses [MeasureUnit] / [AdminIngredient] from the API models (no hand-rolled
/// `Measure`); the available ingredients are passed in from the repository. The
/// rows themselves live in [RecipeLinesEditor], shared with the create-variant
/// dialog.
Future<List<RecipeIngredient>?> showRecipeDialog(
  BuildContext context, {
  required List<RecipeIngredient> initial,
  required List<AdminIngredient> ingredients,
}) async {
  return await showDialog<List<RecipeIngredient>>(
    context: context,
    builder: (ctx) =>
        _RecipeEditDialog(initial: initial, ingredients: ingredients),
  );
}

class _RecipeEditDialog extends StatefulWidget {
  const _RecipeEditDialog({required this.initial, required this.ingredients});

  final List<RecipeIngredient> initial;
  final List<AdminIngredient> ingredients;

  @override
  State<_RecipeEditDialog> createState() => _RecipeEditDialogState();
}

class _RecipeEditDialogState extends State<_RecipeEditDialog> {
  late List<RecipeIngredient> _lines;

  @override
  void initState() {
    super.initState();
    _lines = [...widget.initial];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Рецепт'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: RecipeLinesEditor(
            initial: widget.initial,
            availableIngredients: widget.ingredients,
            onChanged: (lines) => _lines = lines,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_lines),
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
