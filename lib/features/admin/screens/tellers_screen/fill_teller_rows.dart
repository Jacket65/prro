import 'package:flutter/material.dart';
import 'package:prro/features/admin/screens/tellers_screen/cells.dart';
import 'package:prro/features/admin/screens/tellers_screen/teller.dart';

DataRow fillTellerRows({required List<String>? extraText}) {
  List<DataCell> cell = cells(extraText);

  return DataRow(
    color: WidgetStatePropertyAll(Colors.white),
    cells: cell,
    onSelectChanged: (value) {
      selectTeller(extraText!);
      // setState(() {});
    },
  );
}
