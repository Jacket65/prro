import 'package:flutter/material.dart';
import 'package:prro/app.dart';
import 'package:prro/config/backend_config.dart';
import 'package:prro/di/di.dart';
import 'package:prro/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(useMock: BackendConfig.useMock);

  final appRouter = AppRouter();
  runApp(MyApp(router: appRouter));
}
