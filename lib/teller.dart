import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prro/settings.dart';

Column teller(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.blueAccent),
            onPressed: () {},
            child: Text(
              'Реєстрація касира',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            // decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    cursorWidth: 1,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      hintText: 'Пошук касира ПІБ',
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
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(31, 168, 168, 168),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    // width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Інформація по касирам',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
      Row(
        children: [
          Expanded(
              child: DataTable(
                  showCheckboxColumn: false,
                  columns: tellerTop,
                  rows: tellerList)),
        ],
      )
    ],
  );
}

List<DataColumn> tellerTop =
    novaTThead(['ПІБ', 'Тип', 'Статус в ДПС', 'Стан активності']);

List<DataRow> tellerList = [
  fillTellerRows(extraText: ['1', '2', '3', '4'])
];
DataRow fillTellerRows({required List<String>? extraText}) {
  List<DataCell> a = [];
  for (String i in extraText!) {
    a.add(DataCell(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
      child: Text(
        textAlign: TextAlign.center,
        i,
      ),
    )));
  }
  return DataRow(
    cells: a,
    onSelectChanged: (value) {},
  );
}
