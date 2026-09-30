import 'package:injectable/injectable.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/admin/data/models/admin_user.dart';
import 'package:prro/features/admin/domain/repositories/admin_user_repository_i.dart';

@Environment('mock')
@Singleton(as: AdminUserRepositoryI)
class AdminUserRepositoryMock implements AdminUserRepositoryI {
  AdminUserRepositoryMock(this._mockBackend);
  final MockBackend _mockBackend;

  @override
  Future<List<AdminUser>> fetchUsers({required int outletId}) =>
      _mockBackend.getAdminUsers(outletId);
}
