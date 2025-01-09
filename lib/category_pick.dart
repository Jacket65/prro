import 'package:flutter/material.dart';
import 'package:prro/items.dart';

class CategoryPick extends StatefulWidget {
  CategoryPick();

  @override
  State<CategoryPick> createState() => _CategoryPickState();
}

class _CategoryPickState extends State<CategoryPick> {
  bool checkedBox = false;
  bool checkedPrice = false;
  bool checkedMass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Новий товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Категорія'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownMenu(
                hintText: "Вибрати категорію",
                onSelected: (value) {
                  indxCategory = value!;
                },
                initialSelection: 0,
                expandedInsets: EdgeInsets.zero,
                focusNode: FocusNode(canRequestFocus: false),
                trailingIcon: Icon(
                  Icons.arrow_drop_down,
                ),
                dropdownMenuEntries: List.generate(
                  cardTitles.length,
                  (index) {
                    return DropdownMenuEntry(
                        value: index, label: cardTitles[index]);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                Text('A - БЕЗ ПДВ 0%')
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
                        child: TextField(
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
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Одиниці виміру'),
                      SizedBox(
                        // width: 200,
                        // height: 40,
                        child: DropdownMenu(
                          inputDecorationTheme: InputDecorationTheme(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            constraints:
                                BoxConstraints.tight(const Size.fromHeight(36)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          hintText: "Вибрати категорію",
                          onSelected: (value) {},
                          initialSelection: 10,
                          // expandedInsets: EdgeInsets.zero,
                          focusNode: FocusNode(canRequestFocus: false),
                          trailingIcon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 1, label: 'Старший касир'),
                            DropdownMenuEntry(value: 2, label: 'Касир'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
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
                                  color: Colors.white, width: 2.0),
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
                Text('Зміна ціни')
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
                Text('Зміна ваги')
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
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
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
                                  color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
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
                                  color: Colors.white, width: 2.0),
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
            SizedBox(
              height: 20,
            ),
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    categoryItems[indxCategory]
                        .add(['${itemName}', 'грн', 'kod', '', '', '']);

                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: Text(
                    'Створити',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
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
    );
  }
}

int indxCategory = 0;
String itemName = '';
