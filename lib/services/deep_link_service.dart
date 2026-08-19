import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/config/payment_config.dart';

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
@Injectable(as: DeepLinkServiceI)
class DeepLinkService implements DeepLinkServiceI {
  DeepLinkService();

  final _appLinks = AppLinks();
  final _controller = StreamController<Uri>.broadcast();
  StreamSubscription<Uri>? _subscription;
  bool _initialized = false;

  @override
  Stream<Uri> get onDeepLink => _controller.stream;

  @override
  Future<void> init() async {
    // The service is a DI singleton: initializing twice would stack a second
    // app_links subscription and emit every callback twice.
    if (_initialized) {
      log('[DeepLinkService] Already initialized, skipping');
      return;
    }
    _initialized = true;

    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object error, StackTrace stackTrace) {
        log('[DeepLinkService] Link stream error: $error');
      },
    );
    log('[DeepLinkService] Listening for ${PaymentConfig.callbackUri}');
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      log('[DeepLinkService] Initial link: $initialUri');
      _handleUri(initialUri);
    }
  }

  void _handleUri(Uri uri) {
    log('[DeepLinkService] Incoming link: $uri');
    if (!_isPaymentCallback(uri)) {
      log(
        '[DeepLinkService] Ignored — expected '
        '${PaymentConfig.callbackScheme}://${PaymentConfig.callbackHost}, '
        'got ${uri.scheme}://${uri.host}',
      );
      return;
    }
    log('[DeepLinkService] Payment callback params: ${uri.queryParameters}');
    if (_controller.isClosed) {
      log('[DeepLinkService] Controller closed, callback dropped');
      return;
    }
    if (!_controller.hasListener) {
      log('[DeepLinkService] No active payment listener; callback ignored');
      return;
    }
    _controller.add(uri);
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
    await _subscription?.cancel();
    _subscription = null;
    await _controller.close();
  }

  /// Checks if the URI is a payment callback (matches our configured scheme/host).
  bool _isPaymentCallback(Uri uri) {
    return uri.scheme == PaymentConfig.callbackScheme &&
        uri.host == PaymentConfig.callbackHost;
  }
}
