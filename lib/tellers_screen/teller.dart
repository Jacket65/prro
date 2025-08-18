import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:prro/main_screen/main_screen_widgets/find_in_dictionary.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/tellers_screen/cells.dart';
import 'package:prro/tellers_screen/fill_teller_rows.dart';

class Teller extends StatefulWidget {
  const Teller({super.key});

  @override
  State<Teller> createState() => TellerState();
}

void select_teller(List<String> extraText) {
  counter = !counter;

  rowTapSettings = !rowTapSettings;
  color333 = (counter ? Colors.orange[100] : Colors.white)!;
  // listOfTllers[id] = fillTellerRows(extraText: extraText);
}

class TellerState extends State<Teller> {
  List<DataRow> createTellerRows() {
    return List.generate(listOfTllers.length, (index) {
      return DataRow(
        color: WidgetStatePropertyAll(
            _selectedRowIndex == index ? Colors.orange[100] : Colors.white),
        cells: cells(tellerGroup[index]),
        onSelectChanged: (bool? selected) {
          _selectedRowIndex = _selectedRowIndex == index ? -1 : index;

          rowTapSettings = _selectedRowIndex == index ? true : false;

          setState(() {});
        },
      );
    });
  }

  int _selectedRowIndex = -1;

  editTeller(BuildContext context) {
    isActiveTeller =
        tellerGroup[_selectedRowIndex].last == 'Active' ? true : false;

    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AlertDialog(
            shape: BeveledRectangleBorder(),
            alignment: Alignment.topCenter,
            title: Text('Редагування касира'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 10),
                      Text('ПІБ'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Стан Активності:'),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Switch(
                            value: isActiveTeller,
                            activeColor: Colors.blueAccent,
                            onChanged: (bool value) {
                              isActiveTeller = value;

                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  var row = tellerGroup[_selectedRowIndex];
                  tellerGroup[_selectedRowIndex] = isActiveTeller
                      ? row.sublist(0, row.length - 1) + ['Active']
                      : row.sublist(0, row.length - 1) + ['inact'];

                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text('Зберегти'),
              ),
              TextButton(
                onPressed: () {
                  isActiveTeller = rowTapSettings;
                  Navigator.of(context).pop();
                },
                child: Text('Скасувати'),
              ),
            ],
          ),
        );
      },
    );
  }

  String PIB = '';
  int? tellerType = 1;
  var tleer = {1: "Старший касир", 2: "Касир"};
  editT(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: AlertDialog(
            shape: BeveledRectangleBorder(),
            alignment: Alignment.topCenter,
            title: Text('Реєстрація касира'),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ІПН касира'),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  cursorWidth: 1,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    hintText: 'Вкажіть ІПН касира',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Colors.white,
                                    focusColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.search)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text('ПІБ'),
                          TextField(
                            onChanged: (value) {
                              PIB = value;
                            },
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 20),
                          Text('Код ДПІ'),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {}, child: Text('Перевірити')),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    findInDictionary(context);
                                  },
                                  child: Text('Знайти у довіднику'))
                            ],
                          ),
                          SizedBox(height: 20),
                          Text('Тип касира'),
                          DropdownMenu(
                            onSelected: (value) {
                              tellerType = value;
                            },
                            initialSelection: 10,
                            expandedInsets: EdgeInsets.zero,
                            focusNode: FocusNode(canRequestFocus: false),
                            trailingIcon: Icon(
                              Icons.arrow_drop_down,
                            ),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: 1, label: 'Старший касир'),
                              DropdownMenuEntry(value: 2, label: 'Касир'),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text('Вкажіть пароль від SmartID'),
                          TextField(
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                      Text(
                        'Подання форми про надання інформації про кваліфікований сертифікат відкритого ключа до ДПС',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  sendJsonData();
                  listOfTllers.add(fillTellerRows(extraText: [
                    PIB,
                    tellerType.toString(),
                    'Зареєстрований',
                    'Inactive'
                  ]));
                  tellerGroup.add(
                      [PIB, tleer[tellerType]!, 'Зареєстрований', 'Inactive']);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: Text('Надіслати запит'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Скасувати'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendJsonData() async {
    // final url = Uri.parse('http://localhost:8080/admin/sellers');
    final response =
        await http.get(Uri.parse('http://localhost:8080/admin/sellers'));

    if (response.statusCode == 200) {
      print(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }

    // final data = {
    //   'phone_number': '+38052',
    //   'first_name': 'mama',
    //   'second_name': "sasa",
    //   'password': "12345",
    // };

    // final body = json.encode(data);

    // try {
    //   // Send a POST request with JSON data
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Content-Type': 'application/json', // Set header for JSON content
    //     },
    //     body: body, // The JSON body
    //   );

    //   // Check if the request was successful
    //   if (response.statusCode == 200) {
    //     print('Data sent successfully');
    //     print('Response body: ${response.body}');
    //   } else {
    //     print('Failed to send data: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  editT(context);
                },
                child: Text(
                  'Реєстрація касира',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                // decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        cursorWidth: 1,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: 'Пошук касира ПІБ',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 168, 168, 168),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          // width: 300,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Інформація по касирам',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                          visible: rowTapSettings,
                          child: Row(
                            children: [
                              Icon(
                                Icons.drive_file_rename_outline_rounded,
                                color: Colors.grey,
                              ),
                              TextButton(
                                child: Text(
                                  'Редагувати',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {
                                  editTeller(context);
                                },
                              ),
                              Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.grey,
                              ),
                              TextButton(
                                child: Text(
                                  'Видалити',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.replay_outlined,
                        ),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      // border: TableBorder(
                      //   horizontalInside: BorderSide(color: Colors.yellow[200]!),
                      //   bottom: BorderSide(color: Colors.yellow[200]!),
                      //   left: BorderSide(color: Colors.yellow[200]!),
                      //   right: BorderSide(color: Colors.yellow[200]!),
                      // ),
                      // dividerThickness: 0,
                      showBottomBorder: true,
                      horizontalMargin: 0,
                      showCheckboxColumn: false,
                      columns: tellerTop,
                      rows: createTellerRows(),
                      // rows: listOfTllers,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Записів на сторінці'),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: 130,
                  child: DropdownMenu(
                    initialSelection: 10,
                    expandedInsets: EdgeInsets.zero,
                    focusNode: FocusNode(canRequestFocus: false),
                    trailingIcon: Icon(
                      Icons.arrow_drop_down,
                    ),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: 5, label: '5'),
                      DropdownMenuEntry(value: 10, label: '10'),
                      DropdownMenuEntry(value: 15, label: '15'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text('1 із 1'),
                ),
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    onPressed: null,
                    icon: Icon(Icons.skip_previous_outlined)),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  onPressed: null,
                  icon: Icon(Icons.navigate_before),
                ),
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    onPressed: null,
                    icon: Icon(Icons.navigate_next)),
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    onPressed: null,
                    icon: Icon(Icons.skip_next_outlined)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

bool isActiveTeller = false;

final user = jsonDecode('''
{
  "items": [
    {
      "name": "foo1",
      "surname": "lox1",
      "status": "lox1",
      "status2": "Inactive"
    },
    {
      "name": "foo2",
      "surname": "lox2",
      "status": "lox2",
      "status2": "Inactive"
    },
    {
      "name": "foo2",
      "surname": "lox2",
      "status": "lox2",
      "status2": "Inactive"
    },
    {
      "name": "foo2",
      "surname": "lox2",
      "status": "lox2",
      "status2": "Inactive"
    },
    {
      "name": "foo2",
      "surname": "lox2",
      "status": "lox2",
      "status2": "Inactive"
    },
    {
      "name": "foo3",
      "surname": "lox3",
      "status": "lox3",
      "status2": "Inactive"
    }
  ]
}
''');

final initUser = user["items"];
final userLenght = initUser.length;
List<DataColumn> tellerTop =
    novaTThead(showStatus: true, extraText: ['ПІБ', 'Тип', 'Статус в ДПС']);
