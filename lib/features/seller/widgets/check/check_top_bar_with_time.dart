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
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(),
                        right: BorderSide(),
                        left: BorderSide(),
                      ),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {},
                      child: Text(
                        DateTime.now()
                            .toString()
                            .split(' ')[1]
                            .split('.')[0]
                            .substring(0, 5),
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
