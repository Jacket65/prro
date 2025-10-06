// import 'package:flutter/material.dart';

// class CustomKeypad extends StatelessWidget {
//   const CustomKeypad({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 500,
//       width: 300,
//       child: GridView.count(
//         shrinkWrap: true,
//         // itemBuilder: (context, index) {
//         //   return Padding(
//         //     padding: const EdgeInsets.all(8.0),
//         //     child: ElevatedButton(
//         //       onPressed: () {},
//         //       child: Text((index + 1).toString()),
//         //     ),
//         //   );
//         // },
//         crossAxisCount: 3,

//         // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         //   crossAxisCount: 3,
//         // ),
//         // itemCount: 14,
//         children: [
//           for (var i = 0; i < 14; i++)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: Text((i + 1).toString()),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';

class CustomKeypad extends StatelessWidget {
  final List<String> keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    ',',
    '0',
    'back',
  ];

  CustomKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height);
    final double itemWidth = size.width;
    return Flexible(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: keys.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: (itemWidth / itemHeight),
              ),
              itemBuilder: (context, index) {
                final key = keys[index];
                return _buildButtons(key);
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildButtons(String key) {
    return GestureDetector(
      child: InkWell(
        onTap: () {
          log('Key pressed: $key');
          // TODO: handle tap
        },
        child: Container(
          width: 50,
          height: 80,
          margin: EdgeInsets.all(1),

          child: Center(
            child: key == 'back'
                ? Icon(Icons.backspace)
                : Text(key, style: TextStyle(fontSize: 24)),
          ),
        ),
      ),
    );
  }
}
