import 'package:flutter/material.dart';
import 'package:prro/features/seller/screens/seller_screen.dart';
import 'package:prro/main_screen/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _routePage(context, SellerScreen()),
              child: Text("Продавець"),
            ),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => _routePage(context, MainScreen()),
              child: Text("Адміністратор"),
            ),
          ],
        ),
      ),
    );
  }
}

void _routePage(BuildContext context, Widget route) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => route),
  );
}
