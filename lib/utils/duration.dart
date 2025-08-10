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

String getTimerText(Duration duration) {
  var split = duration.toString().split(':');
  var hours = duration.inHours > 0 ? '${split[0]} Heures ' : '';
  var minutes = duration.inMinutes > 0 && split[1] != '00'
      ? '${split[1]} Minutes '
      : '';
  var seconds = split[2] == '00.000000'
      ? ''
      : duration.inSeconds >= 10
      ? '${split[2].substring(0, 2)} Secondes'
      : '${split[2].substring(1, 2)} Secondes';
  return '$hours$minutes$seconds';
}
