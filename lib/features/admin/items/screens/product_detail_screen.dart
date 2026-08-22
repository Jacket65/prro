import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/core/money.dart';
import 'package:prro/core/uuid.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/product_detail_cubit.dart';
import 'package:prro/features/admin/items/screens/variant_detail_screen.dart'
    show VariantDetailScreen;
import 'package:prro/features/admin/items/widgets/variant_dialog.dart';
import 'package:prro/router/app_router.gr.dart';

/// Lists variants of a product, allows adding one, and drills into
/// [VariantDetailScreen] for recipe editing.
@RoutePage(name: 'AdminProductDetailRoute')
class ProductDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) => BlocProvider<ProductDetailCubit>(
    create: (_) {
      final cubit = ProductDetailCubit(getIt<AdminCatalogRepositoryI>());
      unawaited(cubit.loadVariants(productId: productId));
      return cubit;
    },
    child: _ProductDetailView(
      outletId: outletId,
      categoryId: categoryId,
      productId: productId,
      productName: productName,
    ),
  );
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({
    required this.outletId,
    required this.categoryId,
    required this.productId,
    required this.productName,
  });

  final int outletId;
  final int categoryId;
  final int productId;
  final String productName;

  Future<void> _add(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<ProductDetailCubit>();
    final previous = cubit.state is ProductDetailLoaded
        ? (cubit.state as ProductDetailLoaded).variants
        : const <AdminVariant>[];
    final result = await showVariantDialog(context);
    if (result == null) return;
    final (name, priceKopecks) = result;
    await cubit.createVariant(
      productId: productId,
      name: name,
      priceKopecks: priceKopecks,
      idempotencyKey: uuidV4(),
    );
    if (!context.mounted) return;
    final state = cubit.state;
    if (state is ProductDetailError) {
      cubit.restoreVariants(previous);
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося створити: ${state.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductDetailError) {
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
                        .read<ProductDetailCubit>()
                        .loadVariants(productId: productId),
                  ),
                ],
              ),
            );
          }
          final variants = (state as ProductDetailLoaded).variants;
          if (variants.isEmpty) {
            return const Center(child: Text('Немає варіантів'));
          }
          return ListView.separated(
            itemCount: variants.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final variant = variants[index];
              return ListTile(
                title: Text(variant.name),
                subtitle: Text(formatUah(variant.priceKopecks)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.router.push(
                  AdminVariantDetailRoute(
                    outletId: outletId,
                    categoryId: categoryId,
                    productId: productId,
                    variantId: variant.id,
                    variantName: variant.name,
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
