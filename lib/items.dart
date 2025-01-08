import 'package:flutter/material.dart';
import 'package:prro/category_pick.dart';
import 'package:prro/inside_category.dart';

class Items extends StatefulWidget {
  Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => CategoryPick(),
                    ),
                  );
                },
                child: Text(
                  'Новий товар',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blueGrey[50]),
                onPressed: () {},
                child: Text(
                  'Імпорт товарів',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(4),
                icon: Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.grey,
                ),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  backgroundColor: WidgetStatePropertyAll(Colors.blueGrey[50]),
                ),
                onPressed: () {
                  addCategory(context);
                },
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(4),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4))),
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.blueGrey[50]),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Colors.grey,
                  )),
            ],
          ),
          SizedBox(
            height: 20,
            width: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  cursorWidth: 1,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
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
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                primary: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3.5,
                ),
                itemCount: cardTitles.length,
                itemBuilder: (context, index) {
                  return CustomCard(
                    cardTit: cardTitles[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> addCategory(BuildContext context) {
    var input = 'Нова категорія';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Нова категорія'),
              IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel))
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            // height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Назва категрії'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Вкажіть назву категорії',
                        hintStyle: TextStyle(color: Colors.black26)),
                    onChanged: (value) {
                      input = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                  onPressed: () {
                    cardTitles.add(input);
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Зберегти',
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
        );
      },
    );
  }

  var items = ['1', '2', '3', '4', '5'];
}

final List<String> cardTitles = [
  'Холодні напої',
  'Солодощі',
  'Чай ваговий',
  'Додатки',
  'Кава вагова',
  'Кавоварка',
  'Кавоварка',
];

class CustomCard extends StatelessWidget {
  CustomCard({required this.cardTit});
  final String cardTit;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            DialogRoute(
              context: context,
              builder: (context) => InsideCategory(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.folder,
                    color: Colors.grey.shade700,
                    size: 40.0,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    cardTit,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
