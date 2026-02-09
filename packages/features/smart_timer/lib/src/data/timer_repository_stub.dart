import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  return InMemoryTimerRepository();
});

class InMemoryTimerRepository implements TimerRepository {
  final _timers = <String, TimerEntry>{};
  final _lapsByTimer = <String, List<TimerLapEntry>>{};
  final _timersController = StreamController<List<TimerEntry>>.broadcast();
  final _lapControllers = <String, StreamController<List<TimerLapEntry>>>{};
  int _lapCounter = 1;

  InMemoryTimerRepository() {
    _emitTimers();
  }

  @override
  Stream<List<TimerEntry>> watchTimers() => _timersController.stream;

  @override
  Stream<List<TimerLapEntry>> watchLaps(String timerId) {
    final controller = _lapControllers.putIfAbsent(
      timerId,
      () => StreamController<List<TimerLapEntry>>.broadcast(),
    );
    controller.add(List<TimerLapEntry>.from(_lapsByTimer[timerId] ?? const []));
    return controller.stream;
  }

  @override
  Future<TimerEntry?> getTimer(String timerId) async => _timers[timerId];

  @override
  Future<List<TimerEntry>> getTimersByProtocol(String protocolId) async {
    final out = _timers.values
        .where((t) => t.protocolId == protocolId)
        .toList()
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
    _timers[timer.id] = timer;
    _emitTimers();
  }

  @override
  Future<void> removeTimer(String timerId) async {
    _timers.remove(timerId);
    _lapsByTimer.remove(timerId);
    _emitTimers();
    _emitLaps(timerId);
  }

  @override
  Future<void> addLap({
    required String timerId,
    required int? experimentId,
    required Duration elapsed,
    int? tOffsetMs,
    DateTime? occurredAt,
  }) async {
    final lap = TimerLapEntry(
      id: _lapCounter++,
      timerId: timerId,
      experimentId: experimentId,
      elapsed: elapsed,
      tOffsetMs: tOffsetMs,
      recordedAt: occurredAt ?? DateTime.now(),
    );
    final laps = _lapsByTimer.putIfAbsent(timerId, () => <TimerLapEntry>[]);
    laps.insert(0, lap);

    final timer = _timers[timerId];
    if (timer != null) {
      _timers[timerId] = timer.copyWith(
        lapCount: timer.lapCount + 1,
        updatedAt: DateTime.now(),
      );
      _emitTimers();
    }

    _emitLaps(timerId);
  }

  void _emitTimers() {
    final timers = _timers.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _timersController.add(timers);
  }

  void _emitLaps(String timerId) {
    final controller = _lapControllers[timerId];
    if (controller != null && !controller.isClosed) {
      controller.add(List<TimerLapEntry>.from(_lapsByTimer[timerId] ?? const []));
    }
  }
}

