import 'package:flutter/material.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/screens/variant_detail_screen.dart';
import 'package:prro/features/admin/items/widgets/variant_dialog.dart';

/// Lists variants of a product, allows adding one, and drills into
/// [VariantDetailScreen] for recipe editing.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    required this.outletId,
    required this.categoryId,
    required this.productId,
    required this.productName,
    super.key,
  });

  final int outletId;
  final int categoryId;
  final int productId;
  final String productName;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final AdminCatalogRepositoryI _repo = getIt<AdminCatalogRepositoryI>();
  List<AdminVariant> _variants = const [];
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
      _variants = await _repo.fetchVariants(productId: widget.productId);
    } on Object catch (e) {
      _error = e;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final result = await showVariantDialog(context);
    if (result == null) return;
    final (name, priceKopecks) = result;
    try {
      await _repo.createVariant(
        productId: widget.productId,
        name: name,
        priceKopecks: priceKopecks,
        ingredients: const [],
        idempotencyKey: uuidV4(),
      );
      await _load();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не вдалося створити: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.productName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error.toString()))
          : ListView.separated(
              itemCount: _variants.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final variant = _variants[index];
                return ListTile(
                  title: Text(variant.name),
                  subtitle: Text(
                    '${(variant.priceKopecks / 100).toStringAsFixed(2)} грн',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => VariantDetailScreen(
                        outletId: widget.outletId,
                        categoryId: widget.categoryId,
                        productId: widget.productId,
                        variantId: variant.id,
                        variantName: variant.name,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
