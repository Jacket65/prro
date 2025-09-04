import 'package:flutter/material.dart';

class CheckTopBarWithTime extends StatelessWidget {
  const CheckTopBarWithTime({super.key});

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
                        right: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
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
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 4);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
