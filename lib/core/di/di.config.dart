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
import 'package:prro/core/di/app_module.dart' as _i297;
import 'package:prro/core/mock/mock_backend.dart' as _i1010;
import 'package:prro/core/network/api_client_i.dart' as _i787;
import 'package:prro/core/security/in_memory_token_storage.dart' as _i344;
import 'package:prro/core/security/secure_token_storage.dart' as _i203;
import 'package:prro/core/security/token_storage_i.dart' as _i330;
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository.dart'
    as _i219;
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository_impl.dart'
    as _i608;
import 'package:prro/data/repositories/admin_catalog_repository/admin_catalog_repository_mock.dart'
    as _i362;
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart'
    as _i738;
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository_impl.dart'
    as _i874;
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository_mock.dart'
    as _i433;
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart'
    as _i75;
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository_impl.dart'
    as _i93;
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository_mock.dart'
    as _i461;
import 'package:prro/data/repositories/balance/balance.dart' as _i379;
import 'package:prro/data/repositories/balance/balance_i.dart' as _i296;
import 'package:prro/data/repositories/balance/balance_repository_mock.dart'
    as _i797;
import 'package:prro/data/repositories/items_repository/items_repo.dart'
    as _i244;
import 'package:prro/data/repositories/items_repository/items_repo_i.dart'
    as _i668;
import 'package:prro/data/repositories/items_repository/items_repository.dart'
    as _i369;
import 'package:prro/data/repositories/items_repository/items_repository_mock.dart'
    as _i971;
import 'package:prro/data/repositories/order_history/order_history_repo_i.dart'
    as _i923;
import 'package:prro/data/repositories/order_history/order_history_repository.dart'
    as _i260;
import 'package:prro/data/repositories/order_history/order_history_repository_mock.dart'
    as _i920;
import 'package:prro/data/repositories/orders_repository/orders_repository.dart'
    as _i232;
import 'package:prro/data/repositories/orders_repository/orders_repository_impl.dart'
    as _i307;
import 'package:prro/data/repositories/orders_repository/orders_repository_mock.dart'
    as _i499;
import 'package:prro/data/services/balance.dart' as _i566;
import 'package:prro/data/services/items_service.dart' as _i639;
import 'package:prro/data/services/mock_balance_service.dart' as _i976;
import 'package:prro/data/services/mock_items_service.dart' as _i649;
import 'package:prro/data/services/order_history_service.dart' as _i772;
import 'package:prro/data/services/order_history_service_mock.dart' as _i422;
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
import 'package:prro/features/seller/domain/payment/handlers/cash_payment_handler.dart'
    as _i131;
import 'package:prro/features/seller/domain/payment/handlers/terminal_payment_handler.dart'
    as _i1000;
import 'package:prro/features/seller/domain/usecases/pay_order_use_case.dart'
    as _i367;
import 'package:prro/features/shift/data/mock/mock_shift_service.dart' as _i699;
import 'package:prro/features/shift/data/mock/shift_repository_mock.dart'
    as _i392;
import 'package:prro/features/shift/data/repositories/shift_repository_impl.dart'
    as _i277;
