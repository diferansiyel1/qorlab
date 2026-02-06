import 'schema/measurement_point.dart';
import 'schema/measurement_series.dart';

abstract class MeasurementRepositoryInterface {
  Future<int> createSeries(MeasurementSeries series);

  Future<int> addPoint(MeasurementPoint point);

  Stream<List<MeasurementSeries>> watchSeries(int experimentId);

  Stream<List<MeasurementPoint>> watchPoints(int seriesId);
}

