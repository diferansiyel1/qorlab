/// Web-friendly `MeasurementPoint` model.
///
/// The app doesn't use Isar on the web (we override repositories with in-memory
/// implementations), but we still need the type to exist so the UI compiles.
class MeasurementPoint {
  int id = 0;

  late int experimentId;

  late int seriesId;

  late int tOffsetMs;

  late String value;

  DateTime? occurredAt;

  String? note;

  MeasurementPoint();
}

