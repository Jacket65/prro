import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/screens/product_detail_screen.dart'
    show ProductDetailScreen;
import 'package:prro/features/admin/items/widgets/name_dialog.dart';
import 'package:prro/router/app_router.gr.dart';

/// Lists products in a category and allows adding one. Tapping a product
/// drills into [ProductDetailScreen].
@RoutePage(name: 'AdminCategoryDetailRoute')
class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({
    required this.outletId,
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  final int outletId;
  final int categoryId;
  final String categoryName;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final AdminCatalogRepositoryI _repo = getIt<AdminCatalogRepositoryI>();
  List<AdminProduct> _products = const [];
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
      _products = await _repo.fetchProducts(categoryId: widget.categoryId);
    } on Object catch (e) {
      _error = e;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final name = await showNameDialog(
      context,
      title: 'Новий товар',
      hint: 'Назва товару',
    );
    if (name == null) return;
    try {
      await _repo.createProduct(
        categoryId: widget.categoryId,
        name: name,
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
      appBar: AppBar(title: Text(widget.categoryName)),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error.toString()))
          : ListView.separated(
              itemCount: _products.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(
                    AdminProductDetailRoute(
                      outletId: widget.outletId,
                      categoryId: widget.categoryId,
                      productId: product.id,
                      productName: product.name,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
