import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prro/app.dart';
import 'package:prro/data/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:talker/talker.dart';
// import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
// import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';

void main() async {
  // final talker = Talker();
  // Bloc.observer = TalkerBlocObserver(
  //   talker: talker,
  //   settings: TalkerBlocLoggerSettings(),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio();
  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient(dio: dio, prefs: prefs);
  runApp(MyApp(apiClient: apiClient, prefs: prefs));
}
