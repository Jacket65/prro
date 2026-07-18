import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prro/core/json.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/admin_dialogs.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/admin_recipe_dialog.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

/// Lists variants for a product. Admin can create, rename, change price,
/// edit recipe, and delete each one.
class AdminVariantsDialog extends StatefulWidget {
  const AdminVariantsDialog({
    required this.productId,
    required this.productName,
    required this.outletId,
    super.key,
  });
  final int productId;
  final String productName;
  final int outletId;

  static Future<void> show(
    BuildContext context, {
    required int productId,
    required String productName,
    required int outletId,
  }) {
    final api = context.read<ApiService>();
    return showDialog<void>(
      context: context,
      builder: (_) => Provider<ApiService>.value(
        value: api,
        child: AdminVariantsDialog(
          productId: productId,
          productName: productName,
          outletId: outletId,
        ),
      ),
    );
  }

  @override
  State<AdminVariantsDialog> createState() => _AdminVariantsDialogState();
}

class _AdminVariantsDialogState extends State<AdminVariantsDialog> {
  late Future<List<Map<String, dynamic>>> _variantsFuture;

  @override
  void initState() {
    super.initState();
    _variantsFuture = _load();
  }

  Future<List<Map<String, dynamic>>> _load() {
    return context.read<ApiService>().fetchVariants(
      productId: widget.productId,
    );
  }

  void _refresh() {
    setState(() {
      _variantsFuture = _load();
    });
  }

  Future<void> _createVariant() async {
    final api = context.read<ApiService>();
    final messenger = ScaffoldMessenger.of(context);
    final draft = await _showVariantForm(title: 'Нова варіація');
    if (draft == null) return;
    try {
      await api.createVariant(
        productId: widget.productId,
        name: draft.name,
        price: draft.price,
        ingredients: const [],
      );
      _refresh();
    } on Object catch (e) {
      log('create variant failed: $e');
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося створити: $e')),
      );
    }
  }

  Future<void> _editVariant(Map<String, dynamic> variant) async {
    final api = context.read<ApiService>();
    final messenger = ScaffoldMessenger.of(context);
    final draft = await _showVariantForm(
      title: 'Редагувати варіацію',
      initialName: (variant['name'] ?? '').toString(),
      // Price arrives as a decimal STRING from the backend.
      initialPrice: parseDouble(variant['price']),
    );
    if (draft == null) return;
    try {
      await api.updateVariant(
        id: parseInt(variant['id']),
        name: draft.name,
        price: draft.price,
      );
      _refresh();
    } on Object catch (e) {
      log('update variant failed: $e');
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося оновити: $e')),
      );
    }
  }

  Future<void> _deleteVariant(Map<String, dynamic> variant) async {
    final api = context.read<ApiService>();
    final messenger = ScaffoldMessenger.of(context);
    final name = (variant['name'] ?? '').toString();
    final ok = await showAdminConfirm(
      context,
      title: 'Видалити варіацію?',
      message: 'Варіацію «$name» буде видалено разом з її рецептом.',
    );
    if (!ok) return;
    try {
      await api.deleteVariant(id: parseInt(variant['id']));
      _refresh();
    } on Object catch (e) {
      log('delete variant failed: $e');
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося видалити: $e')),
      );
    }
  }

  Future<void> _editRecipe(Map<String, dynamic> variant) async {
    final saved = await AdminRecipeDialog.show(
      context,
      variantId: parseInt(variant['id']),
      variantName: (variant['name'] ?? '').toString(),
      outletId: widget.outletId,
    );
    if (saved) _refresh();
  }

  Future<_VariantDraft?> _showVariantForm({
    required String title,
    String initialName = '',
    double initialPrice = 0,
  }) {
    final nameCtrl = TextEditingController(text: initialName);
    final priceCtrl = TextEditingController(
      text: initialPrice == 0 ? '' : initialPrice.toString(),
    );
    return showDialog<_VariantDraft>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(title),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Назва',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Ціна (грн)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final price = double.tryParse(
                priceCtrl.text.replaceAll(',', '.'),
              );
              if (name.isEmpty || price == null || price < 0) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Введіть назву та коректну ціну'),
                  ),
                );
                return;
              }
              Navigator.of(ctx).pop(_VariantDraft(name: name, price: price));
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 640,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Варіації: ${widget.productName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _createVariant,
                icon: const Icon(Icons.add),
                label: const Text('Нова варіація'),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 380),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _variantsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Не вдалося завантажити: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    final variants = snapshot.data ?? const [];
                    if (variants.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'У товару поки немає варіацій.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: variants.length,
                      separatorBuilder: (_, i) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final v = variants[index];
                        final ingredients =
                            (v['ingredients'] as List?) ?? const [];
                        return ListTile(
                          title: Text((v['name'] ?? '').toString()),
                          subtitle: Text(
                            // Backend ships price as decimal STRING.
                            '${parseDouble(v['price']).toStringAsFixed(2)} грн.'
                            '${ingredients.length} інгр.',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Рецепт',
                                icon: const Icon(Icons.restaurant_menu),
                                onPressed: () => _editRecipe(v),
                              ),
                              IconButton(
                                tooltip: 'Редагувати',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editVariant(v),
                              ),
                              IconButton(
                                tooltip: 'Видалити',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _deleteVariant(v),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantDraft {
  _VariantDraft({required this.name, required this.price});
  final String name;
  final double price;
}
