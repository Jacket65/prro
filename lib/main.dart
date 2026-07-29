import 'package:flutter/material.dart';
import 'package:prro/app.dart';
import 'package:prro/config/backend_config.dart';
import 'package:prro/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(useMock: BackendConfig.useMock);

  runApp(const MyApp());
}
