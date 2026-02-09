import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';

abstract class TimerRepository {
  Stream<List<TimerEntry>> watchTimers();
  Stream<List<TimerLapEntry>> watchLaps(String timerId);
  Future<TimerEntry?> getTimer(String timerId);
  Future<List<TimerEntry>> getTimersByProtocol(String protocolId);
  Future<void> upsertTimer(TimerEntry timer);
  Future<void> removeTimer(String timerId);
  Future<void> addLap({
    required String timerId,
    required int? experimentId,
    required Duration elapsed,
    int? tOffsetMs,
    DateTime? occurredAt,
  });
}

final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  if (!isarAsync.hasValue) {
    throw StateError('Isar database not initialized');
  }
  return IsarTimerRepository(isarAsync.value!);
});

class IsarTimerRepository implements TimerRepository {
  final Isar _isar;

  IsarTimerRepository(this._isar);

  @override
  Stream<List<TimerEntry>> watchTimers() {
    return _isar.collection<LabTimerRecord>().where().watch(
      fireImmediately: true,
    ).map((records) {
      final entries = records.map(_fromRecord).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return entries;
    });
  }

  @override
  Stream<List<TimerLapEntry>> watchLaps(String timerId) {
    return _isar
        .collection<LabTimerLapRecord>()
        .filter()
        .timerExternalIdEqualTo(timerId)
        .sortByRecordedAtDesc()
        .watch(fireImmediately: true)
        .map((records) => records.map(_fromLapRecord).toList());
  }

  @override
  Future<TimerEntry?> getTimer(String timerId) async {
    final record = await _isar
        .collection<LabTimerRecord>()
        .filter()
        .externalIdEqualTo(timerId)
        .findFirst();
    if (record == null) return null;
    return _fromRecord(record);
  }

  @override
  Future<List<TimerEntry>> getTimersByProtocol(String protocolId) async {
    final records = await _isar
        .collection<LabTimerRecord>()
        .filter()
        .protocolIdEqualTo(protocolId)
        .findAll();
    final out = records.map(_fromRecord).toList()
      ..sort((a, b) {
        final ao = a.protocolStageOrder ?? 0;
        final bo = b.protocolStageOrder ?? 0;
        if (ao != bo) return ao.compareTo(bo);
        return a.createdAt.compareTo(b.createdAt);
      });
    return out;
  }

  @override
  Future<void> upsertTimer(TimerEntry timer) async {
    await _isar.writeTxn(() async {
      final existing = await _isar
          .collection<LabTimerRecord>()
          .filter()
          .externalIdEqualTo(timer.id)
          .findFirst();
      final record = existing ?? LabTimerRecord()..externalId = timer.id;
      _applyTimerToRecord(timer, record);
      await _isar.collection<LabTimerRecord>().put(record);
    });
  }

  @override
  Future<void> removeTimer(String timerId) async {
    await _isar.writeTxn(() async {
      final records = await _isar
          .collection<LabTimerRecord>()
          .filter()
          .externalIdEqualTo(timerId)
          .findAll();
      if (records.isNotEmpty) {
        await _isar
            .collection<LabTimerRecord>()
            .deleteAll(records.map((e) => e.id).toList());
      }
      final laps = await _isar
          .collection<LabTimerLapRecord>()
          .filter()
          .timerExternalIdEqualTo(timerId)
          .findAll();
      if (laps.isNotEmpty) {
        await _isar
            .collection<LabTimerLapRecord>()
            .deleteAll(laps.map((e) => e.id).toList());
      }
    });
  }

  @override
  Future<void> addLap({
    required String timerId,
    required int? experimentId,
    required Duration elapsed,
    int? tOffsetMs,
    DateTime? occurredAt,
  }) async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      final lap = LabTimerLapRecord()
        ..timerExternalId = timerId
        ..experimentId = experimentId
        ..elapsedMs = elapsed.inMilliseconds
        ..tOffsetMs = tOffsetMs
        ..occurredAt = occurredAt
        ..recordedAt = now;
      await _isar.collection<LabTimerLapRecord>().put(lap);

      final timer = await _isar
          .collection<LabTimerRecord>()
          .filter()
          .externalIdEqualTo(timerId)
          .findFirst();
      if (timer != null) {
        timer.lapCount = timer.lapCount + 1;
        timer.updatedAt = now;
        await _isar.collection<LabTimerRecord>().put(timer);
      }
    });
  }

  static void _applyTimerToRecord(TimerEntry timer, LabTimerRecord record) {
    record.experimentId = timer.experimentId;
    record.label = timer.label;
    record.mode = _modeToString(timer.mode);
    record.phaseTag = timer.phaseTag;
    record.protocolId = timer.protocolId;
    record.protocolStageOrder = timer.protocolStageOrder;
    record.durationMs = timer.duration.inMilliseconds;
    record.remainingMs = timer.remaining.inMilliseconds;
    record.status = _statusToString(timer.status);
    record.createdAt = timer.createdAt;
    record.updatedAt = timer.updatedAt;
    record.startedAt = timer.startedAt;
    record.finishedAt = timer.finishedAt;
    record.lapCount = timer.lapCount;
    record.lastTickedAt = timer.updatedAt;
  }

  static TimerEntry _fromRecord(LabTimerRecord record) {
    return TimerEntry(
      id: record.externalId,
      experimentId: record.experimentId,
      label: record.label,
      mode: _modeFromString(record.mode),
      duration: Duration(milliseconds: record.durationMs),
      remaining: Duration(milliseconds: record.remainingMs),
      phaseTag: record.phaseTag,
      protocolId: record.protocolId,
      protocolStageOrder: record.protocolStageOrder,
      lapCount: record.lapCount,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      startedAt: record.startedAt,
      finishedAt: record.finishedAt,
      status: _statusFromString(record.status),
    );
  }

  static TimerLapEntry _fromLapRecord(LabTimerLapRecord record) {
    return TimerLapEntry(
      id: record.id,
      timerId: record.timerExternalId,
      experimentId: record.experimentId,
      elapsed: Duration(milliseconds: record.elapsedMs),
      tOffsetMs: record.tOffsetMs,
      recordedAt: record.recordedAt,
    );
  }

  static TimerStatus _statusFromString(String status) {
    return switch (status) {
      'running' => TimerStatus.running,
      'paused' => TimerStatus.paused,
      'completed' => TimerStatus.completed,
      _ => TimerStatus.idle,
    };
  }

  static String _statusToString(TimerStatus status) {
    return switch (status) {
      TimerStatus.idle => 'idle',
      TimerStatus.running => 'running',
      TimerStatus.paused => 'paused',
      TimerStatus.completed => 'completed',
    };
  }

  static TimerMode _modeFromString(String mode) {
    return switch (mode) {
      'stopwatch' => TimerMode.stopwatch,
      _ => TimerMode.countdown,
    };
  }

  static String _modeToString(TimerMode mode) {
    return switch (mode) {
      TimerMode.countdown => 'countdown',
      TimerMode.stopwatch => 'stopwatch',
    };
  }
}

