import 'package:flutter/material.dart';
import 'package:timers_app/l10n/app_localizations.dart';

String getFormattedTimer(Duration remaining, Duration total) {
  var split = remaining.toString().split(':');
  var hours = total.inHours > 0 ? '${split[0]}:' : '';
  var minutes = total.inMinutes > 0 ? '${split[1]}:' : '';
  var seconds = remaining.inMinutes > 10
      ? split[2].substring(0, 2)
      : remaining.inSeconds >= 10
      ? split[2].substring(0, 4)
      : split[2].substring(1, 4);
  return '$hours$minutes$seconds';
}

String getTimerText(Duration duration, BuildContext context) {
  var (hours, minutes, seconds) = splitDuration(duration);
  var hoursText = '${AppLocalizations.of(context)!.nHours(hours)} ';
  var minutesText = minutes > 0 || hours > 0
      ? '${AppLocalizations.of(context)!.nMinutes(minutes)} '
      : '';
  var secondsText = AppLocalizations.of(context)!.nSeconds(seconds);
  return '$hoursText$minutesText$secondsText';
}

(int, int, int) splitDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = (duration - Duration(hours: hours)).inMinutes;
  int seconds = (duration - Duration(hours: hours) - Duration(minutes: minutes))
      .inSeconds;
  return (hours, minutes, seconds);
}
