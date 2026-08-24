import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/security/in_memory_token_storage.dart';

void main() {
  late InMemoryTokenStorage storage;

  setUp(() {
    storage = InMemoryTokenStorage();
  });

  group('InMemoryTokenStorage', () {
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

    test('hasValidSession returns false for empty string token', () async {
      await storage.saveSession(accessToken: '');
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
  });
}
