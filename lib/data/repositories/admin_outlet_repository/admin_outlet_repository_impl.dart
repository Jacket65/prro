import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/admin/retail_outlet.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';
import 'package:prro/data/repositories/admin_unwrap.dart';

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
