import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:prro/di/di.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies({bool useMock = false}) async {
  await getIt.init(environment: useMock ? 'mock' : 'prod');
}
