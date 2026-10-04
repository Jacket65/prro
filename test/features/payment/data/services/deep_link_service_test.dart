import 'dart:async';

import 'package:app_links_platform_interface/app_links_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/features/payment/data/services/deep_link_service.dart';

/// Stands in for the platform's link source.
///
/// `AppLinks` itself cannot be faked — it is a `final` singleton with a private
/// constructor — but it delegates every call to `AppLinksPlatform.instance`,
/// which is exactly the seam a test needs.
///
/// Installed once for the whole file, not per test: `AppLinks` caches its
/// internal controller against the platform stream it saw on first use, so
/// swapping the platform between tests would leave the cached controller
/// subscribed to a dead fake. `listenCount` is the load-bearing field — it
/// counts how many times the platform stream was actually subscribed, which is
/// how a stacked subscription becomes visible.
class FakeAppLinksPlatform extends AppLinksPlatform {
  late final StreamController<Uri> _controller =
      StreamController<Uri>.broadcast(
        onListen: () => listenCount++,
        onCancel: () => cancelCount++,
      );

  int listenCount = 0;
  int cancelCount = 0;
  Uri? initialLink;

  @override
  Future<Uri?> getInitialLink() async => initialLink;

  @override
  Stream<Uri> get uriLinkStream => _controller.stream;

  void emit(Uri uri) => _controller.add(uri);

  void reset() {
    listenCount = 0;
    cancelCount = 0;
    initialLink = null;
  }
}

void main() {
  late AppLinksPlatform originalPlatform;
  late FakeAppLinksPlatform platform;
  late DeepLinkService service;

  final callback = Uri.parse('prro://payment?transaction_id=tx-1');

  setUpAll(() {
    originalPlatform = AppLinksPlatform.instance;
    platform = FakeAppLinksPlatform();
    AppLinksPlatform.instance = platform;
  });

  setUp(() {
    platform.reset();
    service = DeepLinkService();
  });

  tearDown(() => service.dispose());

  tearDownAll(() {
    AppLinksPlatform.instance = originalPlatform;
  });

  group('DeepLinkService', () {
    test('emits a payment callback once', () async {
      final received = <Uri>[];
      service.onDeepLink.listen(received.add);
      await service.init();

      platform.emit(callback);
      await pumpEventQueue();

      expect(received, [callback]);
      expect(platform.listenCount, 1);
    });

    test('ignores a link that is not a payment callback', () async {
      final received = <Uri>[];
      service.onDeepLink.listen(received.add);
      await service.init();

      platform.emit(Uri.parse('https://example.com/somewhere'));
      await pumpEventQueue();

      expect(received, isEmpty);
    });

    test(
      'the initial link is delivered when it is a payment callback',
      () async {
        platform.initialLink = callback;
        final received = <Uri>[];
        service.onDeepLink.listen(received.add);

        await service.init();
        await pumpEventQueue();

        expect(received, [callback]);
      },
    );

    test('initializing twice does not stack a second subscription', () async {
      final received = <Uri>[];
      service.onDeepLink.listen(received.add);

      await service.init();
      await service.init();
      platform.emit(callback);
      await pumpEventQueue();

      expect(received, [callback]);
      expect(platform.listenCount, 1);
    });

    // The sequence this class' lifetime assumption rests on, and the one that
    // could never execute while DeepLinkService was a `factory`: each payment
    // disposes the listener and the next one re-initializes it. A second live
    // subscription would deliver every callback twice.
    test('dispose then init leaves exactly one live subscription', () async {
      final received = <Uri>[];
      service.onDeepLink.listen(received.add);

      await service.init();
      await service.dispose();
      expect(platform.cancelCount, 1);

      await service.init();
      platform.emit(callback);
      await pumpEventQueue();

      expect(received, [callback]);
      // One subscription per init, not two: the first was cancelled.
      expect(platform.listenCount, 2);
      expect(platform.cancelCount, 1);
    });

    test('dispose leaves the broadcast controller open', () async {
      await service.init();
      await service.dispose();

      var closed = false;
      service.onDeepLink.listen(null, onDone: () => closed = true);
      await pumpEventQueue();

      // Deliberate: dispose tears down only the app_links subscription. Closing
      // the controller would break every later payment's callback for the rest
      // of the app's life.
      expect(closed, isFalse);
    });

    test('a callback with no active payment listener is dropped', () async {
      await service.init();

      platform.emit(callback);
      await pumpEventQueue();

      // No listener, no throw and no buffered event for a later payment.
      final received = <Uri>[];
      service.onDeepLink.listen(received.add);
      await pumpEventQueue();
      expect(received, isEmpty);

      platform.emit(callback);
      await pumpEventQueue();
      expect(received, [callback]);
    });
  });
}
