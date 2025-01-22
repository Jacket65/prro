import 'package:flutter/material.dart';
import 'package:prro/items_screen/inside_category_screen.dart';

class CustomCard extends StatelessWidget {
  CustomCard({required this.cardTit, required this.cardInx});
  final String cardTit;
  final int cardInx;
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
              builder: (context) => InsideCategory(
                cardInx,
                cardTit,
              ),
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
