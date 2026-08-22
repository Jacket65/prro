import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/categories_cubit.dart';
import 'package:prro/features/admin/items/screens/category_detail_screen.dart'
    show CategoryDetailScreen;
import 'package:prro/features/admin/items/widgets/name_dialog.dart';
import 'package:prro/features/admin/outlets/outlets_cubit.dart';
import 'package:prro/features/admin/widgets/confirm_dialog.dart';
import 'package:prro/router/app_router.gr.dart';

/// Items tab: outlet-scoped categories grid with create / rename / delete,
/// driven by [CategoriesCubit]. Selecting a category drills into
/// [CategoryDetailScreen].
@RoutePage(name: 'AdminItemsTabRoute')
class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outletState = context.watch<OutletsCubit>().state;
    final outletId = outletState is OutletsLoaded
        ? outletState.selectedOutletId
        : null;
    if (outletId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Товари')),
        body: const Center(child: Text('Оберіть торговельну точку')),
      );
    }
    return BlocProvider<CategoriesCubit>(
      key: ValueKey(outletId),
      create: (_) {
        final cubit = CategoriesCubit(getIt<AdminCatalogRepositoryI>());
        unawaited(cubit.loadCategories(outletId: outletId));
        return cubit;
      },
      child: _ItemsView(outletId: outletId),
    );
  }
}

class _ItemsView extends StatelessWidget {
  const _ItemsView({required this.outletId});
  final int outletId;

  Future<void> _add(BuildContext context) async {
    final name = await showNameDialog(
      context,
      title: 'Нова категорія',
      hint: 'Назва категорії',
    );
    if (!context.mounted) return;
    if (name == null) return;
    await context.read<CategoriesCubit>().createCategory(
      outletId: outletId,
      name: name,
    );
  }

  Future<void> _rename(BuildContext context, AdminCategory category) async {
    final name = await showNameDialog(
      context,
      title: 'Перейменувати категорію',
      hint: 'Назва категорії',
      initialName: category.name,
    );
    if (!context.mounted) return;
    if (name == null || name == category.name) return;
    await context.read<CategoriesCubit>().renameCategory(
      id: category.id,
      name: name,
    );
  }

  Future<void> _delete(BuildContext context, AdminCategory category) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Видалити категорію?',
      message: 'Категорію «${category.name}» буде видалено.',
    );
    if (!context.mounted) return;
    if (ok == true) {
      await context.read<CategoriesCubit>().deleteCategory(id: category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Товари')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(context),
        child: const Icon(Icons.create_new_folder_outlined),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading || state is CategoriesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoriesError) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Спробувати ще раз'),
                        onPressed: () => context
                            .read<CategoriesCubit>()
                            .loadCategories(outletId: outletId),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('Немає категорій'));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = switch (width) {
                  < 600 => 2,
                  < 900 => 3,
                  < 1200 => 4,
                  _ => 5,
                };
                const spacing = 12.0;
                const padding = 32.0;
                const tileHeight = 56.0;
                final tileWidth =
                    (width - padding - spacing * (crossAxisCount - 1)) /
                    crossAxisCount;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: tileWidth / tileHeight,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Card(
                      child: InkWell(
                        onTap: () => context.router.push(
                          AdminCategoryDetailRoute(
                            outletId: outletId,
                            categoryId: category.id,
                            categoryName: category.name,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(child: Text(category.name)),
                              PopupMenuButton<String>(
                                itemBuilder: (ctx) => const [
                                  PopupMenuItem(
                                    value: 'rename',
                                    child: Text('Перейменувати'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Видалити'),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'rename') {
                                    unawaited(_rename(context, category));
                                  }
                                  if (value == 'delete') {
                                    unawaited(_delete(context, category));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
