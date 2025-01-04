import 'package:flutter/material.dart';

class CategoryPick extends StatefulWidget {
  CategoryPick();

  @override
  State<CategoryPick> createState() => _CategoryPickState();
}

class _CategoryPickState extends State<CategoryPick> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Новий товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Тип касира'),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownMenu(
                hintText: "Вибрати категорію",
                onSelected: (value) {},
                initialSelection: 10,
                expandedInsets: EdgeInsets.zero,
                focusNode: FocusNode(canRequestFocus: false),
                trailingIcon: Icon(
                  Icons.arrow_drop_down,
                ),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 1, label: 'Старший касир'),
                  DropdownMenuEntry(value: 2, label: 'Касир'),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Тип касира'),
            Checkbox(
              value: checked,
              onChanged: (value) {
                checked = value!;
                setState(() {});
              },
            ),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      cursorWidth: 1,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Пошук по категоріям',
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: SizedBox(
                    // width: 200,
                    // height: 40,
                    child: DropdownMenu(
                      inputDecorationTheme: InputDecorationTheme(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        constraints:
                            BoxConstraints.tight(const Size.fromHeight(36)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      hintText: "Вибрати категорію",
                      onSelected: (value) {},
                      initialSelection: 10,
                      // expandedInsets: EdgeInsets.zero,
                      focusNode: FocusNode(canRequestFocus: false),
                      trailingIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 1, label: 'Старший касир'),
                        DropdownMenuEntry(value: 2, label: 'Касир'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: TextField(
                      cursorWidth: 1,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        hintText: 'Пошук по категоріям',
                        hintStyle: TextStyle(color: Colors.grey),
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
                Text('Зміна ціни')
              ],
            ),
            Row(
              children: [
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
                Text('Зміна ваги')
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kod'),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        cursorWidth: 1,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: 'Пошук по категоріям',
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
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kod'),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        cursorWidth: 1,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: 'Пошук по категоріям',
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
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kod'),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        cursorWidth: 1,
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: 'Пошук по категоріям',
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
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Створити',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Скасувати'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
