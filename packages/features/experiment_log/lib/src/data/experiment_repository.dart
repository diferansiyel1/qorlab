import 'dart:convert';
import 'dart:io';

import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final experimentRepositoryProvider = Provider<ExperimentRepositoryInterface>((
  ref,
) {
  return ExperimentRepository(ref.watch(isarProvider).value!);
});

final experimentsProvider = StreamProvider<List<Experiment>>((ref) {
  final repository = ref.watch(experimentRepositoryProvider);
  return repository.watchExperiments();
}, dependencies: [experimentRepositoryProvider]);

class ExperimentRepository implements ExperimentRepositoryInterface {
  final Isar _isar;

  ExperimentRepository(this._isar);

  @override
  Future<void> createExperiment(Experiment experiment) async {
    await _isar.writeTxn(() async {
      experiment.startedAt ??= experiment.createdAt;
      final rawProject = experiment.projectName?.trim();
      experiment.projectName = (rawProject == null || rawProject.isEmpty)
          ? 'General Lab'
          : rawProject;
      await _isar.collection<Experiment>().put(experiment);
    });
  }

  @override
  Future<void> addLog(int experimentId, String content, String type) async {
    final occurredAt = DateTime.now();

    await _isar.writeTxn(() async {
      final experiment = await _isar.collection<Experiment>().get(experimentId);
      final startedAt = experiment?.startedAt ?? experiment?.createdAt;
      final tOffsetMs = startedAt == null
          ? null
          : occurredAt.difference(startedAt).inMilliseconds;

      final kind = switch (type) {
        'voice' => 'voice',
        'photo' => 'photo',
        'timer' => 'timer',
        'measurement' => 'measurement',
        _ => 'text',
      };

      final log = LogEntry()
        ..experimentId = experimentId
        ..content = content
        ..timestamp = occurredAt
        ..type = type
        ..kind = kind
        ..tOffsetMs = tOffsetMs
        ..payloadVersion = 1;

      await _isar.collection<LogEntry>().put(log);

      if (experiment != null) {
        experiment.lastEventAt = occurredAt;
        await _isar.collection<Experiment>().put(experiment);
      }
    });
  }

  @override
  Future<void> setExperimentStatus({
    required int experimentId,
    required bool isActive,
  }) async {
    await _isar.writeTxn(() async {
      final experiment = await _isar.collection<Experiment>().get(experimentId);
      if (experiment == null) return;
      if (experiment.isActive == isActive) return;

      final now = DateTime.now();
      experiment.isActive = isActive;
      if (isActive) {
        experiment.endedAt = null;
        experiment.startedAt ??= now;
      } else {
        experiment.endedAt = now;
      }
      experiment.lastEventAt = now;
      await _isar.collection<Experiment>().put(experiment);
    });
  }

  @override
  Future<void> deleteExperiment(int experimentId) async {
    await _isar.writeTxn(() async {
      final series = await _isar
          .collection<MeasurementSeries>()
          .filter()
          .experimentIdEqualTo(experimentId)
          .findAll();
      for (final s in series) {
        final points = await _isar
            .collection<MeasurementPoint>()
            .filter()
            .seriesIdEqualTo(s.id)
            .findAll();
        if (points.isNotEmpty) {
          await _isar.collection<MeasurementPoint>().deleteAll(
            points.map((p) => p.id).toList(),
          );
        }
      }
      if (series.isNotEmpty) {
        await _isar.collection<MeasurementSeries>().deleteAll(
          series.map((s) => s.id).toList(),
        );
      }

      final logs = await _isar
          .collection<LogEntry>()
          .filter()
          .experimentIdEqualTo(experimentId)
          .findAll();
      if (logs.isNotEmpty) {
        await _deleteLogAttachmentsInBestEffort(logs);
        await _isar.collection<LogEntry>().deleteAll(
          logs.map((l) => l.id).toList(),
        );
      }

      await _isar.collection<Experiment>().delete(experimentId);
    });
  }

