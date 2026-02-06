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
      await logEventInTxn(event);
    });
  }

  /// Logs an event assuming the caller already opened a write transaction.
  ///
  /// This avoids nested Isar write transactions for composite operations
  /// (e.g., writing a measurement point and its timeline entry atomically).
  Future<void> logEventInTxn(ExperimentEvent event) async {
    final experiment =
        await _isar.collection<Experiment>().get(event.experimentId);

    final startedAt = experiment?.startedAt ?? experiment?.createdAt;
    final computedOffsetMs = startedAt == null
        ? null
        : event.occurredAt.difference(startedAt).inMilliseconds;

    final photoPath = event.kind == ExperimentEventKind.photo
        ? event.payload['path']?.toString()
        : null;

    final entry = LogEntry()
      ..timestamp = event.occurredAt
      ..experimentId = event.experimentId
      ..kind = event.kind.name
      ..tOffsetMs = event.tOffsetMs ?? computedOffsetMs
      ..payloadVersion = event.payloadVersion
      ..type = event.type
      ..content = event.summary
      ..photoPath = photoPath
      ..metadata = jsonEncode(event.payload);

    await _isar.collection<LogEntry>().put(entry);

    if (experiment != null) {
      experiment.lastEventAt = event.occurredAt;
      await _isar.collection<Experiment>().put(experiment);
    }
  }
}
