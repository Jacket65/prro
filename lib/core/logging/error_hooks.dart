import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

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
