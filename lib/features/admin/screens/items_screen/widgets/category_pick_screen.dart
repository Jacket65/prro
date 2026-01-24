import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:prro/items_screen/widgets/inside_category_screen.dart';
// import 'package:prro/items_screen/items_screen.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/main_screen/services/api_service.dart';

class CategoryPick extends StatefulWidget {
  final List<Category> categoryList;
  const CategoryPick({super.key, required this.categoryList});

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
  ApiService get api => Provider.of<ApiService>(context, listen: false);
  int get retailOutletId => Provider.of<int>(context, listen: false);
  List<Measure> get measures => context.read<List<Measure>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Новий товар')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Категорія'),
              SizedBox(
                width: 500,
                child: DropdownMenu(
                  hintText: "Вибрати категорію",
                  onSelected: (value) {
                    indxCategory = value!;
                  },
                  initialSelection: lastCategory,
                  expandedInsets: EdgeInsets.zero,
                  focusNode: FocusNode(canRequestFocus: false),
                  trailingIcon: Icon(Icons.arrow_drop_down),
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
              SizedBox(height: 20),
              Text('Податкова ставка'),
              Row(
                children: [
                  Checkbox(
                    value: checkedBox,
                    onChanged: (value) {
                      checkedBox = value!;
                      setState(() {});
                    },
                  ),
                  Text('A - БЕЗ ПДВ 0%'),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Назва'),
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введіть назву товару';
                              } else if (value.length < 4) {
                                return 'Текст повинен містити не менше 4 символів';
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
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Одиниці виміру'),
                        SizedBox(
                          // width: 200,
                          // height: 40,
                          child: DropdownMenu(
                            width: 140,
                            inputDecorationTheme: InputDecorationTheme(
                              hintStyle: TextStyle(
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
                            hintText: "Вибрати",

                            onSelected: (value) {
                              selectedMeasure = value!;
                            },
                            initialSelection: 10,
                            // expandedInsets: EdgeInsets.zero,
                            focusNode: FocusNode(canRequestFocus: false),
                            trailingIcon: Icon(Icons.arrow_drop_down),
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
                  SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ціна'),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Ціна(грн)',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
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
                  Text('Зміна ціни'),
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
                  Text('Зміна ваги'),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Код УКТЗЕД'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Артикул'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Штрихкод'),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Необовязково',
                              hintStyle: TextStyle(color: Colors.grey),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
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
                          SnackBar(content: Text('Товар створено')),
                        );
                        setState(() {});
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text(
                      'Створити',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Скасувати'),
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
