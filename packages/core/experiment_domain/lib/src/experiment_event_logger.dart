import 'experiment_event.dart';

abstract class ExperimentEventLogger {
  Future<void> logEvent(ExperimentEvent event);
}

