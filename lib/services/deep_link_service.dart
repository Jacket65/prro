import 'dart:async';

import 'package:app_links/app_links.dart';
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
class DeepLinkService implements DeepLinkServiceI {
  DeepLinkService();

  final _appLinks = AppLinks();
  final _controller = StreamController<Uri>.broadcast();
  StreamSubscription<Uri>? _subscription;

  @override
  Stream<Uri> get onDeepLink => _controller.stream;

  @override
  Future<void> init() async {
    // Handle initial link if app was launched via deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null && _isPaymentCallback(initialUri)) {
      _controller.add(initialUri);
    }

    // Listen for subsequent deep links
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      if (_isPaymentCallback(uri)) {
        _controller.add(uri);
      }
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }

  /// Checks if the URI is a payment callback (matches our configured scheme/host).
  bool _isPaymentCallback(Uri uri) {
    return uri.scheme == PaymentConfig.callbackScheme &&
        uri.host == PaymentConfig.callbackHost;
  }
}
