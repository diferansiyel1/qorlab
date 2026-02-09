import 'package:isar/isar.dart';

part 'lab_timer_isar.g.dart';

@collection
@Name('lab_timers_v1')
class LabTimerRecord {
  Id id = Isar.autoIncrement;

  /// Stable external ID used across app layers and archive exports.
  @Index(unique: true)
  late String externalId;

  @Index()
  int? experimentId;

  late String label;

  /// "countdown" | "stopwatch"
  @Index()
  late String mode;

  /// Nullable phase label for protocol grouping (e.g. "Incubation").
  @Index()
  String? phaseTag;

  /// Protocol run id for sequential/parallel orchestration.
  @Index()
  String? protocolId;

  /// Same order means parallel timers in the same stage.
  @Index()
  int? protocolStageOrder;

  /// Milliseconds for countdown target; zero for stopwatch.
  late int durationMs;

  /// Remaining milliseconds for countdown; elapsed for stopwatch.
  late int remainingMs;

  /// "idle" | "running" | "paused" | "completed"
  @Index()
  late String status;

  /// Monotonic wall-clock marker for the most recent state transition.
  DateTime? lastTickedAt;

  late DateTime createdAt;
  late DateTime updatedAt;
  DateTime? startedAt;
  DateTime? finishedAt;

  int lapCount = 0;
}

