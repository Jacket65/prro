import 'package:flutter/material.dart';

List<DataRow> rowsName = [];
List<String> rowsText = [
  'Кафе',
  'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, w',
  '88005553535',
  '228',
  'зареєстровано',
  'trikrapki',
  'iconDown'
];
List<String> ttrows = [
  'Назва',
  'Адреса',
  'ID ритейлера',
  'Ідентифікатор',
  'Статус у ДПС',
  'Дії',
  ''
];

List<DataColumn> novaTThead(
    {bool showStatus = false, List<String>? extraText}) {
  List<DataColumn> list = [];
  for (String i in extraText!) {
    list.add(
      DataColumn(
          label: Expanded(
              child: Text(
        i,
        softWrap: true,
      ))),
      // DataColumn(label: Flexible(child: FittedBox(child: Text(i)))),
    );
  }
  if (showStatus) {
    list.add(
      DataColumn(
          label: Expanded(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Стан активності',
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ))),
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
  'Маріуполь'
];
String currentContent = 'Торгові точки та ПРРО';

int selecteIndex = 1;
List<DataRow> listOfTllers = [];
List<List<String>> tellerGroup = [];
List<String> tellerText = [
  'Зеленський Володимир Олександрович',
  '1',
  'Зареєстрований',
  'Inactive'
];
List<String> tellerTextN = [
  'Зеленський Володимир Олександрович',
  '1',
  'Зареєстрований',
  'Active'
];
var currentValue = 1;

Color color333 = Colors.white;
bool counter = false;
bool rowTapSettings = false;

int lastCategory = 0;
