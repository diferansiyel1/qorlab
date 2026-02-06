/// Web-friendly `MeasurementSeries` model.
///
/// The app doesn't use Isar on the web (we override repositories with in-memory
/// implementations), but we still need the type to exist so the UI compiles.
class MeasurementSeries {
  int id = 0;

  late int experimentId;

  late String label;

  late String unit;

  String? source;

  late DateTime createdAt;

  int? colorArgb;

  MeasurementSeries();
}

