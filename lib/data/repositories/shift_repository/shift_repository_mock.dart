import 'package:injectable/injectable.dart';
import 'package:prro/data/api/models/shift.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';

@Environment('mock')
@Singleton(as: ShiftRepositoryI)
class ShiftRepositoryMock implements ShiftRepositoryI {
  ShiftRepositoryMock(this._shiftService);
  final ShiftServiceI _shiftService;

  @override
  Future<ShiftResponse?> currentShift() => _shiftService.currentShift();

  @override
  Future<ShiftResponse> openShift({
    required String idempotencyKey,
    String cashStart = '0.00',
  }) => _shiftService.openShift(
    cashStart: cashStart,
    idempotencyKey: idempotencyKey,
  );

  @override
  Future<void> closeShift({
    required String cashEnd,
    required String idempotencyKey,
  }) => _shiftService.closeShift(
    cashEnd: cashEnd,
    idempotencyKey: idempotencyKey,
  );
}
