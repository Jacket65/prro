import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/app.dart';
import 'package:prro/core/config/backend_config.dart';
import 'package:prro/core/config/env.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/logging/app_talker.dart';
import 'package:prro/core/logging/error_hooks.dart';
import 'package:prro/core/router/app_router.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.assertBaseUrlConfigured();
  BackendConfig.assertBackendTypeConfigured();

  await configureDependencies(useMock: BackendConfig.useMock);

  Bloc.observer = TalkerBlocObserver(
    talker: appTalker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: false,
      printStateFullData: false,
    ),
  );

  installErrorHooks(appTalker);

  final appRouter = AppRouter();
  runApp(MyApp(router: appRouter));
}
