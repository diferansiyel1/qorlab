
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TimerLogger {
  Future<void> logTimerStarted({
    required String label,
    required Duration duration,
    required bool isStopwatch,
    String? phaseTag,
  });

  Future<void> logTimerPaused({
    required String label,
    required Duration elapsed,
    String? phaseTag,
  });

  Future<void> logTimerLap({
    required String label,
    required Duration elapsed,
    required int lapNumber,
    String? phaseTag,
  });

  Future<void> logTimerFinished({
    required String label,
    required Duration duration,
    required Duration elapsed,
    String? phaseTag,
  });

  Future<void> logProtocolAdvanced({
    required String protocolId,
    required int stageOrder,
    required int timersStarted,
    String? phaseTag,
  });
}

final timerLoggerProvider = Provider<TimerLogger>((ref) {
  throw UnimplementedError("timerLoggerProvider must be overridden");
});
