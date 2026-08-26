import 'package:flutter/material.dart';
import 'package:prro/app.dart';
import 'package:prro/config/backend_config.dart';
import 'package:prro/config/env.dart';
import 'package:prro/di/di.dart';
import 'package:prro/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.assertBaseUrlConfigured();

  await configureDependencies(useMock: BackendConfig.useMock);

  final appRouter = AppRouter();
  runApp(MyApp(router: appRouter));
}