import 'package:prro/features/shift/data/services/shift_service.dart' as _i426;
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
    gh.singleton<_i296.BalanceServiceI>(
      () => _i976.MockBalanceService(),
      registerFor: {_mock},
    );
    gh.singleton<_i772.OrderHistoryServiceI>(
      () => _i422.OrderHistoryServiceMock(),
      registerFor: {_mock},
    );
    gh.factory<_i792.DeepLinkServiceI>(() => _i792.DeepLinkService());
    gh.lazySingleton<_i944.TerminalLauncherI>(() => _i944.TerminalLauncher());
    gh.lazySingleton<_i943.PaymentRepositoryI>(
      () => _i84.PaymentRepositoryMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i296.BalanceRepositoryI>(
      () => _i797.BalanceRepositoryMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i330.TokenStorageI>(
      () => _i344.InMemoryTokenStorage(),
      registerFor: {_mock},
    );
    gh.singleton<_i1010.MockBackend>(
      () => appModule.mockBackend(),
      registerFor: {_mock},
    );
    gh.singleton<_i28.ShiftServiceI>(
      () => _i699.MockShiftService(),
      registerFor: {_mock},
    );
    gh.singleton<_i330.TokenStorageI>(
      () => _i203.SecureTokenStorage(),
      registerFor: {_prod},
    );
    gh.singleton<_i923.OrderHistoryRepositoryI>(
      () => _i920.OrderHistoryRepositoryMock(gh<_i772.OrderHistoryServiceI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i361.Dio>(() => appModule.dio(), registerFor: {_prod});
    gh.singleton<_i219.AdminCatalogRepositoryI>(
      () => _i362.AdminCatalogRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i232.OrdersRepositoryI>(
      () => _i499.OrdersRepositoryMock(
        gh<_i1010.MockBackend>(),
        gh<_i772.OrderHistoryServiceI>(),
      ),
      registerFor: {_mock},
    );
    gh.singleton<_i369.ItemsRepositoryI>(
      () => _i971.ItemsRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i738.AdminOutletRepositoryI>(
      () => _i433.AdminOutletRepositoryMock(gh<_i1010.MockBackend>()),
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
    gh.singleton<_i668.ItemsServiceI>(
      () => _i639.ItemsService(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i668.ItemsRepositoryI>(
      () => _i244.ItemsRepository(gh<_i668.ItemsServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i28.ShiftRepositoryI>(
      () => _i392.ShiftRepositoryMock(gh<_i28.ShiftServiceI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i75.AdminUserRepositoryI>(
      () => _i461.AdminUserRepositoryMock(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i134.PaymentServiceI>(
      () => appModule.paymentService(
        gh<_i787.ApiClientI>(),
        gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i668.ItemsServiceI>(
      () => _i649.MockItemsService(gh<_i1010.MockBackend>()),
      registerFor: {_mock},
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
    gh.singleton<_i738.AdminOutletRepositoryI>(
      () => _i874.AdminOutletRepositoryImpl(gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i219.AdminCatalogRepositoryI>(
      () => _i608.AdminCatalogRepositoryImpl(gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i75.AdminUserRepositoryI>(
      () => _i93.AdminUserRepositoryImpl(gh<_i787.ApiClientI>()),
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
    gh.singleton<_i28.ShiftServiceI>(
      () => _i426.ShiftService(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i772.OrderHistoryServiceI>(
      () => _i772.OrderHistoryService(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i296.BalanceServiceI>(
      () => _i566.BalanceService(apiClient: gh<_i787.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i232.OrdersRepositoryI>(
      () => _i307.OrdersRepositoryImpl(
        apiClient: gh<_i787.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i923.OrderHistoryRepositoryI>(
      () => _i260.OrderHistoryRepositoryImpl(gh<_i772.OrderHistoryServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i28.ShiftRepositoryI>(
      () => _i277.ShiftRepositoryImpl(gh<_i28.ShiftServiceI>()),
      registerFor: {_prod},
    );
    gh.factory<_i1000.TerminalPaymentHandler>(
      () => _i1000.TerminalPaymentHandler(
        gh<_i249.TerminalPaymentServiceI>(),
        gh<_i232.OrdersRepositoryI>(),
      ),
    );
    gh.singleton<_i296.BalanceRepositoryI>(
      () =>
          _i379.BalanceRepository(balanceService: gh<_i296.BalanceServiceI>()),
      registerFor: {_prod},
    );
    gh.factory<_i367.PayOrderUseCase>(
      () => _i367.PayOrderUseCase(
        ordersRepository: gh<_i232.OrdersRepositoryI>(),
        cash: gh<_i131.CashPaymentHandler>(),
        terminal: gh<_i1000.TerminalPaymentHandler>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i297.AppModule {}
