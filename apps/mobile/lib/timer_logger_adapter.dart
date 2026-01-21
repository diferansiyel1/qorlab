
import 'package:smart_timer/smart_timer.dart';
import 'package:experiment_log/experiment_log.dart';

class TimerLoggerAdapter implements TimerLogger {
  final ExperimentActionHandler _handler;

  TimerLoggerAdapter(this._handler);

  @override
  Future<void> logTimerFinished({required String label, required Duration duration}) async {
    await _handler.logNote(text: "Timer '$label' finished (${duration.inMinutes}m)");
  }
}
