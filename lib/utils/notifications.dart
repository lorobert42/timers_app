import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotificationsPlugin() async {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestExactAlarmsPermission();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
        appName: 'Timer App',
        appUserModelId: 'Com.Lorobert.TimerApp',
        guid: '334d0c4a-60e3-41bb-b74a-63d259863969',
      );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    windows: initializationSettingsWindows,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showWindowsNotification(int id, String title) async {
  const WindowsNotificationDetails windowsNotificationDetails =
      WindowsNotificationDetails(scenario: WindowsNotificationScenario.alarm);
  NotificationDetails notificationDetails = NotificationDetails(
    windows: windowsNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    'Temps écoulé.',
    notificationDetails,
  );
}

Future<void> scheduleAndroidNotification(
  int id,
  String title,
  Duration duration,
) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'Alarme',
        'Alarme',
        channelDescription: 'Alarme lorsqu\'un timer est terminé.',
        importance: Importance.max,
        priority: Priority.high,
        additionalFlags: Int32List.fromList(<int>[4]),
      );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  final london = tz.getLocation('Europe/London');
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    'Temps écoulé.',
    tz.TZDateTime.now(london).add(duration),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
