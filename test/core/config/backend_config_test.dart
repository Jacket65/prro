import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/config/backend_config.dart';

void main() {
  group('BackendConfig.isReleaseSafe', () {
    test('release requires an explicit real backend', () {
      expect(
        BackendConfig.isReleaseSafe(type: 'real', isRelease: true),
        isTrue,
      );
    });

    test('release rejects a mock backend, define passed or not', () {
      // The distinction the guard used to miss: `mock` reached here both when
      // the define was absent (the defaultValue) and when it was passed as
      // `--dart-define=BACKEND_TYPE=mock`, and both ship MockApiClient.
      for (final type in ['mock', 'Mock', 'REAL', '', 'real ']) {
        expect(
          BackendConfig.isReleaseSafe(type: type, isRelease: true),
          isFalse,
          reason: type,
        );
      }
    });

    test('debug and profile accept any backend type', () {
      for (final type in ['mock', 'real']) {
        expect(
          BackendConfig.isReleaseSafe(type: type, isRelease: false),
          isTrue,
          reason: type,
        );
      }
    });
  });

  group('BackendConfig.backendType', () {
    test('defaults to mock so a plain `flutter run` uses MockBackend', () {
      // `const String.fromEnvironment(..., defaultValue: 'mock')`: no define is
      // supplied to the test runner, so the default is what resolves here.
      expect(BackendConfig.backendType, 'mock');
      expect(BackendConfig.useMock, isTrue);
    });

    test('the shipped default would be rejected by the release rule', () {
      expect(
        BackendConfig.isReleaseSafe(
          type: BackendConfig.backendType,
          isRelease: true,
        ),
        isFalse,
      );
    });
  });
}
