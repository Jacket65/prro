import 'dart:ui';
import 'package:flutter/material.dart';

List<DataCell> cells(List<String>? extraText) {
  List<DataCell> a = [];

  for (String i in extraText!) {
    if (i != extraText[extraText.length - 1]) {
      a.add(DataCell(Text(
        // style: TextStyle(fontSize: 20),
        textAlign: TextAlign.right,
        i,
      )));
    } else {
      a.add(
        DataCell(
          Container(
            // decoration: BoxDecoration(border: Border.all()),
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.circle,
                color: i == 'Active' ? Colors.green : Colors.red,
                size: 15,
              ),
            ),
          ),
        ),
      );
    }
  }
  return a;
}
