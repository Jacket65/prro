import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// Assuming CategoryPickScreen is the actual widget name for
// category_pick_screen.dart
import 'package:prro/features/admin/screens/items_screen/widgets/admin_dialogs.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/category_pick_screen.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/custom_card.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/custom_search_field.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

final GetIt getIt = GetIt.instance;

class Category {
  Category(this.title, this.id);
  final String title;
  final int id;
}

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final List<Category> _categories = [];
  ApiService get _apiService => getIt<ApiService>();
  int get _retailOutletId => getIt<int>();

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    unawaited(_loadCategories());
  }

  Future<void> _loadCategories() async {
    try {
      // 1. Await the future properly in an async method
      final rawData = await _apiService.fetchCategories(
        retailOutlet: _retailOutletId,
      );

      // 2. Safely cast the dynamic 'rawData' target to an iterable List
      final list = rawData as List<dynamic>? ?? const [];

      if (!mounted) return;

      setState(() {
        _categories
          ..clear()
          ..addAll(
            list.whereType<Map<dynamic, dynamic>>().map<Category>((item) {
              final name = (item['name'] ?? '').toString();
              final id = item['id'] as int;

              // Note: Ensuring named parameters match your Category constructor
              return Category(name, id);
            }),
          );
      });
    } on Object catch (e) {
      log('Failed to load categories: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildActionButtons(context),
          const SizedBox(height: 16),

          CustomSearchField(searchController: _searchController),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.builder(
              // key: PageStorageKey('categoryGrid'), // Good for maintaining scroll position
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of cards per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3.5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CustomCard(
                  title: category.title,
                  index: category.id,
                  categoryList: _categories,
                  onRename: () => _renameCategory(category),
                  onDelete: () => _deleteCategory(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addCategoryDialog(BuildContext context) {
    var newCategoryName = '';

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          // Use Theme or a separate function for styling for consistency
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Нова категорія'),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(dialogContext).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content: SingleChildScrollView(
            // Use FractionallySizedBox to define a relative
            //width for large screens
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use minimum space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Назва категорії'),
                  const SizedBox(height: 10),
                  TextField(
                    autofocus: true,
                    onChanged: (value) {
                      newCategoryName = value.trim();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Вкажіть назву категорії',
                      hintStyle: TextStyle(color: Colors.black26),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Скасувати'),
            ),
            // Use ElevatedButton for primary actions
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await _createCategory(newCategoryName, context, dialogContext);
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameCategory(Category category) async {
    final name = await showAdminTextPrompt(
      context,
      title: 'Перейменувати категорію',
      label: 'Нова назва',
      initialValue: category.title,
    );
    if (name == null || name.isEmpty || name == category.title) return;
    try {
      await _apiService.updateCategory(id: category.id, name: name);
      final idx = _categories.indexWhere((c) => c.id == category.id);
      if (idx != -1) {
        setState(() {
          _categories[idx] = Category(name, category.id);
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Категорію оновлено')),
      );
    } on Object catch (e) {
      log('rename category failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не вдалося перейменувати: $e')),
      );
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final ok = await showAdminConfirm(
      context,
      title: 'Видалити категорію?',
      message:
          /// Ignore
          // ignore: lines_longer_than_80_chars
          "Категорію «${category.title}» буде видалено разом з прив'язаними товарами.",
    );
    if (!ok) return;
    try {
      await _apiService.deleteCategory(id: category.id);
      setState(() {
        _categories.removeWhere((c) => c.id == category.id);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Категорію видалено')),
      );
    } on Object catch (e) {
      log('delete category failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не вдалося видалити: $e')),
      );
    }
  }

  Future<void> _createCategory(
    String newCategoryName,
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    if (newCategoryName.trim().isNotEmpty) {
      // State update should happen only if the name is valid
      for (var i = 0; i < _categories.length; i++) {
        if (_categories[i].title == newCategoryName) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Категорія з таким ім'ям вже існує")),
          );
          Navigator.of(context).pop();
          return;
        }
      }
    }
    try {
      final created = await _apiService.createCategories(
        name: newCategoryName,
        outletId: _retailOutletId,
      );

      int? newId;
      if (created.isNotEmpty && created.first is Map) {
        final m = created.first as Map;
        final id = m['id'];
        if (id is int) newId = id;
      }
      _categories.add(Category(newCategoryName, newId ?? -1));
      setState(() {});
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(content: Text('Категорія успішно створена')),
        );
        Navigator.of(dialogContext).pop();
      }
      return;
    } on Object catch (e) {
      log('$e');
      return;
    }
  }

  // Extracted widget for action buttons
  Widget _buildActionButtons(BuildContext context) {
    // Define a common style for the secondary buttons for consistency
    final secondaryButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.grey[100],
      foregroundColor: Colors.black,
      elevation: 0,
    );

    return Row(
      children: [
        // Primary Action: New Item (Новий товар)
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            // Navigate to CategoryPick screen, passing the list
            // of category titles
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) {
                  return CategoryPick(categoryList: _categories);
                },
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Новий товар'),
        ),
        const SizedBox(width: 12),

        // Secondary Action: Import Items (Імпорт товарів)
        ElevatedButton(
          style: secondaryButtonStyle,
          onPressed: () {
            // TODO(me): Implement Import logic
          },
          child: const Text('Імпорт товарів'),
        ),
        const SizedBox(width: 12),

        // Action: Add Category (Створити категорію)
        IconButton(
          style: secondaryButtonStyle.copyWith(
            minimumSize: WidgetStateProperty.all(const Size(32, 32)),
            padding: WidgetStateProperty.all(const EdgeInsets.all(4)),
            // Explicitly setting icon color,
            //as IconButton style might override it
          ),
          icon: Icon(Icons.create_new_folder_rounded, color: Colors.grey[700]),
          tooltip: 'Створити категорію',
          onPressed: () => _addCategoryDialog(context),
        ),
        const SizedBox(width: 12),

        // Action: More Options (Додатково) - PopupMenuButton
        SizedBox(
          width: 36, // Slightly increased size for better touch area
          height: 36,
          child: PopupMenuButton<String>(
            tooltip: 'Додатково',
            icon: Icon(Icons.more_vert, color: Colors.grey[700]),
            color: Colors.white, // Ensure menu background is white
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            offset: const Offset(0, 42),
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'import_history',
                child: Text('Історія імпорту'),
              ),
              const PopupMenuItem<String>(
                value: 'export_items',
                child: Text('Експорт товарів'),
              ),
              const PopupMenuItem<String>(
                value: 'delete_categories',
                child: Text('Видалити всі категорії'),
              ),
              const PopupMenuItem<String>(
                value: 'view_instruction',
                child: Text('Переглянути інструкцію'),
              ),
            ],
            onSelected: (value) {
              // TODO(me): Implement logic based on selected value
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Selected: $value')));
            },
          ),
        ),
      ],
    );
  }
}
