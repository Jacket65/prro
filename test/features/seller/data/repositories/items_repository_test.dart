import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prro/core/domain/catalog_item.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/features/seller/data/repositories/items_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    repository = ItemsRepository(
      apiClient: apiClient,
      prefs: await SharedPreferences.getInstance(),
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
}
