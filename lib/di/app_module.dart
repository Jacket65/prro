import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/mock_api_client.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/services/payment_service.dart';
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
  ApiClientI apiClient(Dio dio, SharedPreferences prefs) =>
      ApiClient(dio: dio, prefs: prefs);

  @singleton
  @Environment('mock')
  ApiClientI mockApiClient(SharedPreferences prefs, MockBackend mockBackend) =>
      MockApiClient(prefs: prefs, mockBackend: mockBackend);

  @singleton
  @Environment('mock')
  MockBackend mockBackend() => MockBackend.instance;

  @singleton
  Talker talker() => Talker();

  // Payment services
  @singleton
  @Environment('prod')
  PaymentServiceI paymentService(
    ApiClientI apiClient,
    SharedPreferences prefs,
  ) => PaymentService(apiClient: apiClient, prefs: prefs);
}
