import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:timers_app/utils/duration.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimerCard extends StatefulWidget {
  final int id;
  final String title;
  final Duration duration;
  final Function onDeleteTimer;

  const TimerCard({
    super.key,
    required this.id,
    required this.title,
    required this.duration,
    required this.onDeleteTimer,
  });

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  final _timer = Stopwatch();
  Timer? _timeKeeper;
  Duration _remaining = Duration.zero;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String get _timerText {
    if (_remaining < Duration.zero) {
      setState(() => _remaining = Duration.zero);
    }
    return getFormattedTimer(_remaining, widget.duration);
  }

  String get _subtitleText {
    return getTimerText(widget.duration);
  }

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
  }

  Future<void> _startTimer() async {
    if (_timer.isRunning || _timeKeeper != null) {
      return;
    }
    setState(() {
      _remaining = widget.duration;
      _timer.reset();
      _timer.start();
    });
    if (Platform.isAndroid) {
      await _scheduleAndroidNotification();
    }
    _timeKeeper = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      setState(() => _remaining = widget.duration - _timer.elapsed);
      if (_remaining <= Duration.zero) {
        timer.cancel();
        setState(() {
          _timeKeeper = null;
          _timer.stop();
        });
        if (Platform.isWindows) {
          await _showWindowsNotification();
        }
      }
    });
  }

  @override
  void dispose() {
    _timeKeeper?.cancel();
    flutterLocalNotificationsPlugin.cancel(widget.id);
    super.dispose();
  }

  void _toggleTimer() {
    if (_timer.isRunning) {
      setState(() {
        _timer.stop();
        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin.cancel(widget.id);
        }
      });
    } else if (_timeKeeper != null) {
      setState(() {
        _timer.start();
        if (Platform.isAndroid) {
          _scheduleAndroidNotification();
        }
      });
    } else {
      _startTimer();
    }
  }

  Future<void> _showWindowsNotification() async {
    const WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails(scenario: WindowsNotificationScenario.alarm);
    NotificationDetails notificationDetails = NotificationDetails(
      windows: windowsNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      widget.id,
      widget.title,
      'Temps écoulé.',
      notificationDetails,
    );
  }

  Future<void> _scheduleAndroidNotification() async {
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
      widget.id,
      widget.title,
      'Temps écoulé.',
      tz.TZDateTime.now(london).add(_remaining),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ListTile(
              leading: Icon(Icons.timer),
              title: Text(widget.title),
              subtitle: Text(_subtitleText),
            ),
          ),
          Spacer(),
          Text(_timerText, style: Theme.of(context).textTheme.displaySmall),
          // Text(_timer.elapsed.toString()),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _timer.stop();
                          flutterLocalNotificationsPlugin.cancel(widget.id);
                          _timer.reset();
                          _remaining = widget.duration;
                        });
                      },
                      icon: Icon(Icons.restart_alt),
                    ),
                    IconButton(
                      onPressed: () {
                        _toggleTimer();
                      },
                      icon: Icon(
                        _timer.isRunning ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    widget.onDeleteTimer(widget.id);
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
