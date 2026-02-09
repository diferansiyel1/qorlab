import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TimerNotificationScheduler {
  Future<void> scheduleCompletion({
    required String timerId,
    required String title,
    required Duration inDuration,
  });

  Future<void> cancel(String timerId);
}

class NoopTimerNotificationScheduler implements TimerNotificationScheduler {
  const NoopTimerNotificationScheduler();

  @override
  Future<void> scheduleCompletion({
    required String timerId,
    required String title,
    required Duration inDuration,
  }) async {}

  @override
  Future<void> cancel(String timerId) async {}
}

final timerNotificationSchedulerProvider = Provider<TimerNotificationScheduler>(
  (ref) => const NoopTimerNotificationScheduler(),
);

