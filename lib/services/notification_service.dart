import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/TaskModel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone_2025/flutter_native_timezone_2025.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  if (response.actionId == 'task') {
    String? taskID = response.payload;
    final prefs = await SharedPreferences.getInstance();
    final string = prefs.getStringList("key") ?? [];
    var task = string
        .map((string) => TaskModel.fromJson(jsonDecode(string)))
        .toList();
    final found = task.firstWhere((t) => t.id == taskID);
    final updated = found.copyWith(isCompleted: true);
    final save = task
        .map((t) => jsonEncode(t.id == taskID ? updated.toJson() : t.toJson()))
        .toList();
    await prefs.setStringList('key', save);
  }
}

class NotificationService {
  static Future<void> init() async {
    // 1. Initialize timezone data
    tz.initializeTimeZones();

    // 2. Get device local timezone
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // 3. Initialize the plugins
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await FlutterLocalNotificationsPlugin().initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleNotification(TaskModel task) async {
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      task.id.hashCode,
      task.title,
      task.subtitle ?? '',
      tz.TZDateTime.from(task.time, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          actions: [AndroidNotificationAction('task', 'Mark as Completed')],
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: task.id,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
