import 'package:flutter/material.dart';

class CheckTopBar extends StatelessWidget {
  const CheckTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                border: const Border(
                  top: BorderSide(),
                  right: BorderSide(),
                  left: BorderSide(),
                ),
              ),
              padding: EdgeInsets.zero,
              child: IconButton(
                padding: EdgeInsets.zero,

                onPressed: () {},
                icon: const Icon(Icons.add_outlined, size: 15),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 250,
              height: 30,
              child: ListView.separated(
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(),
                        right: BorderSide(),
                        left: BorderSide(),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        DateTime.now().toString().split(' ')[1].split('.')[0],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 4);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
