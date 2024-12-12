import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // This is a custom color variable
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
          title: Text(title),
          content: Text('Діалогове вікно для "$title"'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрити'),
            ),
          ],
        );
      },
    );
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              selecteIndex = 1;
                              _changeContent('Торгові точки та ПРРО');
                            },
                            child: Text(
                              'Торгові точки та ПРРО',
                              style: TextStyle(
                                  color: selecteIndex == 1
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                          ),
                          ColoredBox(
                              child: SizedBox(
                                height: 2,
                                width: double.infinity,
                              ),
                              color: Colors.blue)
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selecteIndex = 2;
                        _changeContent('Касири');
                      },
                      child: Text(
                        'Касири',
                        style: TextStyle(
                            color:
                                selecteIndex == 2 ? Colors.black : Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selecteIndex = 3;
                        _changeContent('Товари');
                      },
                      child: Text(
                        'Товари',
                        style: TextStyle(
                            color:
                                selecteIndex == 3 ? Colors.black : Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selecteIndex = 4;
                        _changeContent('Журнал');
                      },
                      child: Text(
                        'Журнал',
                        style: TextStyle(
                            color:
                                selecteIndex == 4 ? Colors.black : Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selecteIndex = 5;
                        _changeContent('Звіти');
                      },
                      child: Text(
                        'Звіти',
                        style: TextStyle(
                            color:
                                selecteIndex == 5 ? Colors.black : Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selecteIndex = 6;
                        _changeContent('Помилки');
                      },
                      child: Text(
                        'Помилки',
                        style: TextStyle(
                            color:
                                selecteIndex == 6 ? Colors.black : Colors.grey),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.blueAccent),
                  onPressed: () => _showDialog('Нова торгова точка'),
                  child: Text(
                    'Нова торгова точка',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  _currentContent,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
