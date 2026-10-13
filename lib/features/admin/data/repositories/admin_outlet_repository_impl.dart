import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/admin/data/models/retail_outlet.dart';
import 'package:prro/features/admin/domain/repositories/admin_outlet_repository_i.dart';

@Environment('prod')
@Singleton(as: AdminOutletRepositoryI)
class AdminOutletRepositoryImpl implements AdminOutletRepositoryI {
  AdminOutletRepositoryImpl(this._apiClient);
  final ApiClientI _apiClient;

  @override
  Future<List<RetailOutlet>> fetchOutlets() async {
    try {
      final response = await _apiClient.get('/retail-outlets/');
      return unwrapList(response.data, RetailOutlet.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
