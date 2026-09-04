import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/variant_detail_cubit.dart';
import 'package:prro/features/admin/items/widgets/recipe_dialog.dart';
import 'package:prro/features/admin/widgets/admin_back_button.dart';

/// Shows a variant's recipe and lets the admin edit it via [showRecipeDialog].
@RoutePage(name: 'AdminVariantDetailRoute')
class VariantDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) => BlocProvider<VariantDetailCubit>(
    create: (_) {
      final cubit = VariantDetailCubit(getIt<AdminCatalogRepositoryI>());
      unawaited(cubit.load(variantId: variantId, outletId: outletId));
      return cubit;
    },
    child: _VariantDetailView(
      outletId: outletId,
      variantId: variantId,
      variantName: variantName,
    ),
  );
}

class _VariantDetailView extends StatelessWidget {
  const _VariantDetailView({
    required this.outletId,
    required this.variantId,
    required this.variantName,
  });

  final int outletId;
  final int variantId;
  final String variantName;

  Future<void> _edit(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final cubit = context.read<VariantDetailCubit>();
    final current = cubit.state;
    if (current is! VariantDetailLoaded) return;
    final updated = await showRecipeDialog(
      context,
      initial: current.recipe,
      ingredients: current.ingredients,
    );
    if (updated == null) return;
    final previousRecipe = current.recipe;
    final previousIngredients = current.ingredients;
    await cubit.replaceRecipe(variantId: variantId, ingredients: updated);
    if (!context.mounted) return;
    final state = cubit.state;
    if (state is VariantDetailError) {
      cubit.restore(previousRecipe, previousIngredients);
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося зберегти: ${state.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AdminBackButton(),

        title: Text(variantName),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(context),
        child: const Icon(Icons.edit),
      ),
      body: BlocBuilder<VariantDetailCubit, VariantDetailState>(
        builder: (context, state) {
          if (state is VariantDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VariantDetailError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Спробувати ще раз'),
                    onPressed: () => context.read<VariantDetailCubit>().load(
                      variantId: variantId,
                      outletId: outletId,
                    ),
                  ),
                ],
              ),
            );
          }
          final recipe = (state as VariantDetailLoaded).recipe;
          if (recipe.isEmpty) {
            return const Center(child: Text('Рецепт порожній'));
          }
          return ListView.separated(
            itemCount: recipe.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final line = recipe[index];
              return ListTile(
                title: Text(line.name),
                trailing: Text(line.quantity.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
