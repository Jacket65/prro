import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentContent = 'Торгові точки та ПРРО';
  int selecteIndex = 1;
  List<DataColumn> columsName = [
    DataColumn(
      label: Text('1232123'),
    ),
    DataColumn(label: Text('222'))
  ];
  List<DataRow> rowsName = [];

  void newMethod({String name = '', String adress = ''}) {
    rowsName.add(DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(adress)),
    ]));
    setState(() {});
  }

  void _changeContent(String newContent) {
    setState(() {
      _currentContent = newContent;
    });
  }

  void _showDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }

  List<String> largestCities = [
    'Київ',
    'Харків',
    'Одеса',
    'Дніпро',
    'Донецьк',
    'Запоріжжя',
    'Львів',
    'Кривий Ріг',
    'Миколаїв',
    'Маріуполь'
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Програмний ПРРО "Каса"'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      topButton(
                          lable: 'Торгові точки та ПРРО', selecteIndex: 1),
                      topButton(lable: 'Касири', selecteIndex: 2),
                      topButton(lable: 'Товари', selecteIndex: 3),
                      topButton(lable: 'Журнал', selecteIndex: 4),
                      topButton(lable: 'Звіти', selecteIndex: 5),
                      topButton(lable: 'Помилки', selecteIndex: 6),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.blueAccent),
                    onPressed: () {
                      newMethod(name: 'vasa', adress: 'sasa');
                      _showDialog('Зазначте код ДПІ');
                    },
                    child: Text(
                      'Нова торгова точка',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              switch (_currentContent) {
                'Торгові точки та ПРРО' => torgovaTochaka(context),
                _ => Text('В процесі'),
              },
              SizedBox(
                height: 20,
              ),
              // Container(
              //   // padding: EdgeInsets.all(8),
              //   // width: 500,
              //   child: Table(
              //     children: [
              //       TableRow(
              //           decoration: BoxDecoration(
              //               color: Colors.black12,
              //               border: Border.all(color: Colors.black12),
              //               borderRadius: BorderRadius.vertical(
              //                   top: Radius.circular(5),
              //                   bottom: Radius.circular(0))),
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('Назва'),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('Адреса'),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('ID ритейлера'),
              //             ),
              //           ]),
              //       TableRow(
              //           decoration: BoxDecoration(
              //               border: BorderDirectional(
              //             start: BorderSide(),
              //             end: BorderSide(),
              //           )),
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(
              //                 '123',
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //           ]),
              //       TableRow(
              //           decoration: BoxDecoration(
              //               border: BorderDirectional(
              //             start: BorderSide(),
              //             end: BorderSide(),
              //           )),
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(
              //                 '123',
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //           ]),
              //       TableRow(
              //           decoration: BoxDecoration(
              //               border: BorderDirectional(
              //                   start: BorderSide(),
              //                   end: BorderSide(),
              //                   bottom: BorderSide())),
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(
              //                 '123',
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text('2'),
              //             ),
              //           ]),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Row torgovaTochaka(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: DataTable(
                headingRowColor: WidgetStatePropertyAll(Colors.black12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(5)),
                columns: columsName,
                rows: rowsName),
          ),
        ),
      ],
    );
  }

  Container topButton({required int selecteIndex, required String lable}) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: this.selecteIndex == selecteIndex
                  ? Colors.blue
                  : Colors.white,
              width: 2,
            ))),
            child: TextButton(
              onPressed: () {
                this.selecteIndex = selecteIndex;
                _changeContent(lable);
              },
              child: Text(
                lable,
                style: TextStyle(
                    color: this.selecteIndex == selecteIndex
                        ? Colors.black
                        : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
