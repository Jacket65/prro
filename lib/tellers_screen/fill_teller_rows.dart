import 'package:flutter/material.dart';
import 'package:prro/settings.dart';
import 'package:prro/tellers_screen/cells.dart';
import 'package:prro/tellers_screen/teller.dart';

DataRow fillTellerRows({required List<String>? extraText}) {
  List<DataCell> a = cells(extraText);

  return DataRow(
    color: WidgetStatePropertyAll(color333),
    cells: a,
    onSelectChanged: (value) {
      select_teller(extraText!);
      // setState(() {});
    },
  );
}
