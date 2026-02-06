import 'package:isar/isar.dart';

part 'measurement_series_isar.g.dart';

@collection
@Name('measurement_series_v1')
class MeasurementSeries {
  Id id = Isar.autoIncrement;

  @Index()
  late int experimentId;

  /// Human label, e.g. "Temperature", "Absorbance", "pH".
  late String label;

  /// Unit symbol, e.g. "°C", "AU", "pH", "mM".
  late String unit;

  /// Optional data source, e.g. "manual", "device:thermocouple", "import:csv".
  String? source;

  late DateTime createdAt;

  /// Optional display color (ARGB int) for consistent chart colors.
  int? colorArgb;
}

