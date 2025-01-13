import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prro/main_screen/main_screen_widgets/find_in_dictionary.dart';

import 'package:prro/main_screen/main_screen.dart';
import 'package:prro/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        // useMaterial3: true,
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
