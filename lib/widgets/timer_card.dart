import 'dart:async';
import 'dart:typed_data';

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
    var split = _remaining.toString().split(':');
    var hours = widget.duration.inHours > 0 ? '${split[0]}:' : '';
    var minutes = widget.duration.inMinutes > 0 ? '${split[1]}:' : '';
    var seconds = _remaining.inMinutes > 9
        ? split[2].substring(0, 2)
        : _remaining.inSeconds >= 10
        ? split[2].substring(0, 4)
        : split[2].substring(1, 4);
    return '$hours$minutes$seconds';
  }

  String get _subtitleText {
    var split = widget.duration.toString().split(':');
    var hours = widget.duration.inHours > 0 ? '${split[0]} Heures ' : '';
    var minutes = widget.duration.inMinutes > 0 && split[1] != '00'
        ? '${split[1]} Minutes '
        : '';
    var seconds = split[2] == '00.000000'
        ? ''
        : widget.duration.inSeconds >= 10
        ? '${split[2].substring(0, 2)} Secondes'
        : '${split[2].substring(1, 2)} Secondes';
    return '$hours$minutes$seconds';
  }

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
  }

  void _startTimer() {
    if (_timer.isRunning || _timeKeeper != null) {
      return;
    }
    setState(() {
      _remaining = widget.duration;
      _timer.reset();
      _timer.start();
    });
    _timeKeeper = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      setState(() => _remaining = widget.duration - _timer.elapsed);
      if (_remaining <= Duration.zero) {
        timer.cancel();
        setState(() {
          _timeKeeper = null;
          _timer.stop();
        });
        await _showWindowsNotification();
      }
    });
  }

  @override
  void dispose() {
    _timeKeeper?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_timer.isRunning) {
      setState(() {
        _timer.stop();
      });
    } else if (_timeKeeper != null) {
      setState(() {
        _timer.start();
      });
    } else {
      _startTimer();
    }
  }

  Future<void> _showWindowsNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'Alarme',
          'Alarme',
          channelDescription: 'Alarme lorsqu\'un timer est terminé.',
          importance: Importance.max,
          priority: Priority.high,
          additionalFlags: Int32List.fromList(<int>[4]),
        );
    const WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails(
          scenario: WindowsNotificationScenario.alarm,
          actions: <WindowsAction>[
            WindowsAction(content: 'Button', arguments: 'button'),
          ],
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      windows: windowsNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      widget.id,
      widget.title,
      'Temps écoulé.',
      notificationDetails,
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
