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
import 'package:prro/core/security/in_memory_token_storage.dart' as _i344;
import 'package:prro/core/security/secure_token_storage.dart' as _i203;
import 'package:prro/core/security/token_storage_i.dart' as _i330;
import 'package:prro/data/api/api_client_i.dart' as _i219;
import 'package:prro/data/mock/mock_backend.dart' as _i1038;
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
import 'package:prro/data/repositories/auth_repository/auth_repo.dart' as _i58;
import 'package:prro/data/repositories/auth_repository/auth_repo_i.dart'
    as _i577;
import 'package:prro/data/repositories/auth_repository/auth_repository_mock.dart'
    as _i339;
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
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart'
    as _i844;
import 'package:prro/data/repositories/payment_repository/payment_repository_impl.dart'
    as _i1057;
import 'package:prro/data/repositories/payment_repository/payment_repository_mock.dart'
    as _i835;
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart'
    as _i957;
import 'package:prro/data/repositories/shift_repository/shift_repository_impl.dart'
    as _i302;
import 'package:prro/data/repositories/shift_repository/shift_repository_mock.dart'
    as _i562;
import 'package:prro/data/services/balance.dart' as _i566;
import 'package:prro/data/services/items_service.dart' as _i639;
import 'package:prro/data/services/login_service.dart' as _i422;
import 'package:prro/data/services/login_service_i.dart' as _i946;
import 'package:prro/data/services/mock_balance_service.dart' as _i976;
import 'package:prro/data/services/mock_items_service.dart' as _i649;
import 'package:prro/data/services/mock_login_service.dart' as _i241;
import 'package:prro/data/services/mock_shift_service.dart' as _i924;
import 'package:prro/data/services/order_history_service.dart' as _i772;
import 'package:prro/data/services/order_history_service_mock.dart' as _i422;
import 'package:prro/data/services/payment_service.dart' as _i769;
import 'package:prro/data/services/shift_service.dart' as _i819;
import 'package:prro/di/app_module.dart' as _i745;
import 'package:prro/features/seller/bloc/orders/payment/handlers/card_payment_handler.dart'
    as _i685;
import 'package:prro/features/seller/bloc/orders/payment/handlers/cash_payment_handler.dart'
    as _i502;
import 'package:prro/features/seller/bloc/orders/payment/handlers/nfc_payment_handler.dart'
    as _i544;
import 'package:prro/features/seller/bloc/orders/payment/pay_order_use_case.dart'
    as _i132;
