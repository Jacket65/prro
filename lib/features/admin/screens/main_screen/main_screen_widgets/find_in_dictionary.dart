import 'package:flutter/material.dart';
import 'package:prro/core/constants/settings.dart';

void findInDictionary(BuildContext context) {
  const title = 'Пошук ДПІ у довіднику ?';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(title),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: largestCities.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        title: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(largestCities[index]),
                        ),
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(largestCities[index]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Вибрати', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Скасувати'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
