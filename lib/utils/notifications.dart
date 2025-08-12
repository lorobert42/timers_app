import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timers_app/l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsGlobals {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
}

Future<void> initNotificationsPlugin() async {
  NotificationsGlobals.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  NotificationsGlobals.flutterLocalNotificationsPlugin
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
  await NotificationsGlobals.flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> showWindowsNotification(
  int id,
  String title,
  BuildContext context,
) async {
  const WindowsNotificationDetails windowsNotificationDetails =
      WindowsNotificationDetails(scenario: WindowsNotificationScenario.alarm);
  NotificationDetails notificationDetails = NotificationDetails(
    windows: windowsNotificationDetails,
  );

  await NotificationsGlobals.flutterLocalNotificationsPlugin.show(
    id,
    title,
    AppLocalizations.of(context)!.alarmNotification,
    notificationDetails,
  );
}

Future<void> scheduleAndroidNotification(
  int id,
  String title,
  Duration duration,
  BuildContext context,
) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        AppLocalizations.of(context)!.alarm,
        AppLocalizations.of(context)!.alarm,
        channelDescription: AppLocalizations.of(context)!.channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        additionalFlags: Int32List.fromList(<int>[4]),
      );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  final london = tz.getLocation('Europe/London');
  await NotificationsGlobals.flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    AppLocalizations.of(context)!.alarmNotification,
    tz.TZDateTime.now(london).add(duration),
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
