import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:prro/items_screen/widgets/inside_category_screen.dart';
// import 'package:prro/items_screen/items_screen.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

final GetIt getIt = GetIt.instance;

class CategoryPick extends StatefulWidget {
  const CategoryPick({required this.categoryList, super.key});
  final List<Category> categoryList;

  @override
  State<CategoryPick> createState() => _CategoryPickState();
}

class _CategoryPickState extends State<CategoryPick> {
  final _formKey = GlobalKey<FormState>();

  int indxCategory = 0;
  int selectedMeasure = 0;
  String itemName = '';
  bool checkedBox = false;
  bool checkedPrice = false;
  bool checkedMass = false;
  ApiService get api => getIt<ApiService>();
  int get retailOutletId => getIt<int>();
  List<Measure> get measures => getIt<List<Measure>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Новий товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Категорія'),
              SizedBox(
                width: 500,
                child: DropdownMenu(
                  hintText: 'Вибрати категорію',
                  onSelected: (value) {
                    indxCategory = value!;
                  },
                  initialSelection: lastCategory,
                  expandedInsets: EdgeInsets.zero,
                  focusNode: FocusNode(canRequestFocus: false),
                  trailingIcon: const Icon(Icons.arrow_drop_down),
                  dropdownMenuEntries: List.generate(
                    widget.categoryList.length,
                    (index) {
                      return DropdownMenuEntry(
                        value: index,
                        label: widget.categoryList[index].title,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Податкова ставка'),
              Row(
                children: [
                  Checkbox(
                    value: checkedBox,
                    onChanged: (value) {
                      checkedBox = value!;
                      setState(() {});
                    },
                  ),
                  const Text('A - БЕЗ ПДВ 0%'),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Назва'),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введіть назву товару';
                              } else if (value.length < 4) {
                                return 'Текст повинен бути не менше 4 символів';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              itemName = value;
                            },
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Введіть назву товару чи послуги',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Одиниці виміру'),
                        SizedBox(
                          // width: 200,
                          // height: 40,
                          child: DropdownMenu(
                            width: 140,
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              constraints: BoxConstraints.tight(
                                const Size.fromHeight(36),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            hintText: 'Вибрати',

                            onSelected: (value) {
                              selectedMeasure = value!;
                            },
                            initialSelection: 10,
                            // expandedInsets: EdgeInsets.zero,
                            focusNode: FocusNode(canRequestFocus: false),
                            trailingIcon: const Icon(Icons.arrow_drop_down),
                            dropdownMenuEntries: List.generate(
                              measures.length,
                              (index) {
                                return DropdownMenuEntry(
                                  value: index,
                                  label: measures[index].name,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ціна'),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Ціна(грн)',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Switch(
                    value: checkedPrice,
                    onChanged: (value) {
                      checkedPrice = value;
                      setState(() {});
                    },
                  ),
                  const Text('Зміна ціни'),
                ],
              ),
              Row(
                children: [
                  Switch(
                    value: checkedMass,
                    onChanged: (value) {
                      checkedMass = value;
                      setState(() {});
                    },
                  ),
                  const Text('Зміна ваги'),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Код УКТЗЕД'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Артикул'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Штрихкод'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: const TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.blue,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await api.createProduct(
                          measureId: measures[selectedMeasure].id,
                          name: itemName,
                          categoryId: widget.categoryList[indxCategory].id,
                          outletId: retailOutletId,
                          price: 100,
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Товар створено')),
                        );
                        setState(() {});
                        Navigator.pop(context, true);
                      }
                    },
                    child: const Text(
                      'Створити',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Скасувати'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
