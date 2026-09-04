import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/admin/admin_user.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/admin_user_repository/admin_user_repository.dart';

@Environment('mock')
@Singleton(as: AdminUserRepositoryI)
class AdminUserRepositoryMock implements AdminUserRepositoryI {
  AdminUserRepositoryMock(this._mockBackend);
  final MockBackend _mockBackend;

  @override
  Future<List<AdminUser>> fetchUsers({required int outletId}) =>
      _mockBackend.getAdminUsers(outletId);
}
