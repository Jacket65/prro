import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/data/outlet_scope.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/features/seller/data/repositories/items_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class _MockApiClient extends Mock implements ApiClientI {}

Response<dynamic> _response(dynamic data) => Response<dynamic>(
  requestOptions: RequestOptions(path: '/test'),
  data: {'data': data},
);

void main() {
  late _MockApiClient apiClient;
  late ItemsRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'outlet_id': 7});
    apiClient = _MockApiClient();
    final prefs = await SharedPreferences.getInstance();
    repository = ItemsRepository(
      apiClient: apiClient,
      outlets: OutletSession(prefs),
      talker: Talker(settings: TalkerSettings(useConsoleLogs: false)),
    );
  });

  test(
    'getCategories returns categories parsed from the outlet endpoint',
    () async {
      when(() => apiClient.get(any())).thenAnswer(
        (_) async => _response([
          {'id': 1, 'name': 'Кава', 'items': <dynamic>[]},
        ]),
      );

      final result = await repository.getCategories();

      expect(result, [const Category(id: 1, name: 'Кава')]);
      verify(() => apiClient.get('/retail-outlets/7/categories')).called(1);
    },
  );

  test(
    'getProducts flattens single-variant products into orderable tiles',
    () async {
      when(() => apiClient.get(any())).thenAnswer(
        (_) async => _response([
          {
            'id': 10,
            'name': 'Американо',
            'variants': [
              {
                'id': '100',
                'name': '250 мл',
                'price': '55.00',
                'quantity': '1',
              },
            ],
          },
        ]),
      );

      final result = await repository.getProducts(1);

      expect(result, hasLength(1));
      expect(
        (result.single as Product).id,
        '100',
        reason: 'a group with one variant renders as the variant itself',
      );
      verify(() => apiClient.get('/categories/1/products')).called(1);
    },
  );

  group('getVariantOptions (in-flight de-duplication)', () {
    void stubOptions() {
      when(() => apiClient.get(any())).thenAnswer(
        (_) async => _response([
          {'id': 1, 'name': 'Сиропи', 'options': const <dynamic>[]},
        ]),
      );
    }

    test('two overlapping calls share exactly one request', () async {
      stubOptions();

      // The options picker and the bean picker fire for the same variant
      // before the first response lands; the in-flight map is what keeps this
      // to one round-trip.
      final first = repository.getVariantOptions(1);
      final second = repository.getVariantOptions(1);
      await Future.wait([first, second]);

      verify(() => apiClient.get('/variants/1/options')).called(1);
    });

    test('a repeat selection after the first settles hits the cache', () async {
      stubOptions();

      await repository.getVariantOptions(1);
      await repository.getVariantOptions(1);
      await repository.getVariantOptions(1);

      verify(() => apiClient.get('/variants/1/options')).called(1);
    });

    test('the in-flight entry is dropped as the call settles', () async {
      stubOptions();

      // Regression for the awaited `_optionsInFlight.remove`: awaiting
      // the removal re-entered the future being completed, so the entry
      // (and the next request) could not be observed in the same
      // microtask.
      await repository.getVariantOptions(1);

      // The beans caller for the same variant shares the cached response,
      // and the variant-1 in-flight entry is already gone, so exactly one
      // round-trip happened in total.
      await repository.getVariantBeans(1);

      verify(() => apiClient.get('/variants/1/options')).called(1);
    });
  });
}
