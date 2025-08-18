import 'package:flutter/material.dart';

const primaryColor = Colors.brown;
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
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
);
