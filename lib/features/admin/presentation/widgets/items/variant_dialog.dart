import 'package:material_ui/material_ui.dart';
import 'package:prro/core/utils/money.dart';
import 'package:prro/features/admin/data/models/catalog.dart';
import 'package:prro/features/admin/presentation/widgets/items/recipe_lines_editor.dart';

/// Add a variant together with its recipe. Returns
/// `(name, priceKopecks, ingredients)`, or `null` if cancelled.
/// Price is entered in UAH and converted to kopecks via [uahToKopecks].
///
/// The backend requires at least one recipe line with a quantity above zero
/// (`dto.VariantRequest.ingredients` is `required,min=1,dive` and
/// `dto.RecipeItem.quantity` is `required,gt=0`), so save stays disabled until
/// that is satisfied.
Future<(String name, int priceKopecks, List<RecipeIngredient> ingredients)?>
showVariantDialog(
  BuildContext context, {
  required List<AdminIngredient> ingredients,
}) async {
  return await showDialog<(String, int, List<RecipeIngredient>)>(
    context: context,
    builder: (ctx) => _VariantDialogContent(ingredients: ingredients),
  );
}

class _VariantDialogContent extends StatefulWidget {
  const _VariantDialogContent({required this.ingredients});

  final List<AdminIngredient> ingredients;

  @override
  State<_VariantDialogContent> createState() => _VariantDialogContentState();
}

class _VariantDialogContentState extends State<_VariantDialogContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final List<RecipeIngredient> _initial = [];
  List<RecipeIngredient> _lines = const [];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final price =
        double.tryParse(_priceController.text.trim().replaceAll(',', '.')) ?? 0;
    if (name.isEmpty || !_hasUsableLine) return;
    Navigator.of(context).pop((name, uahToKopecks(price), _lines));
  }

  bool get _hasUsableLine => _lines.any((line) => line.quantity > 0);

  @override
  Widget build(BuildContext context) {
    final canSave =
        _nameController.text.trim().isNotEmpty &&
        _hasUsableLine &&
        widget.ingredients.isNotEmpty;
    return AlertDialog(
      title: const Text('Новий варіант'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Назва варіанта'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ціна, грн',
                  suffixText: 'грн',
                ),
              ),
              const SizedBox(height: 12),
              if (widget.ingredients.isEmpty)
                const Text('У точці продажу немає інгредієнтів.')
              else
                RecipeLinesEditor(
                  initial: _initial,
                  availableIngredients: widget.ingredients,
                  onChanged: (lines) => setState(() => _lines = lines),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Скасувати'),
        ),
        FilledButton(
          onPressed: canSave ? _save : null,
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
