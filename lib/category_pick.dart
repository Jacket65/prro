import 'package:flutter/material.dart';

class CategoryPick extends StatefulWidget {
  CategoryPick({super.key, required this.title});
  final String title;

  @override
  State<CategoryPick> createState() => _CategoryPickState();
}

class _CategoryPickState extends State<CategoryPick> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тип касира'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownMenu(
                onSelected: (value) {},
                initialSelection: 10,
                expandedInsets: EdgeInsets.zero,
                focusNode: FocusNode(canRequestFocus: false),
                trailingIcon: Icon(
                  Icons.arrow_drop_down,
                ),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 1, label: 'Старший касир'),
                  DropdownMenuEntry(value: 2, label: 'Касир'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Тип касира'),
            Checkbox(
              value: checked,
              onChanged: (value) {
                checked = value!;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
