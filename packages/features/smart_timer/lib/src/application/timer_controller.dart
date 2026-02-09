import 'dart:async';

import 'package:database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_timer/src/data/timer_repository.dart';
import 'package:smart_timer/src/domain/timer_context.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';
import 'package:smart_timer/src/domain/timer_logger.dart';
import 'package:smart_timer/src/domain/timer_notification_scheduler.dart';
import 'package:uuid/uuid.dart';

part 'timer_controller.g.dart';

@Riverpod(keepAlive: true)
class TimerController extends _$TimerController {
  Timer? _ticker;
  StreamSubscription<List<TimerEntry>>? _sub;
  bool _tickInProgress = false;
  static const _uuid = Uuid();

  @override
  List<TimerEntry> build() {
    final repository = ref.watch(timerRepositoryProvider);
    _sub?.cancel();
    _sub = repository.watchTimers().listen((timers) {
      state = timers;
      _syncTickerWithState();
    });
    ref.onDispose(() {
      _sub?.cancel();
      _ticker?.cancel();
    });
    return const [];
  }

  Stream<List<TimerLapEntry>> watchLaps(String timerId) {
    return ref.read(timerRepositoryProvider).watchLaps(timerId);
  }

  Future<void> addTimer(
    String label,
    Duration duration, {
    int? experimentId,
    String? phaseTag,
    TimerMode mode = TimerMode.countdown,
    String? protocolId,
    int? protocolStageOrder,
  }) async {
    final now = DateTime.now();
    final effectiveExperimentId =
        experimentId ?? ref.read(timerExperimentContextProvider);
    final timer = TimerEntry(
      id: _uuid.v4(),
      experimentId: effectiveExperimentId,
      label: label.trim().isEmpty ? 'Timer' : label.trim(),
      mode: mode,
      duration: mode == TimerMode.stopwatch ? Duration.zero : duration,
      remaining: mode == TimerMode.stopwatch ? Duration.zero : duration,
      phaseTag: phaseTag?.trim().isEmpty == true ? null : phaseTag?.trim(),
      protocolId: protocolId,
      protocolStageOrder: protocolStageOrder,
      lapCount: 0,
      createdAt: now,
      updatedAt: now,
      status: TimerStatus.idle,
    );
    await ref.read(timerRepositoryProvider).upsertTimer(timer);
  }

  Future<String> addProtocolStages({
    required List<ProtocolStageDraft> stages,
    int? experimentId,
    String? protocolId,
  }) async {
    final safeProtocolId = protocolId ?? _uuid.v4();
    for (var stageIndex = 0; stageIndex < stages.length; stageIndex++) {
      final stage = stages[stageIndex];
      for (final step in stage.steps) {
        await addTimer(
          step.label,
          step.duration,
          experimentId: experimentId,
          phaseTag: stage.phaseTag,
          mode: step.mode,
          protocolId: safeProtocolId,
          protocolStageOrder: stageIndex,
        );
      }
    }
    return safeProtocolId;
  }

  Future<void> startProtocol(String protocolId) async {
    final repository = ref.read(timerRepositoryProvider);
    final timers = await repository.getTimersByProtocol(protocolId);
    if (timers.isEmpty) return;
    final stage = timers
        .where((t) => t.status != TimerStatus.completed)
        .map((t) => t.protocolStageOrder ?? 0)
        .fold<int?>(null, (current, value) {
          if (current == null) return value;
          return value < current ? value : current;
        });
    if (stage == null) return;
    final stageTimers = timers.where(
      (t) => (t.protocolStageOrder ?? 0) == stage && t.status == TimerStatus.idle,
    );
    for (final timer in stageTimers) {
      await startTimer(timer.id);
    }
    await ref.read(timerLoggerProvider).logProtocolAdvanced(
      protocolId: protocolId,
      stageOrder: stage,
      timersStarted: stageTimers.length,
      phaseTag: stageTimers.isEmpty ? null : stageTimers.first.phaseTag,
    );
  }

  Future<void> startTimer(String id) async {
    final timer = _findTimer(id);
    if (timer == null || timer.status == TimerStatus.running) return;
    final now = DateTime.now();
    final next = timer.copyWith(
      status: TimerStatus.running,
      startedAt: timer.startedAt ?? now,
      finishedAt: null,
      updatedAt: now,
    );
    await ref.read(timerRepositoryProvider).upsertTimer(next);
    if (next.mode == TimerMode.countdown && next.remaining > Duration.zero) {
      await ref.read(timerNotificationSchedulerProvider).scheduleCompletion(
        timerId: next.id,
        title: next.label,
        inDuration: next.remaining,
      );
    }
    await ref.read(timerLoggerProvider).logTimerStarted(
      label: next.label,
      duration: next.duration,
      isStopwatch: next.mode == TimerMode.stopwatch,
      phaseTag: next.phaseTag,
    );
    _syncTickerWithState();
  }

  Future<void> pauseTimer(String id) async {
    final timer = _findTimer(id);
    if (timer == null || timer.status != TimerStatus.running) return;
    final next = timer.copyWith(
      status: TimerStatus.paused,
      updatedAt: DateTime.now(),
    );
    await ref.read(timerRepositoryProvider).upsertTimer(next);
    await ref.read(timerNotificationSchedulerProvider).cancel(next.id);
    await ref.read(timerLoggerProvider).logTimerPaused(
      label: next.label,
      elapsed: next.elapsed,
      phaseTag: next.phaseTag,
    );
    _syncTickerWithState();
  }

