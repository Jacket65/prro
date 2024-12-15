import 'package:flutter/material.dart';

Column teller(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.blueAccent),
            onPressed: () {},
            child: Text(
              'Реєстрація касира',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Row(
              children: [
                Container(width: 200, child: TextField(decoration: null)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    width: 300,
                    child: Text(
                      'Інформація по касирам',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
