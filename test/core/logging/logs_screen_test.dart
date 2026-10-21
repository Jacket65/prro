import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/di/di.dart';
import 'package:prro/core/logging/logs_screen.dart';
import 'package:talker/talker.dart';

void main() {
  late Talker talker;

  setUp(() async {
    talker = Talker(settings: TalkerSettings(useConsoleLogs: false));
    if (getIt.isRegistered<Talker>()) {
      await getIt.unregister<Talker>();
    }
    getIt.registerSingleton<Talker>(talker);
  });

  tearDown(() async {
    if (getIt.isRegistered<Talker>()) {
      await getIt.unregister<Talker>();
    }
  });

  testWidgets('lists the recorded log entries', (tester) async {
    talker.info('[LOG SCREEN TEST] a recorded entry');

    await tester.pumpWidget(const MaterialApp(home: LogsScreen()));

    expect(find.textContaining('[LOG SCREEN TEST] a recorded entry'), findsOne);
  });

  testWidgets('says so when nothing was logged', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LogsScreen()));

    expect(find.text('Журнал порожній'), findsOne);
  });
}
