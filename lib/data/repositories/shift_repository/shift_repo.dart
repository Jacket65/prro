import 'dart:developer';

import 'package:prro/data/api/api_client_i.dart';
import 'package:prro/data/repositories/shift_repository/shift_repo_i.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftService implements ShiftServiceI {
  final ApiClientI _apiClient;
  final SharedPreferences _prefs;

  ShiftService({
    required ApiClientI apiClient,
    required SharedPreferences prefs,
  }) : _apiClient = apiClient,
       _prefs = prefs;
  @override
  Future<dynamic> openShift() async {
    try {
      return await _apiClient.post("/seller/open_shift");
    } catch (e, stackTrace) {
      log("Error in getItems: $e", stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> closeShift() async {
    try {
      await _apiClient.patch("/seller/close_shift");
    } catch (e, stackTrace) {
      log("Error in getItems: $e", stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveShiftState(bool state) async {
    await _prefs.setBool('shift_opened', state);
  }

  @override
  bool getShiftState() {
    return _prefs.getBool("shift_opened") ?? false;
  }
}

class ShiftRepository implements ShiftRepositoryI {
  final ShiftServiceI _shiftService;

  ShiftRepository({required ShiftServiceI shiftService})
    : _shiftService = shiftService;

  @override
  Future<void> closeShift() {
    try {
      return _shiftService.closeShift();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<dynamic> openShift() {
    try {
      return _shiftService.openShift();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> saveShiftState(bool state) async {
    await _shiftService.saveShiftState(state);
  }

  @override
  bool getShiftState() {
    return _shiftService.getShiftState();
  }
}
