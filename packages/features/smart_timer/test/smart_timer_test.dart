import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_timer/smart_timer.dart';
import 'package:smart_timer/src/data/timer_repository.dart';

class _FakeTimerRepository implements TimerRepository {
  final _timers = <String, TimerEntry>{};
  final _timersController = StreamController<List<TimerEntry>>.broadcast();
  final _lapsByTimer = <String, List<TimerLapEntry>>{};
  int _lapId = 1;

  _FakeTimerRepository() {
    _emitTimers();
  }

  @override
  Future<void> addLap({
    required String timerId,
    required int? experimentId,
    required Duration elapsed,
    int? tOffsetMs,
    DateTime? occurredAt,
  }) async {
    final list = _lapsByTimer.putIfAbsent(timerId, () => <TimerLapEntry>[]);
    list.insert(
      0,
      TimerLapEntry(
        id: _lapId++,
        timerId: timerId,
        experimentId: experimentId,
        elapsed: elapsed,
        tOffsetMs: tOffsetMs,
        recordedAt: occurredAt ?? DateTime.now(),
      ),
    );
    final timer = _timers[timerId];
    if (timer != null) {
      _timers[timerId] = timer.copyWith(
        lapCount: timer.lapCount + 1,
        updatedAt: DateTime.now(),
      );
      _emitTimers();
    }
  }

  @override
  Future<TimerEntry?> getTimer(String timerId) async => _timers[timerId];

  @override
  Future<List<TimerEntry>> getTimersByProtocol(String protocolId) async {
    final entries =
        _timers.values.where((e) => e.protocolId == protocolId).toList();
    entries.sort((a, b) {
      final ao = a.protocolStageOrder ?? 0;
      final bo = b.protocolStageOrder ?? 0;
      if (ao != bo) return ao.compareTo(bo);
      return a.createdAt.compareTo(b.createdAt);
    });
    return entries;
  }

  @override
  Future<void> removeTimer(String timerId) async {
    _timers.remove(timerId);
    _lapsByTimer.remove(timerId);
    _emitTimers();
  }

  @override
  Future<void> upsertTimer(TimerEntry timer) async {
    _timers[timer.id] = timer;
    _emitTimers();
  }

  @override
  Stream<List<TimerLapEntry>> watchLaps(String timerId) async* {
    yield _lapsByTimer[timerId] ?? const [];
  }

  @override
  Stream<List<TimerEntry>> watchTimers() => _timersController.stream;

  void _emitTimers() {
    final timers = _timers.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _timersController.add(timers);
  }
}

class _FakeTimerLogger implements TimerLogger {
  @override
  Future<void> logProtocolAdvanced({
    required String protocolId,
    required int stageOrder,
    required int timersStarted,
    String? phaseTag,
  }) async {}

  @override
  Future<void> logTimerFinished({
    required String label,
    required Duration duration,
    required Duration elapsed,
    String? phaseTag,
  }) async {}

  @override
  Future<void> logTimerLap({
    required String label,
    required Duration elapsed,
    required int lapNumber,
    String? phaseTag,
  }) async {}

  @override
  Future<void> logTimerPaused({
    required String label,
    required Duration elapsed,
    String? phaseTag,
  }) async {}

  @override
  Future<void> logTimerStarted({
    required String label,
    required Duration duration,
    required bool isStopwatch,
    String? phaseTag,
  }) async {}
}

class _FakeNotificationScheduler implements TimerNotificationScheduler {
  final scheduled = <String, Duration>{};
  final cancelled = <String>[];

  @override
  Future<void> scheduleCompletion({
    required String timerId,
    required String title,
    required Duration inDuration,
  }) async {
    scheduled[timerId] = inDuration;
  }

  @override
  Future<void> cancel(String timerId) async {
    cancelled.add(timerId);
    scheduled.remove(timerId);
  }
}

void main() {
  test('TimerController adds timer', () async {
    final notificationScheduler = _FakeNotificationScheduler();
    final container = ProviderContainer(
      overrides: [
        timerRepositoryProvider.overrideWithValue(_FakeTimerRepository()),
        timerLoggerProvider.overrideWithValue(_FakeTimerLogger()),
        timerNotificationSchedulerProvider.overrideWithValue(
          notificationScheduler,
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(timerControllerProvider.notifier);

    await controller.addTimer('Test Timer', const Duration(minutes: 5));
    await Future<void>.delayed(Duration.zero);

    final timers = container.read(timerControllerProvider);
    expect(timers.length, 1);
    expect(timers.first.label, 'Test Timer');
    expect(timers.first.status, TimerStatus.idle);
  });

  test('TimerController starts and stops timer', () async {
    final notificationScheduler = _FakeNotificationScheduler();
    final container = ProviderContainer(
      overrides: [
        timerRepositoryProvider.overrideWithValue(_FakeTimerRepository()),
        timerLoggerProvider.overrideWithValue(_FakeTimerLogger()),
        timerNotificationSchedulerProvider.overrideWithValue(
          notificationScheduler,
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(timerControllerProvider.notifier);

    await controller.addTimer('Test', const Duration(seconds: 10));
    await Future<void>.delayed(Duration.zero);
    final id = container.read(timerControllerProvider).first.id;

    await controller.startTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(timerControllerProvider).first.status,
        TimerStatus.running);

    await controller.stopTimer(id);
    await Future<void>.delayed(Duration.zero);
    final timer = container.read(timerControllerProvider).first;
    expect(timer.status, TimerStatus.idle);
    expect(timer.remaining, const Duration(seconds: 10));
  });

  test('TimerController pauses and resumes timer', () async {
    final notificationScheduler = _FakeNotificationScheduler();
    final container = ProviderContainer(
      overrides: [
        timerRepositoryProvider.overrideWithValue(_FakeTimerRepository()),
        timerLoggerProvider.overrideWithValue(_FakeTimerLogger()),
        timerNotificationSchedulerProvider.overrideWithValue(
          notificationScheduler,
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(timerControllerProvider.notifier);

    await controller.addTimer('Test', const Duration(seconds: 10));
    await Future<void>.delayed(Duration.zero);
    final id = container.read(timerControllerProvider).first.id;

    await controller.startTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(timerControllerProvider).first.status,
        TimerStatus.running);

    await controller.pauseTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(timerControllerProvider).first.status,
        TimerStatus.paused);

    await controller.startTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(timerControllerProvider).first.status,
        TimerStatus.running);
  });

  test('TimerController schedules and cancels countdown notifications',
      () async {
    final notificationScheduler = _FakeNotificationScheduler();
    final container = ProviderContainer(
      overrides: [
        timerRepositoryProvider.overrideWithValue(_FakeTimerRepository()),
        timerLoggerProvider.overrideWithValue(_FakeTimerLogger()),
        timerNotificationSchedulerProvider.overrideWithValue(
          notificationScheduler,
        ),
      ],
    );
    addTearDown(container.dispose);
    final controller = container.read(timerControllerProvider.notifier);

    await controller.addTimer('Notify Me', const Duration(seconds: 30));
    await Future<void>.delayed(Duration.zero);
    final id = container.read(timerControllerProvider).first.id;

    await controller.startTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(notificationScheduler.scheduled[id], const Duration(seconds: 30));

    await controller.pauseTimer(id);
    await Future<void>.delayed(Duration.zero);
    expect(notificationScheduler.cancelled.contains(id), isTrue);
  });
}
