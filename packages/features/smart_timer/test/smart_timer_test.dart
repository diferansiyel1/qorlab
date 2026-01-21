import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_timer/smart_timer.dart';

void main() {
  test('TimerController adds timer', () {
    final container = ProviderContainer();
    final controller = container.read(timerControllerProvider.notifier);

    controller.addTimer('Test Timer', const Duration(minutes: 5));

    final timers = container.read(timerControllerProvider);
    expect(timers.length, 1);
    expect(timers.first.label, 'Test Timer');
    expect(timers.first.status, TimerStatus.idle);
  });

  test('TimerController starts and stops timer', () {
     final container = ProviderContainer();
    final controller = container.read(timerControllerProvider.notifier);
    
    controller.addTimer('Test', const Duration(seconds: 10));
    final id = container.read(timerControllerProvider).first.id;

    controller.startTimer(id);
    expect(container.read(timerControllerProvider).first.status, TimerStatus.running);

    controller.stopTimer(id);
    expect(container.read(timerControllerProvider).first.status, TimerStatus.idle);
    expect(container.read(timerControllerProvider).first.remaining, const Duration(seconds: 10));
  });

   test('TimerController pauses and resumes timer', () {
     final container = ProviderContainer();
    final controller = container.read(timerControllerProvider.notifier);
    
    controller.addTimer('Test', const Duration(seconds: 10));
    final id = container.read(timerControllerProvider).first.id;

    controller.startTimer(id);
    expect(container.read(timerControllerProvider).first.status, TimerStatus.running);

    controller.pauseTimer(id);
    expect(container.read(timerControllerProvider).first.status, TimerStatus.paused);
    
    controller.startTimer(id);
    expect(container.read(timerControllerProvider).first.status, TimerStatus.running);
  });
}
