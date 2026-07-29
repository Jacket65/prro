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
import 'package:prro/data/api/api_client_i.dart' as _i219;
import 'package:prro/data/mock/mock_backend.dart' as _i1038;
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
import 'package:prro/data/repositories/login_repository/login_repo.dart'
    as _i427;
import 'package:prro/data/repositories/login_repository/login_repo_i.dart'
    as _i977;
import 'package:prro/data/repositories/login_repository/login_repository_mock.dart'
    as _i580;
import 'package:prro/data/repositories/orders_repository/orders_repository.dart'
    as _i232;
import 'package:prro/data/repositories/orders_repository/orders_repository_impl.dart'
    as _i307;
import 'package:prro/data/repositories/orders_repository/orders_repository_mock.dart'
    as _i499;
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart'
    as _i957;
import 'package:prro/data/repositories/shift_repository/shift_repository_mock.dart'
    as _i562;
import 'package:prro/data/repositories/user_repository/user_repo.dart' as _i170;
import 'package:prro/data/repositories/user_repository/user_repo_i.dart'
    as _i205;
import 'package:prro/data/repositories/user_repository/user_repository_mock.dart'
    as _i817;
import 'package:prro/data/services/balance.dart' as _i566;
import 'package:prro/data/services/items_service.dart' as _i639;
import 'package:prro/data/services/login_service.dart' as _i422;
import 'package:prro/data/services/mock_balance_service.dart' as _i976;
import 'package:prro/data/services/mock_items_service.dart' as _i649;
import 'package:prro/data/services/mock_login_service.dart' as _i241;
import 'package:prro/data/services/mock_shift_service.dart' as _i924;
import 'package:prro/data/services/mock_user_service.dart' as _i104;
import 'package:prro/data/services/shift_service.dart' as _i819;
import 'package:prro/data/services/user_service.dart' as _i169;
import 'package:prro/di/app_module.dart' as _i745;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    gh.singleton<_i205.UserServiceI>(
      () => _i104.MockUserService(),
      registerFor: {_mock},
    );
    gh.singleton<_i296.BalanceServiceI>(
      () => _i976.MockBalanceService(),
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
    gh.singleton<_i977.LoginServiceI>(
      () => _i241.MockLoginService(),
      registerFor: {_mock},
    );
    gh.singleton<_i1038.MockBackend>(
      () => appModule.mockBackend(),
      registerFor: {_mock},
    );
    gh.singleton<_i977.LoginRepositoryI>(
      () => _i580.LoginRepositoryMock(gh<_i977.LoginServiceI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i369.ItemsRepositoryI>(
      () => _i971.ItemsRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i361.Dio>(() => appModule.dio(), registerFor: {_prod});
    gh.singleton<_i232.OrdersRepositoryI>(
      () => _i499.OrdersRepositoryMock(gh<_i1038.MockBackend>()),
      registerFor: {_mock},
    );
    gh.singleton<_i205.UserRepositoryI>(
      () => _i817.UserRepositoryMock(gh<_i205.UserServiceI>()),
      registerFor: {_mock},
    );
    gh.singleton<_i219.ApiClientI>(
      () => appModule.mockApiClient(
        gh<_i460.SharedPreferences>(),
        gh<_i1038.MockBackend>(),
      ),
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
    gh.singleton<_i219.ApiClientI>(
      () => appModule.apiClient(gh<_i361.Dio>(), gh<_i460.SharedPreferences>()),
      registerFor: {_prod},
    );
    gh.singleton<_i205.UserServiceI>(
      () => _i169.UserService(
        prefs: gh<_i460.SharedPreferences>(),
        apiClient: gh<_i219.ApiClientI>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i205.UserRepositoryI>(
      () => _i170.UserRepositoryImpl(userService: gh<_i205.UserServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i296.BalanceServiceI>(
      () => _i566.BalanceService(apiClient: gh<_i219.ApiClientI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i296.BalanceRepositoryI>(
      () =>
          _i379.BalanceRepository(balanceService: gh<_i296.BalanceServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i977.LoginServiceI>(
      () => _i422.LoginService(
        prefs: gh<_i460.SharedPreferences>(),
        apiClient: gh<_i219.ApiClientI>(),
      ),
      registerFor: {_prod},
    );
    gh.singleton<_i668.ItemsServiceI>(
      () => _i639.ItemsService(
        apiClient: gh<_i219.ApiClientI>(),
        prefs: gh<_i460.SharedPreferences>(),
      ),
      registerFor: {_prod},
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
    gh.singleton<_i668.ItemsRepositoryI>(
      () => _i244.ItemsRepository(gh<_i668.ItemsServiceI>()),
      registerFor: {_prod},
    );
    gh.singleton<_i977.LoginRepositoryI>(
      () => _i427.LoginRepositoryImpl(loginService: gh<_i977.LoginServiceI>()),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$AppModule extends _i745.AppModule {}
