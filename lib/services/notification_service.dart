import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/models/TaskModel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone_2025/flutter_native_timezone_2025.dart';

class NotificationService {

  static Future<void> init()async {
    // 1. Initialize timezone data
    tz.initializeTimeZones();

    // 2. Get device local timezone
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // 3. Initialize the plugins
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(android: androidSettings);

    await FlutterLocalNotificationsPlugin().initialize(settings);

    await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> scheduleNotification(Taskmodel task)async {

    await FlutterLocalNotificationsPlugin().zonedSchedule(
        task.id.hashCode,
        task.title,
        task.subtitle ?? '',
        tz.TZDateTime.from(task.time, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'task_channel',
              'Task Reminders',
            importance: Importance.high,
            priority: Priority.high
          )
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }
}