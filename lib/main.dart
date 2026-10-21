import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/app.dart';
import 'package:prro/core/config/backend_config.dart';
import 'package:prro/core/config/env.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/logging/error_hooks.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/router/app_router.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart';
import 'package:prro/features/seller/domain/repositories/pending_order_store_i.dart';
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Env.assertBaseUrlConfigured();
  BackendConfig.assertBackendTypeConfigured();

  await configureDependencies(useMock: BackendConfig.useMock);
  final talker = getIt<Talker>();

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: false,
      printStateFullData: false,
    ),
  );

  installErrorHooks(talker);

  final appRouter = AppRouter();
  runApp(
    MyApp(
      router: appRouter,
      talker: talker,
      apiClient: getIt<ApiClientI>(),
      authRepository: getIt<AuthRepositoryI>(),
      tokenStorage: getIt<TokenStorageI>(),
      ordersRepository: getIt<OrdersRepositoryI>(),
      pendingOrderStore: getIt<PendingOrderStoreI>(),
      shiftRepository: getIt<ShiftRepositoryI>(),
    ),
  );
}
