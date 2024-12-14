import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prro/appearance.dart';
import 'package:prro/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class Item {
  final String name;
  final int age;
  final String details;
  bool isExpanded = false;

  Item({required this.name, required this.age, required this.details});
}

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

void changeContent(String newContent) {
  currentContent = newContent;
}

class Increment {}

// class Proba extends State<MainScreen> {
//   String lable = '';
//   Proba(String lable);
//   @override
//   Widget build(BuildContext context) {
//     return topButton(selecteIndexW: selecteIndex, lable: lable);
//   }

//   }
// }

void fillRows({required List<String>? extraText}) {
  List<DataCell> a = [];
  for (String i in extraText!) {
    if (i != 'trikrapki' && i != 'iconDown') {
      a.add(DataCell(Text(
        i,
      )));
    } else if (i == extraText[extraText.length - 2]) {
      a.add(DataCell(IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {},
        icon: Icon(Icons.more_vert),
      )));
    } else if (i == extraText[extraText.length - 1]) {
      a.add(DataCell(IconButton(
        onPressed: () {},
        icon: Icon(Icons.keyboard_arrow_down),
      )));
    }
  }
  rowsName.add(DataRow(
    cells: a,
    onSelectChanged: (value) {},
  ));
}

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

List<Item> _items = [
  Item(name: 'Alice', age: 25, details: 'Alice loves programming.'),
  Item(name: 'Bob', age: 30, details: 'Bob is a Flutter developer.'),
  Item(name: 'Charlie', age: 35, details: 'Charlie likes hiking and coding.'),
];

Widget torgovaTochaka(BuildContext context) {
  return SafeArea(
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DataTable(
                  columnSpacing: 100,
                  horizontalMargin: 0,
                  dataRowMinHeight: 0,
                  dataRowMaxHeight: double.infinity,
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStatePropertyAll(Colors.black12),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(5)),
                  columns: novaTThead(ttrows),
                  rows: rowsName),
            ),
          ],
        ),
      ],
    ),
  );
}
