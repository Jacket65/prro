import 'package:flutter/material.dart';
import 'package:prro/app.dart';
import 'package:prro/config/backend_config.dart';
import 'package:prro/di/di.dart';
import 'package:prro/services/deep_link_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(useMock: BackendConfig.useMock);

  // Initialize deep link service for NFC POS payment callbacks
  await getIt<DeepLinkServiceI>().init();

  runApp(const MyApp());
}
