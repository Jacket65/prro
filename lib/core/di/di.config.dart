// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:prro/core/data/mock/order_history_repository_mock.dart'
    as _i798;
import 'package:prro/core/data/repositories/order_history_repository_impl.dart'
    as _i377;
import 'package:prro/core/di/app_module.dart' as _i297;
import 'package:prro/core/domain/repositories/order_history_repository_i.dart'
    as _i766;
import 'package:prro/core/mock/mock_backend.dart' as _i1010;
import 'package:prro/core/network/api_client_i.dart' as _i787;
import 'package:prro/core/security/in_memory_token_storage.dart' as _i344;
import 'package:prro/core/security/secure_token_storage.dart' as _i203;
import 'package:prro/core/security/token_storage_i.dart' as _i330;
import 'package:prro/features/admin/data/mock/admin_catalog_repository_mock.dart'
    as _i797;
import 'package:prro/features/admin/data/mock/admin_outlet_repository_mock.dart'
    as _i412;
import 'package:prro/features/admin/data/mock/admin_user_repository_mock.dart'
    as _i877;
import 'package:prro/features/admin/data/repositories/admin_catalog_repository_impl.dart'
    as _i744;
import 'package:prro/features/admin/data/repositories/admin_outlet_repository_impl.dart'
    as _i328;
import 'package:prro/features/admin/data/repositories/admin_user_repository_impl.dart'
    as _i524;
import 'package:prro/features/admin/domain/repositories/admin_catalog_repository_i.dart'
    as _i617;
import 'package:prro/features/admin/domain/repositories/admin_outlet_repository_i.dart'
    as _i310;
import 'package:prro/features/admin/domain/repositories/admin_user_repository_i.dart'
    as _i1053;
import 'package:prro/features/auth/data/repositories/auth_repository.dart'
    as _i76;
import 'package:prro/features/auth/domain/repositories/auth_repository_i.dart'
    as _i749;
import 'package:prro/features/payment/data/mock/payment_repository_mock.dart'
    as _i84;
import 'package:prro/features/payment/data/repositories/payment_repository_impl.dart'
    as _i883;
import 'package:prro/features/payment/data/services/deep_link_service.dart'
    as _i792;
import 'package:prro/features/payment/data/services/payment_service.dart'
    as _i134;
import 'package:prro/features/payment/data/services/terminal_launcher.dart'
    as _i944;
import 'package:prro/features/payment/data/services/terminal_payment_service.dart'
    as _i986;
import 'package:prro/features/payment/domain/repositories/payment_repository_i.dart'
    as _i943;
import 'package:prro/features/payment/domain/repositories/terminal_payment_service_i.dart'
    as _i249;
import 'package:prro/features/seller/data/mock/balance_repository_mock.dart'
    as _i728;
import 'package:prro/features/seller/data/mock/items_repository_mock.dart'
    as _i972;
import 'package:prro/features/seller/data/mock/orders_repository_mock.dart'
    as _i411;
import 'package:prro/features/seller/data/repositories/balance_repository.dart'
    as _i445;
import 'package:prro/features/seller/data/repositories/items_repository.dart'
    as _i1038;
import 'package:prro/features/seller/data/repositories/orders_repository_impl.dart'
    as _i278;
import 'package:prro/features/seller/domain/payment/handlers/cash_payment_handler.dart'
    as _i131;
import 'package:prro/features/seller/domain/payment/handlers/terminal_payment_handler.dart'
    as _i1000;
import 'package:prro/features/seller/domain/repositories/balance_repository_i.dart'
    as _i132;
import 'package:prro/features/seller/domain/repositories/items_repository_i.dart'
    as _i691;
import 'package:prro/features/seller/domain/repositories/orders_repository_i.dart'
    as _i876;
import 'package:prro/features/seller/domain/usecases/pay_order_use_case.dart'
    as _i367;
import 'package:prro/features/shift/data/mock/shift_repository_mock.dart'
    as _i392;
import 'package:prro/features/shift/data/repositories/shift_repository_impl.dart'
    as _i277;
import 'package:prro/features/shift/domain/repositories/shift_repository_i.dart'
    as _i28;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:talker/talker.dart' as _i993;

