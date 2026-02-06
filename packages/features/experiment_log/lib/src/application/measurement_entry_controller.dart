import 'package:database/database.dart';
import 'package:decimal/decimal.dart';
import 'package:experiment_domain/experiment_domain.dart';
import 'package:experiment_log/src/data/isar_experiment_event_logger.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measurement_entry_controller.g.dart';

@riverpod
class MeasurementEntryController extends _$MeasurementEntryController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> logMeasurement({
    required int experimentId,
    required String label,
    required String unit,
    required Decimal value,
    String? note,
    DateTime? occurredAt,
    String source = 'manual',
  }) async {
    if (experimentId <= 0) {
      throw ArgumentError.value(experimentId, 'experimentId');
    }
    if (label.trim().isEmpty) {
      throw ArgumentError.value(label, 'label');
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final isar = await ref.read(isarProvider.future);
      final now = occurredAt ?? DateTime.now();
      final eventLogger = IsarExperimentEventLogger(isar);

      await isar.writeTxn(() async {
        final experiment = await isar.collection<Experiment>().get(experimentId);
        if (experiment == null) {
          throw StateError('Experiment not found: $experimentId');
        }

        final startedAt = experiment.startedAt ?? experiment.createdAt;
        final tOffsetMs = now.difference(startedAt).inMilliseconds;

        final normalizedLabel = label.trim();
        final normalizedUnit = unit.trim();

        final existingSeries = await isar
            .collection<MeasurementSeries>()
            .filter()
            .experimentIdEqualTo(experimentId)
            .labelEqualTo(normalizedLabel)
            .unitEqualTo(normalizedUnit)
            .findFirst();

        final series = existingSeries ??
            (MeasurementSeries()
              ..experimentId = experimentId
              ..label = normalizedLabel
              ..unit = normalizedUnit
              ..source = source
              ..createdAt = DateTime.now());

        if (existingSeries == null) {
          await isar.collection<MeasurementSeries>().put(series);
        }

        final point = MeasurementPoint()
          ..experimentId = experimentId
          ..seriesId = series.id
          ..tOffsetMs = tOffsetMs
          ..value = value.toString()
          ..occurredAt = now
          ..note = note?.trim().isEmpty == true ? null : note?.trim();

        await isar.collection<MeasurementPoint>().put(point);

        await eventLogger.logEventInTxn(
          ExperimentEvent(
            experimentId: experimentId,
            occurredAt: now,
            payloadVersion: 1,
            kind: ExperimentEventKind.measurement,
            type: 'measurement_point',
            summary: normalizedUnit.isEmpty
                ? '${series.label}: ${point.value}'
                : '${series.label}: ${point.value} ${series.unit}',
            payload: {
              'seriesId': series.id,
              'pointId': point.id,
              'label': series.label,
              'unit': series.unit,
              'value': point.value,
              if (point.note != null) 'note': point.note,
              'tOffsetMs': point.tOffsetMs,
              'source': source,
            },
          ),
        );
      });
    });
  }
}
