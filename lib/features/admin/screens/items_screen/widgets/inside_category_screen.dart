import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/category_pick_screen.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

const double kDefaultPaddingWidth = 25.0;

class InsideCategory extends StatefulWidget {
  const InsideCategory({
    super.key,
    required this.cardInx,
    required this.cardTil,
    required this.categoryList,
  });

  final int cardInx;
  final String cardTil;
  final List<Category> categoryList;

  @override
  State<InsideCategory> createState() => _InsideCategoryState();
}

class _InsideCategoryState extends State<InsideCategory> {
  List<List<String>> categoryData = [];
  List<bool> selectedRows = [];
  bool loading = true;
  String? errorMessage;
  int get outletId => provider.Provider.of<int>(context, listen: false);
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Чекаємо, поки контекст буде готовим після першого фрейму
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final api = Provider.of<ApiService>(context, listen: false);
        final data = await api.fetchProducts(
          retailOutlet: outletId,
          categoryId: widget.cardInx,
        );
        if (!mounted) return;

        setState(() {
          categoryData = List<List<String>>.from(data);
          selectedRows = List<bool>.filled(categoryData.length, false);
          loading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          loading = false;
          errorMessage = "Помилка завантаження товарів: $e";
          log(errorMessage!);
        });
      }
    });
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
          vertical: 8.0,
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

  // -----------------------------
  // UI BLOCKS
  // -----------------------------

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
            border: Border.all(color: Colors.black, width: 0.7),
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
      borderRadius: BorderRadius.circular(5.0),
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

    if (categoryData.isEmpty) {
      return const Center(child: Text("Немає товарів у цій категорії."));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              showCheckboxColumn: true,
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
    const columnNames = [
      'Товар',
      'Одиниці',
      'Код УКТЗЕД',
      'Податкова ставка',
      'Штрихкод',
      'Артикул',
    ];

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
    return List.generate(categoryData.length, (i) {
      final row = categoryData[i];

      return DataRow(
        selected: selectedRows[i],
        onSelectChanged: (selected) {
          setState(() => selectedRows[i] = selected ?? false);
        },
        cells: row
            .map((cell) => DataCell(Text(cell.isEmpty ? '-' : cell)))
            .toList(),
      );
    });
  }

  Widget _buildPaginationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left side
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

          // right side
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
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
