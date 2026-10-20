import 'package:talker/talker.dart';

/// The application-wide logger.
///
/// One instance for the whole app: every record lands in the same history
/// and the same console stream, so a failure is read as one timeline instead
/// of one per module. The DI container hands out this same instance
/// (`AppModule.talker`), so an injected [Talker] and a direct [appTalker]
/// reference are the same object — one history, not several.
///
/// Colors are off: the output is read from `flutter logs` and from a device
/// console, where ANSI escapes are only noise. The history keeps the last 500
/// records — enough to cover a shift, small enough to stay cheap on a
/// low-end terminal.
final Talker appTalker = Talker(
  logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: false)),
  settings: TalkerSettings(maxHistoryItems: 500),
);
