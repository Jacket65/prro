import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/category_detail_cubit.dart';
import 'package:prro/features/admin/items/screens/product_detail_screen.dart'
    show ProductDetailScreen;
import 'package:prro/features/admin/items/widgets/name_dialog.dart';
import 'package:prro/features/admin/widgets/admin_back_button.dart';
import 'package:prro/router/app_router.gr.dart';

/// Lists products in a category and allows adding one. Tapping a product
/// drills into [ProductDetailScreen].
@RoutePage(name: 'AdminCategoryDetailRoute')
class CategoryDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) => BlocProvider<CategoryDetailCubit>(
    create: (_) {
      final cubit = CategoryDetailCubit(getIt<AdminCatalogRepositoryI>());
      unawaited(cubit.loadProducts(categoryId: categoryId));
      return cubit;
    },
    child: _CategoryDetailView(
      outletId: outletId,
      categoryId: categoryId,
      categoryName: categoryName,
    ),
  );
}

class _CategoryDetailView extends StatelessWidget {
  const _CategoryDetailView({
    required this.outletId,
    required this.categoryId,
    required this.categoryName,
  });

  final int outletId;
  final int categoryId;
  final String categoryName;

  Future<void> _add(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<CategoryDetailCubit>();
    final previous = cubit.state is CategoryDetailLoaded
        ? (cubit.state as CategoryDetailLoaded).products
        : const <AdminProduct>[];
    final name = await showNameDialog(
      context,
      title: 'Новий товар',
      hint: 'Назва товару',
    );
    if (name == null) return;
    await cubit.createProduct(
      categoryId: categoryId,
      name: name,
      idempotencyKey: uuidV4(),
    );
    if (!context.mounted) return;
    final state = cubit.state;
    if (state is CategoryDetailError) {
      cubit.restoreProducts(previous);
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося створити: ${state.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AdminBackButton(),

        title: Text(categoryName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CategoryDetailCubit, CategoryDetailState>(
        builder: (context, state) {
          if (state is CategoryDetailLoading ||
              state is CategoryDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryDetailError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Спробувати ще раз'),
                    onPressed: () => context
                        .read<CategoryDetailCubit>()
                        .loadProducts(categoryId: categoryId),
                  ),
                ],
              ),
            );
          }
          final products = (state as CategoryDetailLoaded).products;
          if (products.isEmpty) {
            return const Center(child: Text('Немає товарів'));
          }
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.router.push(
                  AdminProductDetailRoute(
                    outletId: outletId,
                    categoryId: categoryId,
                    productId: product.id,
                    productName: product.name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
