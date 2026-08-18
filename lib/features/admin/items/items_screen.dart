import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/api/models/admin/catalog.dart';
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart';
import 'package:prro/di/di.dart';
import 'package:prro/features/admin/items/categories_cubit.dart';
import 'package:prro/features/admin/items/screens/category_detail_screen.dart'
    show CategoryDetailScreen;
import 'package:prro/features/admin/items/widgets/category_dialog.dart';
import 'package:prro/router/app_router.gr.dart';

/// Items tab: outlet-scoped categories grid with create / rename / delete,
/// driven by [CategoriesCubit]. Selecting a category drills into
/// [CategoryDetailScreen].
class ItemsScreen extends StatelessWidget {
  const ItemsScreen({required this.outletId, super.key});

  final int outletId;

  @override
  Widget build(BuildContext context) => BlocProvider<CategoriesCubit>(
    create: (_) =>
        CategoriesCubit(getIt<AdminCatalogRepositoryI>())
          ..loadCategories(outletId: outletId),
    child: _ItemsView(outletId: outletId),
  );
}

class _ItemsView extends StatelessWidget {
  const _ItemsView({required this.outletId});
  final int outletId;

  Future<void> _add(BuildContext context) async {
    final name = await showCategoryDialog(context);
    if (name == null) return;
    await context.read<CategoriesCubit>().createCategory(
      outletId: outletId,
      name: name,
    );
  }

  Future<void> _rename(BuildContext context, AdminCategory category) async {
    final name = await showCategoryDialog(context, initialName: category.name);
    if (name == null || name == category.name) return;
    await context.read<CategoriesCubit>().renameCategory(
      id: category.id,
      name: name,
    );
  }

  Future<void> _delete(BuildContext context, AdminCategory category) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Видалити категорію?'),
        content: Text('Категорію «${category.name}» буде видалено.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
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
            return Center(
              child: Text(state.message, textAlign: TextAlign.center),
            );
          }
          if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('Немає категорій'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3.5,
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
                              if (value == 'rename') _rename(context, category);
                              if (value == 'delete') _delete(context, category);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
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
