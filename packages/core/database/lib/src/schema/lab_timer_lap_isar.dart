import 'package:isar/isar.dart';

part 'lab_timer_lap_isar.g.dart';

@collection
@Name('lab_timer_laps_v1')
class LabTimerLapRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String timerExternalId;

  @Index()
  int? experimentId;

  /// Milliseconds elapsed in the timer at lap mark.
  late int elapsedMs;

  /// Optional timeline-aligned time (ms from experiment start).
  int? tOffsetMs;

  DateTime? occurredAt;

  String? note;

  late DateTime recordedAt;
}

