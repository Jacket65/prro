import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prro/core/logging/app_talker.dart';
import 'package:prro/core/logging/logs_screen.dart';

void main() {
  testWidgets('lists the recorded log entries', (tester) async {
    appTalker.info('[LOG SCREEN TEST] a recorded entry');

    await tester.pumpWidget(const MaterialApp(home: LogsScreen()));

    expect(find.textContaining('[LOG SCREEN TEST] a recorded entry'), findsOne);
  });

  testWidgets('says so when nothing was logged', (tester) async {
    appTalker.cleanHistory();

    await tester.pumpWidget(const MaterialApp(home: LogsScreen()));

    expect(find.text('Журнал порожній'), findsOne);
  });
}
