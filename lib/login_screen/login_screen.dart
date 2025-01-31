import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prro/main_screen/main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  String phone_numb = '+380123456789';
  String password = '123456';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Телефон'),
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (value) => phone_numb,
                cursorWidth: 1,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Телефон',
                  hintStyle: TextStyle(color: Colors.grey),
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Text('Пароль'),
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (value) => password,
                cursorWidth: 1,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  hintStyle: TextStyle(color: Colors.grey),
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      DialogRoute(
                        context: context,
                        builder: (context) => MainScreen(),
                      ));
                },
                child: Text('Вхід', style: TextStyle(color: Colors.white))),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  authenticateUser(phone_numb, password);
                  // checkMeasureunits();
                  // checkRetail_outlets();
                  checkExport();
                },
                child: Text('Вхід2', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}

String? jwtToken = '';

Future<String?> authenticateUser(String phone, String password) async {
  final dio = Dio();

  try {
    final response = await dio.post('http://localhost:8080/auth/admin', data: {
      'phone_number': phone,
      'password': password,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      jwtToken = response.headers['authorization']![0].split(' ')[1];
      return jwtToken;
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

Future<String?> checkMeasureunits() async {
  final dio = Dio();
  print(jwtToken);
  try {
    dio.options.headers['authorization'] = 'Bearer $jwtToken';
    final response = await dio.get('http://localhost:8080/admin/measureunits');
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data);
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

Future<String?> checkRetail_outlets() async {
  final dio = Dio();
  print(jwtToken);
  try {
    dio.options.headers['authorization'] = 'Bearer $jwtToken';
    final response =
        await dio.get('http://localhost:8080/admin/retail_outlets');
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data);
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

String filename = '';

Future<String?> checkExport() async {
  final dio = Dio();
  // print(jwtToken);
  try {
    dio.options.headers['authorization'] = 'Bearer $jwtToken';
    final response = await dio
        .get('http://localhost:8080/admin/retail_outlet/1/products/export');
    print(response.statusCode);
    if (response.statusCode == 200) {
      filename = response.headers['content-disposition']![0].split('"')[1];
      downloadFile(filename, response.data);
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}

// Future<void> downloadFile(String filename, String response) async {
//   // var response = await http.Client().send(http.Request('GET', Uri.parse(url)));

//   var file = File(filename);
//   var sink = file.openWrite(); // Відкриваємо файл для запису

//   await response.stream.pipe(sink);
//   await sink.flush();
//   await sink.close();

//   print('Файл завантажено: $filePath');
// }

Future<void> downloadFile(String filename, List<int> response) async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path;
  File file = File('$path/$path');
  await file.writeAsBytes(response);

  print('Файл завантажено: $path');
}
