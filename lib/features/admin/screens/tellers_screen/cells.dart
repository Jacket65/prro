import 'package:flutter/material.dart';

List<DataCell> cells(List<String>? extraText) {
  final a = <DataCell>[];

  for (final i in extraText!) {
    if (i != extraText[extraText.length - 1]) {
      a.add(
        DataCell(
          Text(
            // style: TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
            i,
          ),
        ),
      );
    } else {
      a.add(
        DataCell(
          Align(
            child: Icon(
              Icons.circle,
              color: i == 'Active' ? Colors.green : Colors.red,
              size: 15,
            ),
          ),
        ),
      );
    }
  }
  return a;
}
