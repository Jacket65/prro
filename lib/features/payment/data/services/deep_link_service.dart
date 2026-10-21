import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/config/payment_config.dart';
import 'package:talker/talker.dart';

/// Service interface for handling deep links
/// (callbacks from PrivatBank Terminal).
abstract interface class DeepLinkServiceI {
  /// Stream of incoming deep link URIs.
  Stream<Uri> get onDeepLink;

  /// Initializes the deep link listener.
  Future<void> init();

  /// Disposes resources.
  Future<void> dispose();
}

/// Production implementation of [DeepLinkServiceI] using app_links package.
///
/// The singleton lifetime is load-bearing, not a default: the terminal payment
/// orchestrator calls [init] and [dispose] once per payment, and each call must
/// leave exactly one live `app_links` subscription behind. Two instances would
/// mean two subscriptions on the same global link stream, so every callback
/// would be delivered twice and one charge could complete two payments.
@LazySingleton(as: DeepLinkServiceI)
class DeepLinkService implements DeepLinkServiceI {
  DeepLinkService(this._talker);

  final Talker _talker;
  final _appLinks = AppLinks();
  StreamController<Uri> _controller = StreamController<Uri>.broadcast();
  StreamSubscription<Uri>? _subscription;
  bool _initialized = false;

  @override
  Stream<Uri> get onDeepLink => _controller.stream;

  @override
  Future<void> init() async {
    // The service is a DI singleton: initializing twice would stack a second
    // app_links subscription and emit every callback twice.
    if (_initialized) {
      _talker.info('[DeepLinkService] Already initialized, skipping');
      return;
    }
    _initialized = true;

    // The controller is a long-lived broadcast stream. It is recreated here if
    // a previous [dispose] left it closed so that every subsequent payment can
    // still receive its callback.
    if (_controller.isClosed) {
      _controller = StreamController<Uri>.broadcast();
    }

    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object error, StackTrace stackTrace) {
        _talker.error(
          '[DeepLinkService] Link stream error: $error',
          error,
          stackTrace,
        );
      },
    );
    _talker.info(
      '[DeepLinkService] Listening for ${PaymentConfig.callbackUri}',
    );
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      _talker.info('[DeepLinkService] Initial link: $initialUri');
      _handleUri(initialUri);
    }
  }

  void _handleUri(Uri uri) {
    _talker.info('[DeepLinkService] Incoming link: $uri');
    if (!PaymentConfig.isCallback(uri)) {
      _talker.info(
        '[DeepLinkService] Ignored — expected '
        '${PaymentConfig.callbackScheme}://${PaymentConfig.callbackHost}, '
        'got ${uri.scheme}://${uri.host}',
      );
      return;
    }
    _talker.info(
      '[DeepLinkService] Payment callback params: ${uri.queryParameters}',
    );
    if (_controller.isClosed) {
      _talker.info('[DeepLinkService] Controller closed, callback dropped');
      return;
    }
    if (!_controller.hasListener) {
      _talker.info(
        '[DeepLinkService] No active payment listener; callback ignored',
      );
      return;
    }
    _controller.add(uri);
  }

  @override
  Future<void> dispose() async {
    // Tear down only the app_links subscription. We deliberately do NOT close
    // the broadcast [_controller]: this service is a long-lived singleton and
    // [TerminalPaymentService] calls init()/dispose() once per payment.
    // Closing the
    // controller would permanently break every subsequent payment's callback
    // delivery, so the controller persists for the app lifetime and is
    // recreated lazily in [init] only if it was somehow closed.
    _initialized = false;
    await _subscription?.cancel();
    _subscription = null;
  }
}
