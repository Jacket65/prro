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
List<DataColumn> novaTThead([List<String>? extraText]) {
  List<DataColumn> list = [];
  for (String i in extraText!) {
    list.add(
      DataColumn(label: Flexible(child: FittedBox(child: Text(i)))),
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

List<String> ttrows = [
  'Назва',
  'Адреса',
  'ID ритейлера',
  'Ідентифікатор',
  'Статус у ДПС',
  'Дії',
  ''
];
