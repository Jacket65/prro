import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prro/settings.dart';

var currentValue = 1;

class Teller extends StatefulWidget {
  const Teller({super.key});

  @override
  State<Teller> createState() => _TellerState();
}

class _TellerState extends State<Teller> {
  Padding teller(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NewWidget(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Container(
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
          ),
          Row(
            children: [
              Expanded(
                child: DataTable(
                    // border: TableBorder(
                    //   horizontalInside: BorderSide(color: Colors.yellow[200]!),
                    //   bottom: BorderSide(color: Colors.yellow[200]!),
                    //   left: BorderSide(color: Colors.yellow[200]!),
                    //   right: BorderSide(color: Colors.yellow[200]!),
                    // ),
                    dividerThickness: 0,
                    horizontalMargin: 0,
                    showCheckboxColumn: false,
                    columns: tellerTop,
                    rows: [fillTellerRows(extraText: tellerText)]),
              ),
            ],
          ),
          Padding(
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

  DataRow fillTellerRows({required List<String>? extraText}) {
    List<DataCell> a = [];
    for (String i in extraText!) {
      a.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
        child: Text(
          textAlign: TextAlign.center,
          i,
        ),
      )));
    }
    a.add(
      DataCell(
        Container(
          // decoration: BoxDecoration(border: Border.all()),
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.circle,
              color: isActiveTeller ? Colors.green : Colors.red,
              size: 15,
            ),
          ),
        ),
      ),
    );
    return DataRow(
      color: WidgetStatePropertyAll(color333),
      cells: a,
      onSelectChanged: (value) {
        counter++;
        color333 = (counter % 2 == 0 ? Colors.orange[100] : Colors.white)!;
        rowTapSettings = !rowTapSettings;
        setState(() {});
      },
    );
  }

  editTeller(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return teller(context);
  }
}

List<DataColumn> tellerTop =
    novaTThead(showStatus: true, extraText: ['ПІБ', 'Тип', 'Статус в ДПС']);

int counter = 1;
Color color333 = Colors.white;
List<String> tellerText = ['1', '999', '3'];
bool rowTapSettings = false;
bool isActiveTeller = false;

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.blueAccent),
      onPressed: () {
        editT(context);
      },
      child: Text(
        'Реєстрація касира',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  editT(BuildContext context) {
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
                  Divider(),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      DropdownMenu(
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
                      SizedBox(height: 20),
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
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
                  Navigator.of(context).pop();
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
}
