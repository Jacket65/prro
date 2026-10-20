import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/logging/app_talker.dart';
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

  @singleton
  @Environment('prod')
  Dio dio() => Dio();

  @singleton
  @Environment('prod')
  ApiClientI apiClient(Dio dio, TokenStorageI tokenStorage) =>
      ApiClient(dio: dio, tokenStorage: tokenStorage);

  @singleton
  @Environment('mock')
  ApiClientI mockApiClient(MockBackend mockBackend) =>
      MockApiClient(mockBackend: mockBackend);

  @singleton
  @Environment('mock')
  MockBackend mockBackend() => MockBackend.instance;

  /// The one application-wide logger. It is the shared [appTalker] instance,
  /// so a [Talker] taken from the container and a direct `appTalker`
  /// reference write to the same history.
  @singleton
  Talker talker() => appTalker;
}
