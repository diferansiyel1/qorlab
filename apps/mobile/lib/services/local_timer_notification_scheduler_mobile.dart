import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_timer/smart_timer.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const _timerChannelId = 'qorlab_timers_v1';
const _timerChannelName = 'QorLab Timers';
const _timerChannelDescription =
    'Timer completion alerts for active lab sessions.';

class LocalTimerNotificationScheduler implements TimerNotificationScheduler {
  LocalTimerNotificationScheduler(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);

    _initialized = true;
  }

  @override
  Future<void> scheduleCompletion({
    required String timerId,
    required String title,
    required Duration inDuration,
  }) async {
    if (inDuration <= Duration.zero) return;
    await initialize();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _timerChannelId,
        _timerChannelName,
        channelDescription: _timerChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        category: AndroidNotificationCategory.alarm,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      _notificationId(timerId),
      title,
      'Timer completed',
      tz.TZDateTime.now(tz.local).add(inDuration),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: timerId,
    );
  }

  @override
  Future<void> cancel(String timerId) async {
    await initialize();
    await _plugin.cancel(_notificationId(timerId));
  }

  int _notificationId(String timerId) {
    var hash = 2166136261;
    for (final unit in timerId.codeUnits) {
      hash ^= unit;
      hash *= 16777619;
    }
    return hash & 0x7fffffff;
  }
}

Future<TimerNotificationScheduler>
createLocalTimerNotificationScheduler() async {
  try {
    final scheduler = LocalTimerNotificationScheduler(
      FlutterLocalNotificationsPlugin(),
    );
    await scheduler.initialize();
    return scheduler;
  } catch (_) {
    return const NoopTimerNotificationScheduler();
  }
}
