// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get title => 'Titre';

  @override
  String get back => 'Retour';

  @override
  String get add => 'Ajouter';

  @override
  String get duration => 'Durée';

  @override
  String get addTimer => 'Ajouter un timer';

  @override
  String get newTimer => 'Nouveau timer';

  @override
  String get timerName => 'Nom du nouveau timer';

  @override
  String get noDuration => 'Pas de durée sélectionnée.';

  @override
  String timerDurationText(DateTime duration) {
    final intl.DateFormat durationDateFormat = intl.DateFormat.Hms(localeName);
    final String durationString = durationDateFormat.format(duration);

    return '$durationString';
  }

  @override
  String get alarm => 'Alarme';

  @override
  String get alarmNotification => 'Temps écoulé.';

  @override
  String get channelDescription => 'Alarme lorsqu\'un timer est terminé.';

  @override
  String nHours(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Heures',
      one: '1 Heure',
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
      other: '$countString Secondes',
      one: '1 Seconde',
      zero: '0 Seconde',
    );
    return '$_temp0';
  }
}
