import 'package:flutter/material.dart';
import 'package:prro/main.dart';
import 'package:prro/settings.dart';
import 'package:prro/teller.dart';

class porba extends StatefulWidget {
  const porba({super.key});

  @override
  State<StatefulWidget> createState() => SomeWidgetState();
}

class SomeWidgetState extends State<porba> {
  @override
  Widget build(BuildContext context) {
    return Text('1');
  }
}

int counter = 1;

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Color color123 = counter % 2 == 0 ? Colors.black : Colors.red;
        counter += 1;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                children: [
                  Text('$counter'),
                  Container(
                      decoration: BoxDecoration(
                    border: Border.all(color: color123),
                  ))
                ],
              ),
            );
          },
        );
      },
      child: const Text('2'),
    );
  }
}

class MainScreenState extends State<MainScreen> {
  Padding topButton({required int selecteIndexW, required String lable}) {
    final Increment _increment = Increment();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: Column(
          children: [
            MyWidget(),
            porba(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color:
                    selecteIndex == selecteIndexW ? Colors.blue : Colors.white,
                width: 2,
              ))),
              child: TextButton(
                onPressed: () {
                  selecteIndex = selecteIndexW;
                  changeContent(lable);
                  setState(() {});
                },
                child: Text(
                  lable,
                  style: TextStyle(
                      color: selecteIndex == selecteIndex
                          ? Colors.black
                          : Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogFunc(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowDialogFunc1(title, context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return MainScreenWidget();

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
                          lable: 'Торгові точки та ПРРО', selecteIndexW: 1),
                      topButton(lable: 'Касири', selecteIndexW: 2),
                      topButton(lable: 'Товари', selecteIndexW: 3),
                      topButton(lable: 'Журнал', selecteIndexW: 4),
                      topButton(lable: 'Звіти', selecteIndexW: 5),
                      topButton(lable: 'Помилки', selecteIndexW: 6),
                    ],
                  ),
                  if (currentContent == 'Торгові точки та ПРРО')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.blueAccent),
                      onPressed: () {
                        showDialogFunc('Зазначте код ДПІ');
                        fillRows(extraText: rowsText);
                        setState(() {});
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
              switch (currentContent) {
                'Торгові точки та ПРРО' => torgovaTochaka(context),
                'Касири' => teller(context),
                _ => Text('В процесі'),
              },
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