const String _mock = 'mock';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i131.CashPaymentHandler>(() => _i131.CashPaymentHandler());
    gh.singleton<_i993.Talker>(() => appModule.talker());
    gh.singleton<_i766.OrderHistoryRepositoryI>(
      () => _i798.OrderHistoryRepositoryMock(),
      registerFor: {_mock},
    );
    gh.factory<_i792.DeepLinkServiceI>(() => _i792.DeepLinkService());
    gh.singleton<_i132.BalanceRepositoryI>(
      () => _i728.BalanceRepositoryMock(),
      registerFor: {_mock},
    );
    gh.lazySingleton<_i944.TerminalLauncherI>(() => _i944.TerminalLauncher());
    gh.lazySingleton<_i943.PaymentRepositoryI>(
      () => _i84.PaymentRepositoryMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i330.TokenStorageI>(
      () => _i344.InMemoryTokenStorage(),
      registerFor: {_mock},
    );
    gh.singleton<_i28.ShiftRepositoryI>(
      () => _i392.ShiftRepositoryMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i1010.MockBackend>(
      () => appModule.mockBackend(),
      registerFor: {_mock},
    );
    gh.singleton<_i330.TokenStorageI>(
      () => _i203.SecureTokenStorage(),
      registerFor: {_prod},
    );
    gh.singleton<_i361.Dio>(() => appModule.dio(), registerFor: {_prod});
    gh.singleton<_i876.OrdersRepositoryI>(
      () => _i411.OrdersRepositoryMock(
        gh<_i1010.MockBackend>(),
        gh<_i766.OrderHistoryRepositoryI>(),
      ),
      registerFor: {_mock},
    );
    gh.singleton<_i1053.AdminUserRepositoryI>(
      () => _i877.AdminUserRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i310.AdminOutletRepositoryI>(
      () => _i412.AdminOutletRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i617.AdminCatalogRepositoryI>(
      () => _i797.AdminCatalogRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i787.ApiClientI>(
      () => appModule.apiClient(gh<_i361.Dio>(), gh<_i330.TokenStorageI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i787.ApiClientI>(
      () => appModule.mockApiClient(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i28.ShiftRepositoryI>(
      () => _i277.ShiftRepositoryImpl(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i691.ItemsRepositoryI>(
      () => _i972.ItemsRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i132.BalanceRepositoryI>(
      () => _i445.BalanceRepository(apiClient: gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i134.PaymentServiceI>(
      () => appModule.paymentService(
        gh<_i787.ApiClientI>(),
        gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i749.AuthRepositoryI>(
      () => _i76.AuthRepositoryImpl(
        tokenStorage: gh<_i330.TokenStorageI>(),
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i943.PaymentRepositoryI>(
      () => _i883.PaymentRepositoryImpl(gh<_i134.PaymentServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i310.AdminOutletRepositoryI>(
      () => _i328.AdminOutletRepositoryImpl(gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i617.AdminCatalogRepositoryI>(
      () => _i744.AdminCatalogRepositoryImpl(gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.factory<_i249.TerminalPaymentServiceI>(
      () => _i986.TerminalPaymentService(
        paymentRepository: gh<_i943.PaymentRepositoryI>(),
        terminalLauncher: gh<_i944.TerminalLauncherI>(),
        deepLinkService: gh<_i792.DeepLinkServiceI>(),
        talker: gh<_i993.Talker>(),
      ),
    );
    gh.singleton<_i1053.AdminUserRepositoryI>(
      () => _i524.AdminUserRepositoryImpl(gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i691.ItemsRepositoryI>(
      () => _i1038.ItemsRepository(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i766.OrderHistoryRepositoryI>(
      () => _i377.OrderHistoryRepositoryImpl(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i876.OrdersRepositoryI>(
      () => _i278.OrdersRepositoryImpl(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i1000.TerminalPaymentHandler>(
      () => _i1000.TerminalPaymentHandler(
        gh<_i249.TerminalPaymentServiceI>(),
        gh<_i876.OrdersRepositoryI>(),
      ),
    );
    gh.factory<_i367.PayOrderUseCase>(
      () => _i367.PayOrderUseCase(
        ordersRepository: gh<_i876.OrdersRepositoryI>(),
        cash: gh<_i131.CashPaymentHandler>(),
        terminal: gh<_i1000.TerminalPaymentHandler>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i297.AppModule {}
