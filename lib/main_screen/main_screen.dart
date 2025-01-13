import 'package:flutter/material.dart';
import 'package:prro/main_screen/main_screen_widgets/fill_rows.dart';

import 'package:prro/items.dart';
import 'package:prro/main.dart';
import 'package:prro/main_screen/trade_place.dart';
import 'package:prro/settings.dart';
import 'package:prro/main_screen/main_screen_widgets/show_dialog_func1.dart';
import 'package:prro/tellers_screen/fill_teller_rows.dart';
import 'package:prro/tellers_screen/teller.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Padding topBarButtons({required int selecteIndexW, required String lable}) {
    // final Increment _increment = Increment();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: Column(
          children: [
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
                      color: selecteIndex == selecteIndexW
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

  void changeContent(String newContent) {
    currentContent = newContent;
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
  void initState() {
    for (int i = 0; i < userLenght; i++) {
      listOfTllers.add(fillTellerRows(extraText: [
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["status2"],
      ]));
      tellerGroup.add([
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["name"],
        initUser[i]["status2"],
      ]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Програмний ПРРО "Каса"'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          topBarButtons(
                              lable: 'Торгові точки та ПРРО', selecteIndexW: 1),
                          topBarButtons(lable: 'Касири', selecteIndexW: 2),
                          topBarButtons(lable: 'Товари', selecteIndexW: 3),
                          topBarButtons(lable: 'Журнал', selecteIndexW: 4),
                          topBarButtons(lable: 'Звіти', selecteIndexW: 5),
                          topBarButtons(lable: 'Помилки', selecteIndexW: 6),
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
                ],
              ),
              switch (currentContent) {
                'Торгові точки та ПРРО' => ttochki(),
                'Касири' => Teller(),
                'Товари' => Items(),
                _ => Text('В процесі'),
              },
            ],
          ),
        ),
      ),
    );
  }
}
