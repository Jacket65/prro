import 'package:flutter/material.dart';
import 'package:prro/settings.dart';

void findInDictionary(BuildContext context) {
  var title = 'Пошук ДПІ у довіднику ?';

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: largestCities.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: ExpansionTile(
                          shape: Border(),
                          children: [
                            Container(
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('${largestCities[index]}'),
                                ),
                              ),
                            )
                          ],
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${largestCities[index]}'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                },
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
                    'Вибрати',
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
      });
}
