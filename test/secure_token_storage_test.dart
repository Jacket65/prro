import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/security/secure_token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecureTokenStorage storage;
  late Map<String, String> mockStore;

  setUp(() {
    mockStore = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (methodCall) async {
        switch (methodCall.method) {
          case 'read':
            final args = methodCall.arguments as Map;
            return mockStore[args['key'] as String];
          case 'write':
            final args = methodCall.arguments as Map;
            mockStore[args['key'] as String] = args['value'] as String;
            return null;
          case 'delete':
            final args = methodCall.arguments as Map;
            mockStore.remove(args['key'] as String);
            return null;
          case 'readAll':
            return Map<String, String>.from(mockStore);
          case 'deleteAll':
            mockStore.clear();
            return null;
          case 'containsKey':
            final args = methodCall.arguments as Map;
            return mockStore.containsKey(args['key'] as String);
          default:
            return null;
        }
      },
    );

    storage = SecureTokenStorage();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  group('SecureTokenStorage', () {
    test('saveSession round-trips access and refresh tokens', () async {
      await storage.saveSession(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
      );

      expect(await storage.getAccessToken(), 'access-123');
      expect(await storage.getRefreshToken(), 'refresh-456');
    });

    test('saveAccessToken updates only the access token', () async {
      await storage.saveSession(
        accessToken: 'access-old',
        refreshToken: 'refresh-old',
      );
      await storage.saveAccessToken('access-new');

      expect(await storage.getAccessToken(), 'access-new');
      expect(await storage.getRefreshToken(), 'refresh-old');
    });

    test(
      'saveSession with null refreshToken preserves refresh token',
      () async {
        await storage.saveSession(
          accessToken: 'first-access',
          refreshToken: 'first-refresh',
        );
        await storage.saveSession(
          accessToken: 'second-access',
        );

        expect(await storage.getAccessToken(), 'second-access');
        expect(await storage.getRefreshToken(), 'first-refresh');
      },
    );

    test('hasValidSession returns false for no token', () async {
      expect(await storage.hasValidSession(), false);
    });

    test('hasValidSession returns true for non-empty token', () async {
      await storage.saveSession(accessToken: 'valid-token');
      expect(await storage.hasValidSession(), true);
    });

    test('hasValidSession returns false after clear', () async {
      await storage.saveSession(accessToken: 'some-token');
      expect(await storage.hasValidSession(), true);
      await storage.clear();
      expect(await storage.hasValidSession(), false);
    });

    test('clear is idempotent', () async {
      await storage.saveSession(
        accessToken: 'a',
        refreshToken: 'r',
      );
      await storage.clear();
      await storage.clear();

      expect(await storage.getAccessToken(), isNull);
      expect(await storage.getRefreshToken(), isNull);
    });

    test('cache coherence: getAccessToken returns new value without re-reading',
        () async {
      await storage.saveSession(
        accessToken: 'cached-access',
        refreshToken: 'cached-refresh',
      );

      mockStore.clear();

      expect(await storage.getAccessToken(), 'cached-access');
      expect(await storage.getRefreshToken(), 'cached-refresh');
    });
  });
}
