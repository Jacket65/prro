import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> prefsWith(Map<String, Object> values) {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

void main() {
  late SharedPreferences prefs;
  late SharedPreferences emptyPrefs;

  setUp(() async {
    prefs = await prefsWith(<String, Object>{outletIdKey: 7});
    emptyPrefs = await prefsWith(<String, Object>{});
  });

  test('requireOutletId returns the session outlet', () {
    expect(requireOutletId(prefs), 7);
  });

  test('requireOutletId fails with a Ukrainian message when unset', () {
    // A seller endpoint reached without a session outlet cannot be retried by
    // the UI, so this is a failure rather than an empty result.
    expect(
      () => requireOutletId(emptyPrefs),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Точку продажу не визначено. Увійдіть знову.',
        ),
      ),
    );
  });

  test('maybeOutletId returns the session outlet', () {
    expect(maybeOutletId(prefs), 7);
  });

  test('maybeOutletId returns null instead of throwing', () {
    expect(maybeOutletId(emptyPrefs), isNull);
  });
}
