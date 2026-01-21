
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TimerLogger {
  Future<void> logTimerFinished({
    required String label,
    required Duration duration,
  });
}

final timerLoggerProvider = Provider<TimerLogger>((ref) {
  throw UnimplementedError("timerLoggerProvider must be overridden");
});
