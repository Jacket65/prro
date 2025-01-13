import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prro/main_screen/main_screen_widgets/find_in_dictionary.dart';

AlertDialog ShowDialogFunc1(String title, BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.cancel))
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
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 300,
                      child: Text(
                          'Виберіть ДПІ за своїм місцем обліку. Ці дані збережуться у розділі Моя компанія.'),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Код ДПІ'),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            findInDictionary(context);
                          },
                        text: 'Вибрати в довіднику',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введіть код ДПІ',
                  hintStyle: TextStyle(color: Colors.black26)),
            ),
          ],
        ),
      ),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Зберегти',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Скасувати'),
          ),
        ],
      ),
    ],
  );
}
