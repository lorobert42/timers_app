import 'dart:async';
import 'dart:io';
import 'package:timers_app/utils/duration.dart';
import 'package:timers_app/utils/notifications.dart';

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
      await scheduleAndroidNotification(widget.id, widget.title, _remaining);
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
          await showWindowsNotification(widget.id, widget.title);
        }
      }
    });
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
          scheduleAndroidNotification(widget.id, widget.title, _remaining);
        }
      });
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timeKeeper?.cancel();
    flutterLocalNotificationsPlugin.cancel(widget.id);
    super.dispose();
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
