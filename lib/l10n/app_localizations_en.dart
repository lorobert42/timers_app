// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Title';

  @override
  String get back => 'Back';

  @override
  String get add => 'Add';

  @override
  String get duration => 'Duration';

  @override
  String get addTimer => 'Add a timer';

  @override
  String get newTimer => 'New timer';

  @override
  String get timerName => 'New timer name';

  @override
  String get noDuration => 'No duration selected.';

  @override
  String timerDurationText(DateTime duration) {
    final intl.DateFormat durationDateFormat = intl.DateFormat.Hms(localeName);
    final String durationString = durationDateFormat.format(duration);

    return '$durationString';
  }

  @override
  String get alarm => 'Alarm';

  @override
  String get alarmNotification => 'Time is out.';

  @override
  String get channelDescription => 'Alarm when a timer is over.';

  @override
  String nHours(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Hours',
      one: '1 Hour',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String nMinutes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Minutes',
      one: '1 Minute',
      zero: '',
    );
    return '$_temp0';
  }

  @override
  String nSeconds(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Second',
      one: '1 Second',
    );
    return '$_temp0';
  }
}
