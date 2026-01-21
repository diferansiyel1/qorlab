import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_timer/src/domain/timer_entry.dart';


final timerControllerProvider = StateNotifierProvider<TimerController, List<TimerEntry>>((ref) {
  return TimerController();
});

class TimerController extends StateNotifier<List<TimerEntry>> {
  Timer? _ticker;

  TimerController() : super([]);

  void addTimer(String label, Duration duration) {
    final newTimer = TimerEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      duration: duration,
      remaining: duration,
      status: TimerStatus.idle,
    );
    state = [...state, newTimer];
  }

  void startTimer(String id) {
    state = [
      for (final timer in state)
        if (timer.id == id) timer.copyWith(status: TimerStatus.running) else timer
    ];
    _startTicker();
  }

  void pauseTimer(String id) {
    state = [
      for (final timer in state)
        if (timer.id == id) timer.copyWith(status: TimerStatus.paused) else timer
    ];
    _checkTicker();
  }

  void stopTimer(String id) {
     state = [
      for (final timer in state)
        if (timer.id == id) 
          timer.copyWith(status: TimerStatus.idle, remaining: timer.duration) 
        else timer
    ];
    _checkTicker();
  }

  void removeTimer(String id) {
    state = state.where((t) => t.id != id).toList();
    _checkTicker();
  }

  void _startTicker() {
    if (_ticker != null && _ticker!.isActive) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool anyRunning = false;
      state = [
        for (final t in state)
          if (t.status == TimerStatus.running)
            if (t.remaining.inSeconds > 0)
              () {
                anyRunning = true;
                return t.copyWith(remaining: t.remaining - const Duration(seconds: 1));
              }()
            else
              t.copyWith(status: TimerStatus.completed, remaining: Duration.zero)
          else
            t
      ];
      if (!anyRunning) {
        _ticker?.cancel();
      }
    });
  }

  void _checkTicker() {
    final anyRunning = state.any((t) => t.status == TimerStatus.running);
    if (!anyRunning) {
      _ticker?.cancel();
    } else {
      _startTicker();
    }
  }
  
  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
