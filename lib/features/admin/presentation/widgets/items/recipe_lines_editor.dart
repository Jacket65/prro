import 'package:material_ui/material_ui.dart';
import 'package:prro/features/admin/data/models/catalog.dart';

/// Shared editor for a recipe's ingredient lines.
///
/// Extracted from `recipe_dialog.dart` so the create-variant dialog can build
/// the variant's initial recipe with the very same add/remove/quantity logic
/// instead of a second, drifting copy. The current lines are reported through
/// [onChanged] so the host can enable or disable its save action.
class RecipeLinesEditor extends StatefulWidget {
  const RecipeLinesEditor({
    required this.initial,
    required this.availableIngredients,
    this.onChanged,
    super.key,
  });

  final List<RecipeIngredient> initial;
  final List<AdminIngredient> availableIngredients;
  final ValueChanged<List<RecipeIngredient>>? onChanged;

  @override
  State<RecipeLinesEditor> createState() => _RecipeLinesEditorState();
}

class _RecipeLinesEditorState extends State<RecipeLinesEditor> {
  late List<RecipeIngredient> _lines;
  AdminIngredient? _selected;

  @override
  void initState() {
    super.initState();
    _lines = [...widget.initial];
  }

  @override
  void didUpdateWidget(covariant RecipeLinesEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.initial, oldWidget.initial)) {
      _lines = [...widget.initial];
      _selected = null;
    }
  }

  void _emit() => widget.onChanged?.call(List.unmodifiable(_lines));

  void _add() {
    final picked = _selected;
    if (picked == null) return;
    if (_lines.any((l) => l.ingredientId == picked.id)) return;
    setState(() {
      _lines = [
        ..._lines,
        RecipeIngredient(
          ingredientId: picked.id,
          name: picked.name,
          quantity: 0,
        ),
      ];
    });
    _emit();
  }

  void _updateQuantity(int index, String value) {
    final q = double.tryParse(value.replaceAll(',', '.')) ?? 0;
    setState(() {
      _lines = [
        for (var i = 0; i < _lines.length; i++)
          if (i == index)
            RecipeIngredient(
              ingredientId: _lines[i].ingredientId,
              name: _lines[i].name,
              quantity: q,
            )
          else
            _lines[i],
      ];
    });
    _emit();
  }

  void _remove(int index) {
    setState(() {
      _lines = [..._lines]..removeAt(index);
    });
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _lines.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(_lines[i].name)),
                SizedBox(
                  width: 90,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (v) => _updateQuantity(i, v),
                    decoration: const InputDecoration(
                      hintText: 'к-ть',
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _remove(i),
                ),
              ],
            ),
          ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: DropdownButton<AdminIngredient>(
                isExpanded: true,
                hint: const Text('Додати інгредієнт'),
                value: _selected,
                items: [
                  for (final ing in widget.availableIngredients)
                    DropdownMenuItem(value: ing, child: Text(ing.name)),
                ],
                onChanged: (v) => setState(() => _selected = v),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: _add),
          ],
        ),
      ],
    );
  }
}
