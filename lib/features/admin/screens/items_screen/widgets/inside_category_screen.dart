import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/admin_dialogs.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/admin_variants_dialog.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/category_pick_screen.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

const double kDefaultPaddingWidth = 25;

class InsideCategory extends StatefulWidget {
  const InsideCategory({
    required this.cardInx, required this.cardTil, required this.categoryList, super.key,
  });

  final int cardInx;
  final String cardTil;
  final List<Category> categoryList;

  @override
  State<InsideCategory> createState() => _InsideCategoryState();
}

class _InsideCategoryState extends State<InsideCategory> {
  List<Map<String, dynamic>> products = [];
  bool loading = true;
  String? errorMessage;
  int get outletId => provider.Provider.of<int>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final api = Provider.of<ApiService>(context, listen: false);
        final data = await api.fetchProducts(categoryId: widget.cardInx);
        if (!mounted) return;
        setState(() {
          products = data;
          loading = false;
          errorMessage = null;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          loading = false;
          errorMessage = 'Помилка завантаження товарів: $e';
          log(errorMessage!);
        });
      }
    });
  }

  Future<void> _renameProduct(Map<String, dynamic> product) async {
    final api = Provider.of<ApiService>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final newName = await showAdminTextPrompt(
      context,
      title: 'Перейменувати товар',
      label: 'Нова назва',
      initialValue: (product['name'] ?? '').toString(),
    );
    if (newName == null || newName.isEmpty) return;
    try {
      await api.updateProduct(
        id: (product['id'] as num).toInt(),
        name: newName,
      );
      _loadProducts();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося перейменувати: $e')),
      );
    }
  }

  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    final api = Provider.of<ApiService>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final name = (product['name'] ?? '').toString();
    final ok = await showAdminConfirm(
      context,
      title: 'Видалити товар?',
      message: 'Товар «$name» буде видалено разом з усіма варіаціями.',
    );
    if (!ok) return;
    try {
      await api.deleteProduct(id: (product['id'] as num).toInt());
      _loadProducts();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Не вдалося видалити: $e')),
      );
    }
  }

  Future<void> _openVariants(Map<String, dynamic> product) async {
    await AdminVariantsDialog.show(
      context,
      productId: (product['id'] as num).toInt(),
      productName: (product['name'] ?? '').toString(),
      outletId: outletId,
    );
    // Variant changes don't alter the products list itself, but refresh anyway
    // in case the user renamed/deleted a product elsewhere.
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardTil),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: kDefaultPaddingWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopRow(),
            const SizedBox(height: 20),

            Expanded(child: _buildContent()),

            _buildPaginationRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 20),
        _buildNewItemButton(),
        const SizedBox(width: 20),
        _buildSettingsButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        hintText: 'Пошук',
        hintStyle: const TextStyle(color: Colors.grey),
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: Colors.blueAccent),
        suffixIcon: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            border: Border.all(width: 0.7),
          ),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ),
        suffixIconConstraints: const BoxConstraints.tightFor(
          width: 50,
          height: 40,
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = Colors.black}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: color, width: 0.7),
    );
  }

  Widget _buildNewItemButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: () async {
        final measures = Provider.of<List<Measure>>(context, listen: false);
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiProvider(
              providers: [
                Provider<int>.value(value: outletId),
                Provider<List<Measure>>.value(value: measures),
              ],
              child: CategoryPick(categoryList: widget.categoryList),
            ),
          ),
        );
        if (result == true) {
          _loadProducts();
        }
      },
      icon: const Icon(Icons.add),
      label: const Text('Новий товар'),
    );
  }

  Widget _buildSettingsButton() {
    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      icon: const Icon(Icons.settings, color: Colors.grey),
      style: IconButton.styleFrom(
        backgroundColor: Colors.blueGrey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildContent() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (products.isEmpty) {
      return const Center(child: Text('Немає товарів у цій категорії.'));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth:
                  MediaQuery.of(context).size.width -
                  (kDefaultPaddingWidth * 2),
            ),
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(Colors.blueGrey[100]),
              dataRowMaxHeight: 60,
              showCheckboxColumn: false,
              showBottomBorder: true,
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const columnNames = ['Товар', 'ID', 'Дії'];
    return columnNames
        .map(
          (name) => DataColumn(
            label: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
        .toList();
  }

  List<DataRow> _buildRows() {
    return List.generate(products.length, (i) {
      final product = products[i];
      final name = (product['name'] ?? '').toString();
      final id = (product['id'] ?? '').toString();
      return DataRow(
        cells: [
          DataCell(Text(name.isEmpty ? '-' : name)),
          DataCell(Text(id)),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: () => _openVariants(product),
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Варіації'),
                ),
                IconButton(
                  tooltip: 'Перейменувати',
                  icon: const Icon(Icons.edit),
                  onPressed: () => _renameProduct(product),
                ),
                IconButton(
                  tooltip: 'Видалити',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _deleteProduct(product),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPaginationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('Показати по:'),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: 10,
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5')),
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 15, child: Text('15')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('1 із 1'),
              ),
              Icon(Icons.skip_previous_outlined, color: Colors.grey),
              Icon(Icons.navigate_before, color: Colors.grey),
              Icon(Icons.navigate_next, color: Colors.grey),
              Icon(Icons.skip_next_outlined, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}