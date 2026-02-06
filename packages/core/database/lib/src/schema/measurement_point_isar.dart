import 'package:isar/isar.dart';

part 'measurement_point_isar.g.dart';

@collection
@Name('measurement_points_v1')
class MeasurementPoint {
  Id id = Isar.autoIncrement;

  @Index()
  late int experimentId;

  @Index()
  late int seriesId;

  /// Milliseconds since experiment start (`t=0`).
  ///
  /// This enables charts aligned to a protocol timeline even if the wall clock
  /// changes (DST, timezone changes, etc.).
  @Index()
  late int tOffsetMs;

  /// Decimal value stored as string to preserve scientific precision.
  late String value;

  DateTime? occurredAt;

  String? note;
}

