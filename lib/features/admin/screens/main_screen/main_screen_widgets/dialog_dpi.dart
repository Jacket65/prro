import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/features/admin/screens/main_screen/main_screen_widgets/find_in_dictionary.dart';

class DialogDpi extends StatefulWidget {
  const DialogDpi({
    required this.title,
    required this.rowsName,
    required this.fillRows,
    super.key,
  });
  final String title;
  final List<DataRow> rowsName;

  final void Function({
    required List<String> rowData,
    required List<DataRow> rowsList,
    required int rowIndex,
  })
  fillRows;

  @override
  State<DialogDpi> createState() => _DialogDpiState();
}

class _DialogDpiState extends State<DialogDpi> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        // height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 300,
                        child: Text(
                          '''
Виберіть ДПІ за своїм місцем обліку.
                          Ці дані збережуться у розділі Моя компанія.''',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Код ДПІ'),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await findInDictionary(context);
                            },
                          text: 'Вибрати в довіднику',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введіть код ДПІ',
                  hintStyle: TextStyle(color: Colors.black26),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            TextButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.blue),
              ),
              onPressed: () {
                widget.fillRows(
                  rowData: rowsText,
                  rowsList: widget.rowsName,
                  rowIndex: 0,
                );
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text(
                'Зберегти',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Скасувати'),
            ),
          ],
        ),
      ],
    );
  }
}
