import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/api/api_exception.dart';
import 'package:prro/data/api/models/admin/admin_user.dart';
import 'package:prro/data/repositories/admin_unwrap.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';

@Environment('prod')
@Singleton(as: AdminUserRepositoryI)
class AdminUserRepositoryImpl implements AdminUserRepositoryI {
  AdminUserRepositoryImpl(this._apiClient);
  final ApiClientI _apiClient;

  @override
  Future<List<AdminUser>> fetchUsers({required int outletId}) async {
    try {
      final response = await _apiClient.get(
        '/retail-outlets/$outletId/users',
      );
      return unwrapList(response.data, AdminUser.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
