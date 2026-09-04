import 'package:flutter/material.dart';

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({
    required this.name,
    required this.icon,
    super.key,
    this.widgets,
    this.color = Colors.white,
  });
  final String name;
  final IconData icon;
  final Color color;
  final List<Widget>? widgets;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      style: const ButtonStyle().copyWith(
        padding: const WidgetStatePropertyAll(EdgeInsetsGeometry.zero),
      ),
      padding: EdgeInsetsGeometry.zero,
      tooltip: '',
      icon: name.isNotEmpty
          ? TextButton.icon(
              style: const ButtonStyle().copyWith(
                padding: const WidgetStatePropertyAll(
                  EdgeInsetsGeometry.all(10),
                ),
              ),
              onPressed: null,
              icon: Icon(icon, color: color),
              label: Text(name, style: const TextStyle(color: Colors.white)),
            )
          : IconButton(onPressed: null, icon: Icon(icon, color: color)),
      offset: const Offset(00, 40),
      itemBuilder: (context) => <PopupMenuEntry<void>>[
        ...?widgets?.map((widget) => PopupMenuItem(child: widget)),
        // const PopupMenuDivider(),
        // const PopupMenuItem(
        //   child: ListTile(leading: Icon(Icons.anchor),
        //title: Text('Item 2')),
        // ),
        // const PopupMenuItem(
        //   child: ListTile(leading: Icon(Icons.article),
        //title: Text('Item 3')),
        // ),

        // const PopupMenuDivider(),
        // const PopupMenuItem(child: Text('Item A')),
        // const PopupMenuItem(child: Text('Item B')),
      ],
    );
  }
}
