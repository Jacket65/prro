import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late SharedPreferences emptyPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{outletIdKey: 7});
    prefs = await SharedPreferences.getInstance();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    emptyPrefs = await SharedPreferences.getInstance();
  });

  OutletSession sessionWith(SharedPreferences p) => OutletSession(p);

  test('id returns the session outlet', () {
    expect(sessionWith(prefs).id(), 7);
  });

  test('id fails with a Ukrainian message when unset', () {
    // A seller endpoint reached without a session outlet cannot be retried by
    // the UI, so this is a failure rather than an empty result.
    expect(
      () => sessionWith(emptyPrefs).id(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Точку продажу не визначено. Увійдіть знову.',
        ),
      ),
    );
  });

  test('idOrNull returns the session outlet', () {
    expect(sessionWith(prefs).idOrNull(), 7);
  });

  test('idOrNull returns null instead of throwing', () {
    expect(sessionWith(emptyPrefs).idOrNull(), isNull);
  });

  group('set / clear (the login and logout writers)', () {
    test('set stores the resolved id', () async {
      await sessionWith(emptyPrefs).set(9);

      expect(sessionWith(prefs).idOrNull(), 7); // prefs untouched
      expect(OutletSession(emptyPrefs).idOrNull(), 9);
    });

    test('set with no resolvable outlet clears the key', () async {
      await sessionWith(prefs).set(null);

      expect(OutletSession(prefs).idOrNull(), isNull);
    });

    test('clear removes the key', () async {
      await sessionWith(prefs).clear();

      expect(OutletSession(prefs).idOrNull(), isNull);
    });
  });
}
