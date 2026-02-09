class TimerEntry {
  final String id;
  final int? experimentId;
  final String label;
  final TimerMode mode;
  final Duration duration;
  final Duration remaining;
  final String? phaseTag;
  final String? protocolId;
  final int? protocolStageOrder;
  final int lapCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final TimerStatus status;

  const TimerEntry({
    required this.id,
    this.experimentId,
    required this.label,
    this.mode = TimerMode.countdown,
    required this.duration,
    required this.remaining,
    this.phaseTag,
    this.protocolId,
    this.protocolStageOrder,
    this.lapCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.finishedAt,
    this.status = TimerStatus.idle,
  });

  Duration get elapsed {
    if (mode == TimerMode.stopwatch) return remaining;
    final seconds = duration.inSeconds - remaining.inSeconds;
    if (seconds <= 0) return Duration.zero;
    return Duration(seconds: seconds);
  }

  TimerEntry copyWith({
    String? id,
    int? experimentId,
    String? label,
    TimerMode? mode,
    Duration? duration,
    Duration? remaining,
    String? phaseTag,
    String? protocolId,
    int? protocolStageOrder,
    int? lapCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    TimerStatus? status,
  }) {
    return TimerEntry(
      id: id ?? this.id,
      experimentId: experimentId ?? this.experimentId,
      label: label ?? this.label,
      mode: mode ?? this.mode,
      duration: duration ?? this.duration,
      remaining: remaining ?? this.remaining,
      phaseTag: phaseTag ?? this.phaseTag,
      protocolId: protocolId ?? this.protocolId,
      protocolStageOrder: protocolStageOrder ?? this.protocolStageOrder,
      lapCount: lapCount ?? this.lapCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      status: status ?? this.status,
    );
  }
}

class TimerLapEntry {
  final int id;
  final String timerId;
  final int? experimentId;
  final Duration elapsed;
  final int? tOffsetMs;
  final DateTime recordedAt;

  const TimerLapEntry({
    required this.id,
    required this.timerId,
    required this.experimentId,
    required this.elapsed,
    required this.tOffsetMs,
    required this.recordedAt,
  });
}

enum TimerMode {
  countdown,
  stopwatch,
}

enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

class ProtocolStageDraft {
  final String phaseTag;
  final List<ProtocolStepDraft> steps;

  const ProtocolStageDraft({
    required this.phaseTag,
    required this.steps,
  });
}

class ProtocolStepDraft {
  final String label;
  final Duration duration;
  final TimerMode mode;

  const ProtocolStepDraft({
    required this.label,
    required this.duration,
    this.mode = TimerMode.countdown,
  });
}
