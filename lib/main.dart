import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:timers_app/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalMaterialDurationPickerLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
