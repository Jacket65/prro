import 'package:material_ui/material_ui.dart';
import 'package:prro/app.dart';
import 'package:prro/core/config/backend_config.dart';
import 'package:prro/core/config/env.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.assertBaseUrlConfigured();

  await configureDependencies(useMock: BackendConfig.useMock);

  final appRouter = AppRouter();
  runApp(MyApp(router: appRouter));
}
