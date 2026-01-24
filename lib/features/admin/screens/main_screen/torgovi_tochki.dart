import 'package:flutter/material.dart';
import 'package:prro/core/constants/settings.dart';

class Ttochki extends StatefulWidget {
  final List<List<String>> data;
  final int? selectedIndex;
  final Function(int index)? onRowSelect;

  const Ttochki({
    super.key,
    required this.data,
    this.selectedIndex,
    this.onRowSelect,
  });

  @override
  State<Ttochki> createState() => _TtochkiState();
}

class _TtochkiState extends State<Ttochki> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: DataTable(
                columnSpacing: 70,
                showCheckboxColumn: true,
                columns: novaTThead(extraText: ttrows),

                rows: List.generate(widget.data.length, (index) {
                  final row = widget.data[index];

                  return DataRow(
                    selected: widget.selectedIndex == index,
                    onSelectChanged: (bool? selected) {
                      if (widget.onRowSelect != null) {
                        widget.onRowSelect!(index);
                      }
                    },
                    cells: row.map((value) {
                      return DataCell(Text(value));
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
