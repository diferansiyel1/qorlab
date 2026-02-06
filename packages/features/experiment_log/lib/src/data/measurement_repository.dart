import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final measurementRepositoryProvider =
    Provider<MeasurementRepositoryInterface>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError('Isar database not initialized');
  }
  return IsarMeasurementRepository(isarAsync.value!);
});

class IsarMeasurementRepository implements MeasurementRepositoryInterface {
  final Isar _isar;

  IsarMeasurementRepository(this._isar);

  @override
  Future<int> createSeries(MeasurementSeries series) async {
    return _isar.writeTxn(() async {
      return _isar.collection<MeasurementSeries>().put(series);
    });
  }

  @override
  Future<int> addPoint(MeasurementPoint point) async {
    return _isar.writeTxn(() async {
      return _isar.collection<MeasurementPoint>().put(point);
    });
  }

  @override
  Stream<List<MeasurementSeries>> watchSeries(int experimentId) {
    return _isar
        .collection<MeasurementSeries>()
        .filter()
        .experimentIdEqualTo(experimentId)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<MeasurementPoint>> watchPoints(int seriesId) {
    return _isar
        .collection<MeasurementPoint>()
        .filter()
        .seriesIdEqualTo(seriesId)
        .sortByTOffsetMs()
        .watch(fireImmediately: true);
  }
}

