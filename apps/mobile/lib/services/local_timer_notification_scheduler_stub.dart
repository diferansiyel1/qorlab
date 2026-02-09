import 'package:smart_timer/smart_timer.dart';

Future<TimerNotificationScheduler>
createLocalTimerNotificationScheduler() async {
  return const NoopTimerNotificationScheduler();
}
