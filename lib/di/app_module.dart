import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/mock_api_client.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/payment_repository/payment_repo_i.dart';
import 'package:prro/data/repositories/payment_repository/payment_repository_impl.dart';
import 'package:prro/data/repositories/payment_repository/payment_repository_mock.dart';
import 'package:prro/data/services/payment_service.dart';
import 'package:prro/services/deep_link_service.dart';
import 'package:prro/services/nfc_payment_service.dart';
import 'package:prro/services/terminal_launcher.dart';
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

  @singleton
  @Environment('prod')
  PaymentRepositoryI paymentRepository(PaymentServiceI paymentService) =>
      PaymentRepositoryImpl(paymentService);

  @singleton
  @Environment('mock')
  PaymentRepositoryI paymentRepositoryMock() => PaymentRepositoryMock();

  @singleton
  TerminalLauncherI terminalLauncher() => TerminalLauncher();

  @singleton
  DeepLinkServiceI deepLinkService() => DeepLinkService();

  @singleton
  NfcPaymentServiceI nfcPaymentService(
    PaymentRepositoryI paymentRepository,
    TerminalLauncherI terminalLauncher,
    DeepLinkServiceI deepLinkService,
    Talker talker,
  ) => NfcPaymentService(
    paymentRepository: paymentRepository,
    terminalLauncher: terminalLauncher,
    deepLinkService: deepLinkService,
    talker: talker,
  );
}