  Future<void> stopTimer(String id) async {
    final timer = _findTimer(id);
    if (timer == null) return;
    final resetRemaining = timer.mode == TimerMode.stopwatch
        ? Duration.zero
        : timer.duration;
    final next = timer.copyWith(
      status: TimerStatus.idle,
      remaining: resetRemaining,
      updatedAt: DateTime.now(),
      finishedAt: null,
    );
    await ref.read(timerRepositoryProvider).upsertTimer(next);
    await ref.read(timerNotificationSchedulerProvider).cancel(next.id);
    _syncTickerWithState();
  }

  Future<void> addLap(String id) async {
    final timer = _findTimer(id);
    if (timer == null) return;
    final tOffsetMs = await _resolveExperimentOffsetMs(
      experimentId: timer.experimentId,
    );
    await ref.read(timerRepositoryProvider).addLap(
      timerId: timer.id,
      experimentId: timer.experimentId,
      elapsed: timer.elapsed,
      tOffsetMs: tOffsetMs,
      occurredAt: DateTime.now(),
    );
    await ref.read(timerLoggerProvider).logTimerLap(
      label: timer.label,
      elapsed: timer.elapsed,
      lapNumber: timer.lapCount + 1,
      phaseTag: timer.phaseTag,
    );
  }

  Future<void> removeTimer(String id) async {
    await ref.read(timerRepositoryProvider).removeTimer(id);
    await ref.read(timerNotificationSchedulerProvider).cancel(id);
    _syncTickerWithState();
  }

  TimerEntry? _findTimer(String id) {
    for (final timer in state) {
      if (timer.id == id) return timer;
    }
    return null;
  }

  void _syncTickerWithState() {
    final hasRunning = state.any((timer) => timer.status == TimerStatus.running);
    if (!hasRunning) {
      _ticker?.cancel();
      return;
    }
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      unawaited(_onTick());
    });
  }

  Future<void> _onTick() async {
    if (_tickInProgress) return;
    _tickInProgress = true;
    try {
      final now = DateTime.now();
      final repository = ref.read(timerRepositoryProvider);
      final protocolIdsToCheck = <String>{};

      for (final timer in List<TimerEntry>.from(state)) {
        if (timer.status != TimerStatus.running) continue;
        if (timer.mode == TimerMode.stopwatch) {
          final next = timer.copyWith(
            remaining: timer.remaining + const Duration(seconds: 1),
            updatedAt: now,
          );
          await repository.upsertTimer(next);
          continue;
        }

        final nextRemaining = timer.remaining - const Duration(seconds: 1);
        if (nextRemaining > Duration.zero) {
          final next = timer.copyWith(remaining: nextRemaining, updatedAt: now);
          await repository.upsertTimer(next);
          continue;
        }

        final completed = timer.copyWith(
          remaining: Duration.zero,
          status: TimerStatus.completed,
          finishedAt: now,
          updatedAt: now,
        );
        await repository.upsertTimer(completed);
        await ref.read(timerNotificationSchedulerProvider).cancel(completed.id);
        await ref.read(timerLoggerProvider).logTimerFinished(
          label: completed.label,
          duration: completed.duration,
          elapsed: completed.elapsed,
          phaseTag: completed.phaseTag,
        );
        if (completed.protocolId != null && completed.protocolId!.isNotEmpty) {
          protocolIdsToCheck.add(completed.protocolId!);
        }
      }

      for (final protocolId in protocolIdsToCheck) {
        await _advanceProtocolIfNeeded(protocolId);
      }
    } finally {
      _tickInProgress = false;
    }
  }

  Future<void> _advanceProtocolIfNeeded(String protocolId) async {
    final repository = ref.read(timerRepositoryProvider);
    final timers = await repository.getTimersByProtocol(protocolId);
    if (timers.isEmpty) return;

    if (timers.any((t) => t.status == TimerStatus.running)) {
      return;
    }

    final pending = timers.where((t) => t.status != TimerStatus.completed).toList();
    if (pending.isEmpty) return;

    final nextStage = pending
        .map((t) => t.protocolStageOrder ?? 0)
        .reduce((a, b) => a < b ? a : b);
    final stageTimers = pending.where(
      (t) => (t.protocolStageOrder ?? 0) == nextStage,
    );
    for (final timer in stageTimers) {
      await startTimer(timer.id);
    }
    await ref.read(timerLoggerProvider).logProtocolAdvanced(
      protocolId: protocolId,
      stageOrder: nextStage,
      timersStarted: stageTimers.length,
      phaseTag: stageTimers.isEmpty ? null : stageTimers.first.phaseTag,
    );
  }

  Future<int?> _resolveExperimentOffsetMs({required int? experimentId}) async {
    if (experimentId == null) return null;
    try {
      final isarAsync = ref.read(isarProvider);
      if (!isarAsync.hasValue) return null;
      final experiment = await isarAsync.value!
          .collection<Experiment>()
          .get(experimentId);
      if (experiment == null) return null;
      final startedAt = experiment.startedAt ?? experiment.createdAt;
      return DateTime.now().difference(startedAt).inMilliseconds;
    } catch (_) {
      return null;
    }
  }
}
