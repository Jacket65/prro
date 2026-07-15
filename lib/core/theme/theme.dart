import 'package:flutter/material.dart';

const MaterialColor primaryColor = Colors.brown;
final Color? dialogBackgroundColor = Colors.brown[50];
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey[300],
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey[800]),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.brown,
      // fixedSize: Size(300, 50),
      // textStyle: TextStyle(fontSize: 52),
    ),
  ),
  dialogTheme: DialogThemeData(backgroundColor: dialogBackgroundColor),
);
