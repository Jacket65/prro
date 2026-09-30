import 'package:injectable/injectable.dart';
import 'package:prro/core/mock/mock_backend.dart';
import 'package:prro/features/admin/data/models/retail_outlet.dart';
import 'package:prro/features/admin/domain/repositories/admin_outlet_repository_i.dart';

@Environment('mock')
@Singleton(as: AdminOutletRepositoryI)
class AdminOutletRepositoryMock implements AdminOutletRepositoryI {
  AdminOutletRepositoryMock(this._mockBackend);
  final MockBackend _mockBackend;

  @override
  Future<List<RetailOutlet>> fetchOutlets() => _mockBackend.getAdminOutlets();
}
