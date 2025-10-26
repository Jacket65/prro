// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final List<Widget>? widgets;
  const CustomPopupMenu({
    super.key,
    required this.name,
    required this.icon,
    this.widgets,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      style: ButtonStyle().copyWith(
        padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(0)),
      ),
      padding: EdgeInsetsGeometry.all(0),
      tooltip: "",
      icon: name.isNotEmpty
          ? TextButton.icon(
              style: ButtonStyle().copyWith(
                padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(10)),
              ),
              onPressed: null,
              icon: Icon(icon, color: color),
              label: Text(name, style: TextStyle(color: Colors.white)),
            )
          : IconButton(onPressed: null, icon: Icon(icon, color: color)),
      offset: Offset(00, 40),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        ...?widgets?.map((widget) => PopupMenuItem(child: widget)),
        const PopupMenuDivider(),
        const PopupMenuItem(
          child: ListTile(leading: Icon(Icons.anchor), title: Text('Item 2')),
        ),
        const PopupMenuItem(
          child: ListTile(leading: Icon(Icons.article), title: Text('Item 3')),
        ),

        const PopupMenuDivider(),
        const PopupMenuItem(child: Text('Item A')),
        const PopupMenuItem(child: Text('Item B')),
      ],
    );
  }
}
