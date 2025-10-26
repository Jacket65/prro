import 'dart:convert';
import 'dart:developer';

import 'package:prro/data/api/api_client.dart';
import 'package:prro/data/repositories/balance/balance_i.dart';

class BalanceService implements BalanceServiceI {
  final ApiClient _apiClient;

  BalanceService({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<int> getBalance() async {
    try {
      final response = await _apiClient.get("/seller/balance");

      final int data = jsonDecode(response.data)['amount'];
      return data;
    } catch (e, stackTrace) {
      log("Error in getItems: $e", stackTrace: stackTrace);
      rethrow;
    }
  }
}
