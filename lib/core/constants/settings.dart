import 'package:flutter/material.dart';

List<String> rowsText = [
  'Кафе',
  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',

  '88005553535',
  '228',
  'зареєстровано',
  'trikrapki',
  'iconDown',
];
List<String> ttrows = [
  'Назва',
  'Адреса',
  'ID ритейлера',
  'Ідентифікатор',
  'Статус у ДПС',
  'Дії',
  '',
];

List<DataColumn> novaTThead({
  bool showStatus = false,
  List<String>? extraText,
}) {
  final list = <DataColumn>[];
  for (final i in extraText!) {
    list.add(
      DataColumn(label: Expanded(child: Text(i, softWrap: true))),
      // DataColumn(label: Flexible(child: FittedBox(child: Text(i)))),
    );
  }
  if (showStatus) {
    list.add(
      const DataColumn(
        label: Expanded(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Стан активності',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ),
      ),
      // DataColumn(label: Flexible(child: FittedBox(child: Text(i)))),
    );
  }
  return list;
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
  'Маріуполь',
];
List<DataRow> listOfTllers = [];

List<String> tellerText = [
  'Зеленський Володимир Олександрович',
  '1',
  'Зареєстрований',
  'Inactive',
];
List<String> tellerTextN = [
  'Зеленський Володимир Олександрович',
  '1',
  'Зареєстрований',
  'Active',
];
int currentValue = 1;

bool counter = false;
bool rowTapSettings = false;

int lastCategory = 0;
