import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/mock/mock_api_client.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/core/network/api_client.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/security/token_storage_i.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  @Environment('prod')
  Dio dio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );
  }

  @lazySingleton
  @Environment('prod')
  ApiClientI apiClient(Dio dio, TokenStorageI tokenStorage, Talker talker) {
    return ApiClient(dio: dio, tokenStorage: tokenStorage, talker: talker);
  }

  @lazySingleton
  @Environment('mock')
  MockBackend mockBackend(Talker talker) {
    return MockBackend.instance..talker = talker;
  }

  @lazySingleton
  @Environment('mock')
  ApiClientI mockApiClient(MockBackend mockBackend, Talker talker) {
    return MockApiClient(mockBackend: mockBackend, talker: talker);
  }

  @lazySingleton
  Talker get talker => Talker(
    logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: false)),
    settings: TalkerSettings(maxHistoryItems: 500),
  );
}
