import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:prro/core/json.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

/// Recipe editor for a single variant in the admin panel.
/// Loads the recipe via `GET /variants/:id/recipe` and the available ingredient
/// catalogue via `GET /retail-outlets/:outlet/ingredients`, then commits via
/// `PUT /variants/:id/recipe` when the user presses save.
class AdminRecipeDialog extends StatefulWidget {
  const AdminRecipeDialog({
    required this.variantId,
    required this.variantName,
    required this.outletId,
    super.key,
  });
  final int variantId;
  final String variantName;
  final int outletId;

  static Future<bool> show(
    BuildContext context, {
    required int variantId,
    required String variantName,
    required int outletId,
  }) async {
    final api = context.read<ApiService>();
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => Provider<ApiService>.value(
        value: api,
        child: AdminRecipeDialog(
          variantId: variantId,
          variantName: variantName,
          outletId: outletId,
        ),
      ),
    );
    return saved ?? false;
  }

  @override
  State<AdminRecipeDialog> createState() => _AdminRecipeDialogState();
}

class _RecipeRow {
  _RecipeRow({
    required this.ingredientId,
    required this.name,
    required this.quantity,
  });
  int ingredientId;
  String name;
  double quantity;
}

class _AdminRecipeDialogState extends State<AdminRecipeDialog> {
  late Future<void> _bootstrap;
  List<Map<String, dynamic>> _ingredients = [];
  // Measure-unit id → name (г / мл / шт ...) to label ingredient quantities.
  Map<int, String> _unitNameById = const {};
  final List<_RecipeRow> _rows = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bootstrap = _load();
  }

  Future<void> _load() async {
    final api = context.read<ApiService>();
    // Kick off all three requests concurrently, then await.
    final ingredientsF = api.fetchIngredients(outletId: widget.outletId);
    final recipeF = api.fetchRecipe(variantId: widget.variantId);
    final measuresF = api.fetchMeasures();
    _ingredients = await ingredientsF;
    final recipe = await recipeF;
    _unitNameById = {for (final m in await measuresF) m.id: m.name};
    _rows
      ..clear()
      ..addAll(
        recipe.map((r) {
          final id = parseInt(r['ingredient_id']);
          final rawName = (r['ingredient_name'] ?? '').toString();
          return _RecipeRow(
            ingredientId: id,
            // Backend ships the name in the recipe response; fall back to the
            // ingredient catalogue if it ever arrives empty.
            name: rawName.isNotEmpty ? rawName : _lookupName(id),
            // Quantity arrives as decimal STRING.
            quantity: parseDouble(r['quantity']),
          );
        }),
      );
  }

  String _lookupName(int id) {
    for (final i in _ingredients) {
      if (parseInt(i['id']) == id) {
        return (i['name'] ?? '').toString();
      }
    }
    return '#$id';
  }

  /// Measure-unit name for an ingredient (via its `unit_id`), or '' if unknown.
  String _unitFor(int ingredientId) {
    for (final i in _ingredients) {
      if (parseInt(i['id']) == ingredientId) {
        return _unitNameById[parseInt(i['unit_id'])] ?? '';
      }
    }
    return '';
  }

  List<Map<String, dynamic>> _availableForAdd() {
    final used = _rows.map((r) => r.ingredientId).toSet();
    return _ingredients
        .where((i) => !used.contains(parseInt(i['id'])))
        .toList();
  }

  void _addIngredient(Map<String, dynamic> ingredient) {
    setState(() {
      _rows.add(
        _RecipeRow(
          ingredientId: parseInt(ingredient['id']),
          name: (ingredient['name'] ?? '').toString(),
          quantity: 1,
        ),
      );
    });
  }

  void _updateQty(int index, double qty) {
    if (qty <= 0) {
      setState(() => _rows.removeAt(index));
    } else {
      setState(() => _rows[index].quantity = qty);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await context.read<ApiService>().replaceRecipe(
        variantId: widget.variantId,
        ingredients: _rows
            .map(
              (r) => {
                'ingredient_id': r.ingredientId,
                'quantity': r.quantity,
              },
            )
            .toList(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не вдалося зберегти рецепт: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 560,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<void>(
            future: _bootstrap,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Помилка завантаження: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 24),
                  _buildRecipeList(),
                  const SizedBox(height: 16),
                  _buildAddSection(),
                  const SizedBox(height: 16),
                  _buildFooter(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Рецепт: ${widget.variantName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }

  Widget _buildRecipeList() {
    if (_rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Рецепт порожній. Додайте інгредієнти нижче.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _rows.length,
        separatorBuilder: (_, i) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final row = _rows[index];
          return _RecipeRowWidget(
            key: ValueKey(row.ingredientId),
            name: row.name,
            quantity: row.quantity,
            unit: _unitFor(row.ingredientId),
            onQuantityChanged: (qty) => _updateQty(index, qty),
            onRemove: () => _updateQty(index, 0),
          );
        },
      ),
    );
  }

  Widget _buildAddSection() {
    final available = _availableForAdd();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Додати інгредієнт',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        PopupMenuButton<Map<String, dynamic>>(
          enabled: available.isNotEmpty,
          onSelected: _addIngredient,
          itemBuilder: (_) => available.map((i) {
            final name = (i['name'] ?? '').toString();
            final unit = _unitNameById[parseInt(i['unit_id'])] ?? '';
            return PopupMenuItem<Map<String, dynamic>>(
              value: i,
              child: Text(unit.isEmpty ? name : '$name ($unit)'),
            );
          }).toList(),
          position: PopupMenuPosition.under,
          tooltip: '',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: available.isEmpty
                    ? Colors.grey.shade300
                    : Colors.grey.shade500,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _ingredients.isEmpty
                        ? 'У цій точці ще немає інгредієнтів'
                        : available.isEmpty
                        ? 'Всі інгредієнти вже в рецепті'
                        : 'Виберіть інгредієнт',
                    style: TextStyle(
                      color: available.isEmpty ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: available.isEmpty ? Colors.grey : Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Зберегти рецепт'),
        ),
      ],
    );
  }
}

class _RecipeRowWidget extends StatefulWidget {
  const _RecipeRowWidget({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });
  final String name;
  final double quantity;
  final String unit;
  final ValueChanged<double> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  State<_RecipeRowWidget> createState() => _RecipeRowWidgetState();
}

class _RecipeRowWidgetState extends State<_RecipeRowWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.quantity));
  }

  @override
  void didUpdateWidget(covariant _RecipeRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final formatted = _format(widget.quantity);
    if (formatted != _controller.text) {
      _controller.text = formatted;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _format(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => widget.onQuantityChanged(
              (widget.quantity - 1).clamp(0, double.infinity),
            ),
          ),
          SizedBox(
            width: 72,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                final qty = double.tryParse(text.replaceAll(',', '.'));
                if (qty != null) widget.onQuantityChanged(qty);
              },
            ),
          ),
          if (widget.unit.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: SizedBox(
                width: 28,
                child: Text(
                  widget.unit,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => widget.onQuantityChanged(widget.quantity + 1),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }
}
