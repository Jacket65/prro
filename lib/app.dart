import 'package:flutter/material.dart';
import 'package:prro/features/auth/auth.dart';

import 'package:prro/core/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Prro beta",
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
