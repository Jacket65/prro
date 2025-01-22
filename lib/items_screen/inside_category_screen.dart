import 'package:flutter/material.dart';
import 'package:prro/items_screen/category_pick_screen.dart';
import 'package:prro/items_screen/items_screen.dart';

class InsideCategory extends StatefulWidget {
  InsideCategory(this.cardInx, this.cardTil, {super.key});
  int cardInx;
  String cardTil;
  @override
  State<InsideCategory> createState() => _InsideCategoryState();
}

List<bool> selected = List<bool>.generate(lenght, (int index) => false);
int lenght = 5;

double paddingWidth = 25;

class _InsideCategoryState extends State<InsideCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.cardTil}'),
      ),
      body: Padding(
        // padding: EdgeInsets.zero,
        padding:
            EdgeInsets.symmetric(vertical: 8.0, horizontal: paddingWidth - 1),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    cursorWidth: 1,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.7,
                        ),
                      ),
                      suffixIcon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(5)),
                            border: Border.all(color: Colors.black),
                            color: Colors.grey[300]),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                      ),
                      suffixIconConstraints:
                          BoxConstraints.loose(Size(50, 200)),
                      hintText: 'Пошук',
                      hintStyle: TextStyle(color: Colors.grey),
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CategoryPick(),
                      ),
                    );
                  },
                  child: Text(
                    'Новий товар',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(4),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.blueGrey[50]),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width -
                            ((paddingWidth * 2)),
                      ),
                      child: DataTable(
                        // dataRowColor: WidgetStatePropertyAll(Colors.amber),
                        headingRowColor:
                            WidgetStatePropertyAll(Colors.blueGrey[100]),
                        dataRowMaxHeight: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        showCheckboxColumn: true,
                        showBottomBorder: false,
                        columns: List.generate(
                          itemsBar.length,
                          (index) =>
                              DataColumn(label: Text('${itemsBar[index]}')),
                        ),
                        rows: categoryItems[widget.cardInx].isEmpty
                            ? []
                            : List<DataRow>.generate(
                                categoryItems[widget.cardInx].length,
                                (int rowIndex) => DataRow(
                                  // color: WidgetStatePropertyAll(Colors.green),
                                  cells: List.generate(
                                    6,
                                    // categoryItems[widget.cardInx][index].length,
                                    (celIndex) => DataCell(Text(
                                        '${categoryItems[widget.cardInx][rowIndex][celIndex]}')),
                                  ),
                                  selected: selected[rowIndex],
                                  onSelectChanged: (bool? value) {
                                    setState(() {
                                      selected[rowIndex] = value!;
                                    });
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Показати по:'),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: 130,
                        child: DropdownMenu(
                          initialSelection: 10,
                          expandedInsets: EdgeInsets.zero,
                          focusNode: FocusNode(canRequestFocus: false),
                          trailingIcon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: 5, label: '5'),
                            DropdownMenuEntry(value: 10, label: '10'),
                            DropdownMenuEntry(value: 15, label: '15'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text('1 із 1'),
                      ),
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          onPressed: null,
                          icon: Icon(Icons.skip_previous_outlined)),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        onPressed: null,
                        icon: Icon(Icons.navigate_before),
                      ),
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          onPressed: null,
                          icon: Icon(Icons.navigate_next)),
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          onPressed: null,
                          icon: Icon(Icons.skip_next_outlined)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

int number = itemsBar.length;
List<String> itemsBar = [
  'Товар',
  'Одиниці',
  'Код УКТЗЕД',
  'Податкова ставка',
  'Штрихкод',
  'Артикул',
];