  @override
  Future<void> deleteProject(String projectName) async {
    final normalized = projectName.trim();
    if (normalized.isEmpty) return;

    await _isar.writeTxn(() async {
      final experiments = await _isar
          .collection<Experiment>()
          .filter()
          .projectNameEqualTo(normalized)
          .findAll();
      for (final experiment in experiments) {
        final experimentId = experiment.id;
        final series = await _isar
            .collection<MeasurementSeries>()
            .filter()
            .experimentIdEqualTo(experimentId)
            .findAll();
        for (final s in series) {
          final points = await _isar
              .collection<MeasurementPoint>()
              .filter()
              .seriesIdEqualTo(s.id)
              .findAll();
          if (points.isNotEmpty) {
            await _isar.collection<MeasurementPoint>().deleteAll(
              points.map((p) => p.id).toList(),
            );
          }
        }
        if (series.isNotEmpty) {
          await _isar.collection<MeasurementSeries>().deleteAll(
            series.map((s) => s.id).toList(),
          );
        }

        final logs = await _isar
            .collection<LogEntry>()
            .filter()
            .experimentIdEqualTo(experimentId)
            .findAll();
        if (logs.isNotEmpty) {
          await _deleteLogAttachmentsInBestEffort(logs);
          await _isar.collection<LogEntry>().deleteAll(
            logs.map((l) => l.id).toList(),
          );
        }

        await _isar.collection<Experiment>().delete(experimentId);
      }
    });
  }

  @override
  Future<void> deleteLogEntry(int logEntryId) async {
    await _isar.writeTxn(() async {
      final log = await _isar.collection<LogEntry>().get(logEntryId);
      if (log == null) return;

      final kind = (log.kind ?? log.type).toLowerCase();
      if (kind == 'measurement' || log.type == 'measurement_point') {
        final metadata = log.metadata;
        if (metadata != null && metadata.isNotEmpty) {
          try {
            final decoded = jsonDecode(metadata);
            if (decoded is Map<String, dynamic>) {
              final pointIdRaw = decoded['pointId'];
              final pointId = pointIdRaw is int
                  ? pointIdRaw
                  : int.tryParse(pointIdRaw?.toString() ?? '');
              if (pointId != null) {
                final point = await _isar.collection<MeasurementPoint>().get(
                  pointId,
                );
                if (point != null) {
                  final seriesId = point.seriesId;
                  await _isar.collection<MeasurementPoint>().delete(pointId);
                  final hasRemaining = await _isar
                      .collection<MeasurementPoint>()
                      .filter()
                      .seriesIdEqualTo(seriesId)
                      .findFirst();
                  if (hasRemaining == null) {
                    await _isar.collection<MeasurementSeries>().delete(
                      seriesId,
                    );
                  }
                }
              }
            }
          } catch (_) {}
        }
      } else {
        await _deleteLogAttachmentsInBestEffort([log]);
      }

      await _isar.collection<LogEntry>().delete(logEntryId);
    });
  }

  @override
  Stream<List<LogEntry>> watchLogs(int experimentId) {
    return _isar
        .collection<LogEntry>()
        .filter()
        .experimentIdEqualTo(experimentId)
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  @override
  Stream<List<Experiment>> watchExperiments() {
    return _isar
        .collection<Experiment>()
        .where()
        .sortByLastEventAtDesc()
        .thenByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Future<void> _deleteLogAttachmentsInBestEffort(List<LogEntry> logs) async {
    for (final log in logs) {
      final kind = (log.kind ?? log.type).toLowerCase();
      if (kind != 'photo' && log.type != 'photo') continue;

      final candidatePath = (log.photoPath?.trim().isNotEmpty ?? false)
          ? log.photoPath!.trim()
          : log.content.trim();
      if (candidatePath.isEmpty) continue;
      try {
        final file = File(candidatePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }
}
