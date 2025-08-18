import 'package:flutter/material.dart';
import 'package:prro/core/constants/settings.dart';

void fillRows({required List<String>? extraText}) {
  List<DataCell> a = [];
  for (String i in extraText!) {
    if (i != 'trikrapki' && i != 'iconDown') {
      a.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: Text(
          i,
        ),
      )));
    } else if (i == extraText[extraText.length - 2]) {
      a.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: Icon(Icons.more_vert),
        ),
      )));
    } else if (i == extraText[extraText.length - 1]) {
      a.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.keyboard_arrow_down),
        ),
      )));
    }
  }
  rowsName.add(DataRow(
    // color: WidgetStatePropertyAll(Colors.white),
    cells: a,
    onSelectChanged: (value) {},
  ));
}
