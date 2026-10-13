import 'package:injectable/injectable.dart';
import 'package:prro/core/network/api_client_i.dart';
import 'package:prro/core/network/api_exception.dart';
import 'package:prro/core/utils/envelope.dart';
import 'package:prro/features/admin/data/models/admin_user.dart';
import 'package:prro/features/admin/domain/repositories/admin_user_repository_i.dart';

@Environment('prod')
@Singleton(as: AdminUserRepositoryI)
class AdminUserRepositoryImpl implements AdminUserRepositoryI {
  AdminUserRepositoryImpl(this._apiClient);
  final ApiClientI _apiClient;

  @override
  Future<List<AdminUser>> fetchUsers({required int outletId}) =>
      dioGuard(() async {
        final response = await _apiClient.get(
          '/retail-outlets/$outletId/users',
        );
        return unwrapList(response.data, AdminUser.fromJson);
      });
}
