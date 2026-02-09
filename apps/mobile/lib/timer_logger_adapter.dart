
import 'package:smart_timer/smart_timer.dart';
import 'package:experiment_log/experiment_log.dart';

class TimerLoggerAdapter implements TimerLogger {
  final ExperimentActionHandler _handler;

  TimerLoggerAdapter(this._handler);

  @override
  Future<void> logTimerStarted({
    required String label,
    required Duration duration,
    required bool isStopwatch,
    String? phaseTag,
  }) async {
    final mode = isStopwatch ? 'stopwatch' : 'countdown';
    await _handler.logNote(
      text:
          "Timer started [$mode]: '$label' (${duration.inMinutes}m)${_phase(phaseTag)}",
    );
  }

  @override
  Future<void> logTimerPaused({
    required String label,
    required Duration elapsed,
    String? phaseTag,
  }) async {
    await _handler.logNote(
      text:
          "Timer paused: '$label' at ${_fmt(elapsed)}${_phase(phaseTag)}",
    );
  }

  @override
  Future<void> logTimerLap({
    required String label,
    required Duration elapsed,
    required int lapNumber,
    String? phaseTag,
  }) async {
    await _handler.logNote(
      text:
          "Lap $lapNumber: '$label' at ${_fmt(elapsed)}${_phase(phaseTag)}",
    );
  }

  @override
  Future<void> logTimerFinished({
    required String label,
    required Duration duration,
    required Duration elapsed,
    String? phaseTag,
  }) async {
    await _handler.logNote(
      text:
          "Timer finished: '$label' target=${_fmt(duration)} elapsed=${_fmt(elapsed)}${_phase(phaseTag)}",
    );
  }

  @override
  Future<void> logProtocolAdvanced({
    required String protocolId,
    required int stageOrder,
    required int timersStarted,
    String? phaseTag,
  }) async {
    await _handler.logNote(
      text:
          "Protocol advanced: id=$protocolId stage=${stageOrder + 1} timers=$timersStarted${_phase(phaseTag)}",
    );
  }

  String _phase(String? phaseTag) {
    if (phaseTag == null || phaseTag.trim().isEmpty) return '';
    return ' phase=${phaseTag.trim()}';
  }

  String _fmt(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
