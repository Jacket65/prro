import 'package:flutter/material.dart';
import 'package:prro/settings.dart';

class ttochki extends StatelessWidget {
  const ttochki({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                          columnSpacing: 70,
                          horizontalMargin: 0,
                          dataRowMinHeight: 0,
                          dataRowMaxHeight: double.infinity,
                          showCheckboxColumn: false,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // headingRowColor: WidgetStatePropertyAll(
                          //     const Color.fromARGB(31, 168, 168, 168)),
                          columns: novaTThead(extraText: ttrows),
                          rows: rowsName),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
