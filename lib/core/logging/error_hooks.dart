import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

/// Records uncaught Flutter and platform errors in [talker].
///
/// The previous [FlutterError.onError] handler is still called, so the console
/// dump and the debug error widget stay as they were.
void installErrorHooks(Talker talker) {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'Flutter error');
    previousOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Uncaught platform error');
    return true;
  };
}
