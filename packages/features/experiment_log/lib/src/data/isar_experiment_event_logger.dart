import 'dart:convert';

import 'package:database/database.dart';
import 'package:experiment_domain/experiment_domain.dart';
import 'package:isar/isar.dart';

class IsarExperimentEventLogger implements ExperimentEventLogger {
  final Isar _isar;

  IsarExperimentEventLogger(this._isar);

  @override
  Future<void> logEvent(ExperimentEvent event) async {
    await _isar.writeTxn(() async {
      final experiment =
          await _isar.collection<Experiment>().get(event.experimentId);

      final startedAt = experiment?.startedAt ?? experiment?.createdAt;
      final computedOffsetMs = startedAt == null
          ? null
          : event.occurredAt.difference(startedAt).inMilliseconds;

      final entry = LogEntry()
        ..timestamp = event.occurredAt
        ..experimentId = event.experimentId
        ..kind = event.kind.name
        ..tOffsetMs = event.tOffsetMs ?? computedOffsetMs
        ..payloadVersion = event.payloadVersion
        ..type = event.type
        ..content = event.summary
        ..metadata = jsonEncode(event.payload);

      await _isar.collection<LogEntry>().put(entry);

      if (experiment != null) {
        experiment.lastEventAt = event.occurredAt;
        await _isar.collection<Experiment>().put(experiment);
      }
    });
  }
}

