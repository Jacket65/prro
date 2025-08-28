import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/models.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles_bloc.dart';
import 'package:prro/features/seller/widgets/seller_list_item.dart';

final List<Category> listOfCategories = [
  Category(
    id: '1',
    name: 'Електроніка',
    items: [
      Category(
        id: '1_1',
        name: 'Мобільні телефони',
        items: [
          Product(
            id: '1',
            name: 'iPhone 13',
            price: 999,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '2',
            name: 'Samsung Galaxy',
            price: 799,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
      Category(
        id: '1_2',
        name: 'Ноутбуки',
        items: [
          Product(
            id: '3',
            name: 'MacBook Pro',
            price: 1999,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '4',
            name: 'Dell XPS',
            price: 1499,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '9',
            name: 'xiaomi',
            price: 42,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
    ],
  ),
  Category(
    id: '2',
    name: 'Одежда',

    items: [
      Category(
        id: '2_1',
        name: 'Чоловіча',
        items: [
          Product(
            id: '5',
            name: 'Футболка',
            price: 29.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '6',
            name: 'Штани',
            price: 49.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
      Category(
        id: '2_2',
        name: 'Жіноча',
        items: [
          Product(
            id: '7',
            name: 'Сукня',
            price: 59.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
          Product(
            id: '8',
            name: 'Топ',
            price: 19.99,
            imageUrl:
                'https://www.foodandwine.com/thmb/cUck29eCdcIEjx_r5Q5ReugKoNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Fraiser-cake-FT-RECIPES0624-e9972b38ccb54d3ca8edbbb9a5bb1642.jpeg',
          ),
        ],
      ),
    ],
  ),
];

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
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              backgroundColor: Colors.grey[800],

              title: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    label: const Text(
                      "Назад",
                      style: TextStyle(color: Colors.white),
                    ),
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
                    ),
                  ),
                  PopupMenuButton(
                    tooltip: "",
                    icon: IconButton(
                      onPressed: null,
                      icon: Badge.count(
                        offset: Offset(10, 10),
                        count: 0,
                        isLabelVisible: false,
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
                    label: Text(
                      state.username,
                      style: TextStyle(color: Colors.white),
                    ),
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
                              Container(
                                height: 30,
                                width: 30,

                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  border: Border(
                                    top: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                child: IconButton(
                                  padding: EdgeInsets.zero,

                                  onPressed: () {},
                                  icon: Icon(Icons.add_outlined, size: 15),
                                ),
                              ),
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
                                          right: BorderSide(
                                            color: Colors.black,
                                          ),
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

                                Text("Працівник: ${state.username}"),
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

                BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
                  builder: (context, state) {
                    if (state is ItemsTilesInitial) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<ItemsTilesBloc>().add(
                                        GetInitialItemsTiles(),
                                      );
                                    },
                                    icon: Icon(Icons.house_rounded),
                                  ),
                                  PopupMenuButton(
                                    tooltip: "",
                                    icon: Icon(Icons.compare_arrows_outlined),

                                    offset: Offset(00, 40),

                                    itemBuilder:
                                        (BuildContext context) =>
                                            <PopupMenuEntry>[
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
                                              const PopupMenuItem(
                                                child: Text('Item A'),
                                              ),
                                              const PopupMenuItem(
                                                child: Text('Item B'),
                                              ),
                                            ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 250,
                                      ),

                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      child: ShowItem(listOfCategories[index]),
                                    );
                                  },
                                  itemCount: listOfCategories.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ItemsTilesSelected) {
                      final item = state.item;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<ItemsTilesBloc>().add(
                                        GetInitialItemsTiles(),
                                      );
                                    },
                                    icon: Icon(Icons.house_rounded),
                                  ),
                                  PopupMenuButton(
                                    tooltip: "",
                                    icon: Icon(Icons.compare_arrows_outlined),

                                    offset: Offset(00, 40),

                                    itemBuilder:
                                        (BuildContext context) =>
                                            <PopupMenuEntry>[
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
                                              const PopupMenuItem(
                                                child: Text('Item A'),
                                              ),
                                              const PopupMenuItem(
                                                child: Text('Item B'),
                                              ),
                                            ],
                                  ),
                                ],
                              ),
                              if (item is Category) ...{
                                Text("${item.name}"),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 250,
                                        ),

                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.white,
                                        child: ShowItem(item.items[index]),
                                      );
                                    },
                                    itemCount: item.items.length,
                                  ),
                                ),
                              },
                              // else if (item is Product) ...{
                              //   //TODO: Натиснення на продукт
                              //   Expanded(
                              //     child: GridView.builder(
                              //       gridDelegate:
                              //           SliverGridDelegateWithMaxCrossAxisExtent(
                              //             maxCrossAxisExtent: 250,
                              //           ),
                              //       itemBuilder: (context, index) {
                              //         return Card(
                              //           color: Colors.white,
                              //           child: ShowItem(item),
                              //         );
                              //       },
                              //       itemCount: listOfCategories.length,
                              //     ),
                              //   ),
                              // },
                            ],
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ShowItem<T extends Item> extends StatelessWidget {
  final T item;
  const ShowItem._({super.key, required this.item});

  factory ShowItem(T item) {
    return ShowItem._(item: item);
  }

  @override
  Widget build(BuildContext context) {
    if (item is Product) {
      final product = item as Product;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          log('product');
          // context.read<ItemsTilesBloc>().add(SelectedItemsTiles(product));
          //TODO: Логіка для переходу на деталі товару
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (product.imageUrl != null)
              Image.network(
                product.imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    } else if (item is Category) {
      final category = item as Category;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          log('category');
          context.read<ItemsTilesBloc>().add(SelectedItemsTiles(category));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
