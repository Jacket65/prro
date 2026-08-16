import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/admin/retail_outlet.dart';
import 'package:prro/data/mock/mock_backend.dart';
import 'package:prro/data/repositories/admin_outlet_repository/admin_outlet_repository.dart';

@Environment('mock')
@Singleton(as: AdminOutletRepositoryI)
class AdminOutletRepositoryMock implements AdminOutletRepositoryI {
  AdminOutletRepositoryMock(this._mockBackend);
  final MockBackend _mockBackend;

  @override
  Future<List<RetailOutlet>> fetchOutlets() => _mockBackend.getAdminOutlets();
}
