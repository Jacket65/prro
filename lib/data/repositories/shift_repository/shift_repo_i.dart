abstract interface class ShiftRepositoryI {
  Future<dynamic> openShift();
  Future<void> closeShift();
  Future<void> saveShiftState(bool bool);

  bool getShiftState();
}

abstract interface class ShiftServiceI {
  Future<dynamic> openShift();
  Future<void> closeShift();

  Future<void> saveShiftState(bool bool);
  bool getShiftState();
}
