import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/logging/error_hooks.dart';
import 'package:talker/talker.dart';

class _CapturingObserver extends TalkerObserver {
  final List<TalkerData> records = <TalkerData>[];

  @override
  void onLog(TalkerData log) => records.add(log);

  @override
  void onError(TalkerError err) => records.add(err);
}

void main() {
  late _CapturingObserver observer;
  late Talker talker;
  late FlutterExceptionHandler? originalOnError;

  setUp(() {
    observer = _CapturingObserver();
    talker = Talker(
      observer: observer,
      settings: TalkerSettings(useConsoleLogs: false),
    );
    originalOnError = FlutterError.onError;
  });

  tearDown(() {
    FlutterError.onError = originalOnError;
  });

  test('records a Flutter error in the log', () {
    installErrorHooks(talker);

    final handler = FlutterError.onError;
    expect(handler, isNotNull);
    handler?.call(
      FlutterErrorDetails(
        exception: StateError('boom'),
        stack: StackTrace.current,
      ),
    );

    expect(observer.records, hasLength(1));
    final record = observer.records.single;
    expect(record.message, contains('Flutter error'));
    expect(record.error, isA<StateError>());
  });

  test('keeps the previous Flutter error handler', () {
    var previousCalled = false;
    FlutterError.onError = (details) => previousCalled = true;

    installErrorHooks(talker);

    final handler = FlutterError.onError;
    handler?.call(FlutterErrorDetails(exception: StateError('boom')));

    expect(previousCalled, isTrue);
  });
}
