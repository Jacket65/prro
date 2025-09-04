import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/data/models/models.dart';
import 'package:prro/data/services/services.dart';
import 'package:prro/features/auth/auth.dart';
import 'package:prro/features/auth/bloc/login_bloc.dart';
import 'package:prro/features/seller/bloc/items_tiles_bloc.dart';
import 'package:prro/features/seller/bloc/orders_list_bloc.dart';
import 'package:prro/features/seller/widgets/check_bottom_buttons.dart';
import 'package:prro/features/seller/widgets/check_main_info.dart';
import 'package:prro/features/seller/widgets/check_pay_button.dart';
import 'package:prro/features/seller/widgets/check_top_bar_with_time.dart';
import 'package:prro/features/seller/widgets/custom_popup_menu.dart';
import 'package:prro/features/seller/widgets/search_field.dart';

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
                    onPressed: () => _navigateBack(context),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  CustomPopupMenu(name: "Меню", icon: Icons.menu),
                  CustomPopupMenu(name: "Каса", icon: Icons.attach_money_sharp),
                  const Spacer(),
                  SearchField(),
                  CustomPopupMenu(name: '', icon: Icons.notifications),
                  CustomPopupMenu(name: state.username, icon: Icons.lock),
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
                      CheckTopBarWithTime(),
                      CheckMainInfo(),
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
                            CheckBottomButtons(),
                            CheckPayButton(),
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
                                  CustomPopupMenu(
                                    name: "",
                                    icon: Icons.compare_arrows_outlined,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              ProductTiles(),
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
                                  CustomPopupMenu(
                                    name: "",
                                    icon: Icons.compare_arrows_outlined,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              if (item is Category) ...[
                                // ItemNameText(),
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
                              ] else if (item is Product) ...[
                                ItemNameText(),
                                //TODO: Натиснення на продукт

                                // Expanded(
                                //   child: GridView.builder(
                                //     gridDelegate:
                                //         SliverGridDelegateWithMaxCrossAxisExtent(
                                //           maxCrossAxisExtent: 250,
                                //         ),
                                //     itemBuilder: (context, index) {
                                //       return Card(
                                //         color: Colors.white,
                                //         child: ShowItem(item),
                                //       );
                                //     },
                                //     itemCount: 1,
                                //   ),
                                // ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
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

  void _navigateBack(BuildContext context) {
    context.read<LoginBloc>().add(LoginGetInitial());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

class ItemNameText extends StatelessWidget {
  const ItemNameText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTilesBloc, ItemsTilesState>(
      buildWhen: (previous, current) {
        return previous is ItemsTilesSelected &&
            current is ItemsTilesSelected &&
            previous.item != current.item;
      },
      builder: (context, state) {
        if (state is ItemsTilesSelected) {
          final item = state.item;
          if (item is Product) {
            return Text(item.name);
          } else if (item is Category) {
            return Text(item.name);
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ProductTiles extends StatelessWidget {
  const ProductTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
          context.read<OrdersListBloc>().add(AddProduct(product));

          // context.read<ItemsTilesBloc>().add(SelectedItemsTiles(product));
          //TODO: Логіка для переходу на деталі товару
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              product.imageUrl,
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
