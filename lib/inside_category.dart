import 'package:flutter/material.dart';

class InsideCategory extends StatefulWidget {
  const InsideCategory({super.key});

  @override
  State<InsideCategory> createState() => _InsideCategoryState();
}

class _InsideCategoryState extends State<InsideCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('123'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
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
                  onPressed: () {},
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
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(5)),
                width: double.maxFinite,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      showCheckboxColumn: true,
                      showBottomBorder: false,
                      columns: List.generate(
                        itemsBar.length,
                        (index) =>
                            DataColumn(label: Text('${itemsBar[index]}')),
                      ),
                      rows: List<DataRow>.generate(
                        lenght,
                        (int index) => DataRow(
                          cells: List.generate(
                            itemsBar.length,
                            (index) => DataCell(
                                Text('Cell-------------------------$index')),
                          ),
                          selected: selected[index],
                          onSelectChanged: (bool? value) {
                            setState(() {
                              selected[index] = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int lenght = 5;
int number = itemsBar.length;
List<bool> selected = List<bool>.generate(lenght, (int index) => false);
List<String> itemsBar = [
  'Товар',
  'Одиниці',
  'Код УКТЗЕД',
  'Податкова ставка',
  'Штрихкод',
  'Артикул',
];
