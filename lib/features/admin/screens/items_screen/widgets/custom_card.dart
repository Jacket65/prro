import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prro/core/constants/settings.dart';
import 'package:prro/features/admin/screens/items_screen/items_screen.dart';
import 'package:prro/features/admin/screens/items_screen/models/measure.dart';
import 'package:prro/features/admin/screens/items_screen/widgets/inside_category_screen.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.title, required this.index, required this.categoryList, required this.onRename, required this.onDelete, super.key,
  });

  final String title;
  final int index;
  final List<Category> categoryList;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          lastCategory = categoryList.indexOf(
            categoryList.firstWhere((element) => element.title == title),
          );

          final outlet = Provider.of<int>(context, listen: false);
          final measures = Provider.of<List<Measure>>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  Provider<int>.value(value: outlet),
                  Provider<List<Measure>>.value(value: measures),
                ],
                child: InsideCategory(
                  cardInx: index,
                  cardTil: title,
                  categoryList: categoryList,
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.folder, color: Colors.grey.shade700, size: 32),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                tooltip: 'Дії з категорією',
                icon: Icon(Icons.more_vert, color: Colors.grey.shade700),
                onSelected: (value) {
                  if (value == 'rename') {
                    onRename();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'rename', child: Text('Перейменувати')),
                  PopupMenuItem(value: 'delete', child: Text('Видалити')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}