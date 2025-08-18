import 'package:flutter/material.dart';
import 'package:prro/features/seller/widgets/seller_list_item.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  bool isTextFieldShown = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],

        title: Row(
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              label: const Text("Столи", style: TextStyle(color: Colors.white)),
            ),
            PopupMenuButton(
              tooltip: "",
              icon: TextButton.icon(
                onPressed: null,
                icon: Icon(Icons.menu, color: Colors.white),
                label: const Text(
                  "Меню",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              offset: Offset(00, 40),

              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Item 1'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.anchor),
                        title: Text('Item 2'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.article),
                        title: Text('Item 3'),
                      ),
                    ),

                    const PopupMenuDivider(),
                    const PopupMenuItem(child: Text('Item A')),
                    const PopupMenuItem(child: Text('Item B')),
                  ],
            ),

            PopupMenuButton(
              tooltip: "",
              icon: TextButton.icon(
                onPressed: null,
                icon: Icon(Icons.attach_money_sharp, color: Colors.white),
                label: const Text(
                  "Каса",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              offset: Offset(00, 40),

              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Item 1'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.anchor),
                        title: Text('Item 2'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.article),
                        title: Text('Item 3'),
                      ),
                    ),

                    const PopupMenuDivider(),
                    const PopupMenuItem(child: Text('Item A')),
                    const PopupMenuItem(child: Text('Item B')),
                  ],
            ),
            const Spacer(),

            AnimatedSwitcher(
              duration: Duration(seconds: 2),

              child: TextButton.icon(
                onPressed: null,
                icon: Icon(Icons.search, color: Colors.white),

                label: SizedBox(
                  width: 100,
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration.collapsed(
                      hintText: "Пошук",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // label: const Text("Пошук", style: TextStyle(color: Colors.white)),
              ),
            ),
            PopupMenuButton(
              tooltip: "",
              icon: IconButton(
                onPressed: null,
                icon: Badge.count(
                  offset: Offset(10, 10),
                  count: 0,
                  isLabelVisible: true,
                  child: Icon(Icons.notifications, color: Colors.white),
                ),
              ),

              offset: Offset(00, 40),

              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Item 1'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.anchor),
                        title: Text('Item 2'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.article),
                        title: Text('Item 3'),
                      ),
                    ),

                    const PopupMenuDivider(),
                    const PopupMenuItem(child: Text('Item A')),
                    const PopupMenuItem(child: Text('Item B')),
                  ],
            ),

            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.lock, color: Colors.white),
              label: const Text("test", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 350,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),

                    child: Row(
                      children: [
                        TextButton(onPressed: () {}, child: Icon(Icons.add)),
                        SizedBox(width: 4),
                        SizedBox(
                          width: 250,
                          height: 30,
                          child: ListView.separated(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    DateTime.now()
                                        .toString()
                                        .split(' ')[1]
                                        .split('.')[0],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return SizedBox(width: 4);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text("Канал замовлення:"),
                          Text("Замовлення №:"),
                          Text("Стіл 1"),
                          Text("Працівник:"),
                          SizedBox(height: 15),
                          Divider(),
                          SizedBox(height: 8),

                          Expanded(
                            child: ListView.separated(
                              itemCount: 7,

                              itemBuilder: (context, index) {
                                return Column(children: [ListItem()]);
                              },
                              separatorBuilder: (_, _) {
                                return Divider();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Разом: 52 грін",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.manage_accounts_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.percent_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.mail_outline),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.cut_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.print_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.menu_outlined),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                shape: BeveledRectangleBorder(),
                                padding: EdgeInsets.zero,
                                minimumSize: Size(double.maxFinite, 80),
                                backgroundColor: Colors.green,
                              ),
                              child: Text("ОПЛАТА"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.house_rounded),
                      ),
                      PopupMenuButton(
                        tooltip: "",
                        icon: Icon(Icons.compare_arrows_outlined),

                        offset: Offset(00, 40),

                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry>[
                              const PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.add),
                                  title: Text('Item 1'),
                                ),
                              ),
                              const PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.anchor),
                                  title: Text('Item 2'),
                                ),
                              ),
                              const PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.article),
                                  title: Text('Item 3'),
                                ),
                              ),

                              const PopupMenuDivider(),
                              const PopupMenuItem(child: Text('Item A')),
                              const PopupMenuItem(child: Text('Item B')),
                            ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                      ),

                      itemBuilder: (context, index) {
                        return Card(color: Colors.white);
                      },
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
