import 'package:flutter/material.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/widgets/recipe_dialog.dart';

/// Shows a variant's recipe and lets the admin edit it via [showRecipeDialog].
class VariantDetailScreen extends StatefulWidget {
  const VariantDetailScreen({
    required this.outletId,
    required this.categoryId,
    required this.productId,
    required this.variantId,
    required this.variantName,
    super.key,
  });

  final int outletId;
  final int categoryId;
  final int productId;
  final int variantId;
  final String variantName;

  @override
  State<VariantDetailScreen> createState() => _VariantDetailScreenState();
}

class _VariantDetailScreenState extends State<VariantDetailScreen> {
  final AdminCatalogRepositoryI _repo = getIt<AdminCatalogRepositoryI>();
  List<RecipeIngredient> _recipe = const [];
  List<AdminIngredient> _ingredients = const [];
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _recipe = await _repo.fetchRecipe(variantId: widget.variantId);
      _ingredients = await _repo.fetchIngredients(outletId: widget.outletId);
    } on Object catch (e) {
      _error = e;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _edit() async {
    final updated = await showRecipeDialog(
      context,
      initial: _recipe,
      ingredients: _ingredients,
    );
    if (updated == null) return;
    try {
      await _repo.replaceRecipe(
        variantId: widget.variantId,
        ingredients: updated,
      );
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося зберегти: $e')),
        );
      }
      return;
    }
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.variantName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _edit,
        child: const Icon(Icons.edit),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error.toString()))
          : _recipe.isEmpty
          ? const Center(child: Text('Рецепт порожній'))
          : ListView.separated(
              itemCount: _recipe.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final line = _recipe[index];
                return ListTile(
                  title: Text(line.name),
                  trailing: Text(line.quantity.toString()),
                );
              },
            ),
    );
  }
}