import 'package:prro/services/deep_link_service.dart' as _i866;
import 'package:prro/services/nfc_payment_service.dart' as _i829;
import 'package:prro/services/terminal_launcher.dart' as _i1024;
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
    gh.factory<_i685.CardPaymentHandler>(() => _i685.CardPaymentHandler());
    gh.factory<_i502.CashPaymentHandler>(() => _i502.CashPaymentHandler());
    gh.singleton<_i993.Talker>(() => appModule.talker());
    gh.singleton<_i296.BalanceServiceI>(
      () => _i976.MockBalanceService(),
      registerFor: {_mock},
    );
    gh.factory<_i866.DeepLinkServiceI>(() => _i866.DeepLinkService());
    gh.singleton<_i772.OrderHistoryServiceI>(
      () => _i422.OrderHistoryServiceMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i957.ShiftServiceI>(
      () => _i924.MockShiftService(),
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
    gh.lazySingleton<_i1024.TerminalLauncherI>(() => _i1024.TerminalLauncher());
    gh.lazySingleton<_i844.PaymentRepositoryI>(
      () => _i835.PaymentRepositoryMock(),
      registerFor: {_mock},
    );
    gh.singleton<_i1038.MockBackend>(
      () => appModule.mockBackend(),
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
    gh.singleton<_i738.AdminOutletRepositoryI>(
      () => _i433.AdminOutletRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i369.ItemsRepositoryI>(
      () => _i971.ItemsRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i361.Dio>(() => appModule.dio(), registerFor: {_prod});
    gh.singleton<_i219.AdminCatalogRepositoryI>(
      () => _i362.AdminCatalogRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i75.AdminUserRepositoryI>(
      () => _i461.AdminUserRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i668.ItemsServiceI>(
      () => _i649.MockItemsService(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i957.ShiftRepositoryI>(
      () => _i562.ShiftRepositoryMock(gh<_i957.ShiftServiceI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i232.OrdersRepositoryI>(
      () => _i499.OrdersRepositoryMock(
        gh<_i1038.MockBackend>(),
        gh<_i772.OrderHistoryServiceI>(),
      ),
      registerFor: {_mock},
    );
    gh.singleton<_i219.ApiClientI>(
      () => appModule.apiClient(gh<_i361.Dio>(), gh<_i330.TokenStorageI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i219.ApiClientI>(
      () => appModule.mockApiClient(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i738.AdminOutletRepositoryI>(
      () => _i874.AdminOutletRepositoryImpl(gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i772.OrderHistoryServiceI>(
      () => _i772.OrderHistoryService(
        apiClient: gh<_i219.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i946.LoginServiceI>(
      () => _i422.LoginService(apiClient: gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i296.BalanceServiceI>(
      () => _i566.BalanceService(apiClient: gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i769.PaymentServiceI>(
      () => appModule.paymentService(
        gh<_i219.ApiClientI>(),
        gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i844.PaymentRepositoryI>(
      () => _i1057.PaymentRepositoryImpl(gh<_i769.PaymentServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i296.BalanceRepositoryI>(
      () =>
          _i379.BalanceRepository(balanceService: gh<_i296.BalanceServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i219.AdminCatalogRepositoryI>(
      () => _i608.AdminCatalogRepositoryImpl(gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i668.ItemsServiceI>(
      () => _i639.ItemsService(
        apiClient: gh<_i219.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i75.AdminUserRepositoryI>(
      () => _i93.AdminUserRepositoryImpl(gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i577.AuthRepositoryI>(
      () => _i58.AuthRepositoryImpl(
        loginService: gh<_i946.LoginServiceI>(),
        tokenStorage: gh<_i330.TokenStorageI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i829.NfcPaymentServiceI>(
      () => _i829.NfcPaymentService(
        paymentRepository: gh<_i844.PaymentRepositoryI>(),
        terminalLauncher: gh<_i1024.TerminalLauncherI>(),
        deepLinkService: gh<_i866.DeepLinkServiceI>(),
        talker: gh<_i993.Talker>(),
      ),
    );
    gh.singleton<_i957.ShiftServiceI>(
      () => _i819.ShiftService(
        apiClient: gh<_i219.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i232.OrdersRepositoryI>(
      () => _i307.OrdersRepositoryImpl(
        apiClient: gh<_i219.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i923.OrderHistoryRepositoryI>(
      () => _i260.OrderHistoryRepositoryImpl(gh<_i772.OrderHistoryServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i946.LoginServiceI>(
      () => _i241.MockLoginService(apiClient: gh<_i219.ApiClientI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i668.ItemsRepositoryI>(
      () => _i244.ItemsRepository(gh<_i668.ItemsServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i577.AuthRepositoryI>(
      () => _i339.AuthRepositoryMock(
        loginService: gh<_i946.LoginServiceI>(),
        tokenStorage: gh<_i330.TokenStorageI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_mock},
    );
    gh.singleton<_i957.ShiftRepositoryI>(
      () => _i302.ShiftRepositoryImpl(gh<_i957.ShiftServiceI>()),
      registerFor: {_prod},
    );
    gh.factory<_i544.NfcPaymentHandler>(
      () => _i544.NfcPaymentHandler(gh<_i829.NfcPaymentServiceI>()),
    );
    gh.factory<_i132.PayOrderUseCase>(
      () => _i132.PayOrderUseCase(
        ordersRepository: gh<_i232.OrdersRepositoryI>(),
        cash: gh<_i502.CashPaymentHandler>(),
        card: gh<_i685.CardPaymentHandler>(),
        nfc: gh<_i544.NfcPaymentHandler>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i745.AppModule {}
