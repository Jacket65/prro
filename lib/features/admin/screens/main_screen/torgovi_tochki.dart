import 'package:flutter/material.dart';
import 'package:prro/core/constants/settings.dart';

class Ttochki extends StatefulWidget {
  const Ttochki({
    required this.data,
    super.key,
    this.selectedIndex,
    this.onRowSelect,
  });
  final List<List<String>> data;
  final int? selectedIndex;
  final void Function(int index)? onRowSelect;

  @override
  State<Ttochki> createState() => _TtochkiState();
}

class _TtochkiState extends State<Ttochki> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: DataTable(
                columnSpacing: 70,
                columns: novaTThead(extraText: ttrows),

                rows: List.generate(widget.data.length, (index) {
                  final row = widget.data[index];

                  return DataRow(
                    selected: widget.selectedIndex == index,
                    onSelectChanged: (selected) {
                      if (widget.onRowSelect != null) {
                        widget.onRowSelect?.call(index);
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
