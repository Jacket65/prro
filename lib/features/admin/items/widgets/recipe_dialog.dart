import 'package:flutter/material.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/api/models/measure_unit.dart';

/// Edits the recipe (ingredient lines) for a variant. Returns the updated
/// [RecipeIngredient] list, or `null` if cancelled.
///
/// Reuses [MeasureUnit] / [AdminIngredient] from the API models (no hand-rolled
/// `Measure`); the available ingredients are passed in from the repository.
Future<List<RecipeIngredient>?> showRecipeDialog(
  BuildContext context, {
  required List<RecipeIngredient> initial,
  required List<AdminIngredient> ingredients,
}) async {
  return showDialog<List<RecipeIngredient>>(
    context: context,
    builder: (ctx) =>
        _RecipeEditDialog(initial: initial, ingredients: ingredients),
  );
}

class _RecipeEditDialog extends StatefulWidget {
  const _RecipeEditDialog({
    required this.initial,
    required this.ingredients,
  });

  final List<RecipeIngredient> initial;
  final List<AdminIngredient> ingredients;

  @override
  State<_RecipeEditDialog> createState() => _RecipeEditDialogState();
}

class _RecipeEditDialogState extends State<_RecipeEditDialog> {
  late List<RecipeIngredient> _lines;
  AdminIngredient? _selected;

  @override
  void initState() {
    super.initState();
    _lines = [...widget.initial];
  }

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
  }

  void _remove(int index) {
    setState(() {
      _lines = [..._lines]..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Рецепт'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
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
                        for (final ing in widget.ingredients)
                          DropdownMenuItem(
                            value: ing,
                            child: Text(ing.name),
                          ),
                      ],
                      onChanged: (v) => setState(() => _selected = v),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.add), onPressed: _add),
                ],
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
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_lines),
          child: const Text('Зберегти'),
        ),
      ],
    );
  }
}
