import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:timers_app/models/timer_card_model.dart';
import 'package:timers_app/widgets/new_timer_dialog.dart';
import 'package:timers_app/widgets/timer_card.dart';

Future<void> main() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const WindowsInitializationSettings initializationSettingsWindows =
      WindowsInitializationSettings(
        appName: 'Timer App',
        appUserModelId: 'Com.Lorobert.TimerApp',
        guid: '334d0c4a-60e3-41bb-b74a-63d259863969',
      );
  final InitializationSettings initializationSettings = InitializationSettings(
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TimerCardModel> _cards = [];

  void _addCardMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) => NewTimerDialog(onAddCard: addCard),
    );
  }

  void addCard(String title, Duration duration) {
    setState(() {
      _cards.add(TimerCardModel(_cards.length, title, duration));
    });
  }

  void deleteCard(int cardId) {
    setState(() {
      _cards.removeWhere((card) => card.id == cardId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Timer App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.outlined(
                  onPressed: _addCardMenu,
                  icon: Icon(Icons.add),
                ),
                Text('Nouveau timer'),
              ],
            ),
          ),
          Expanded(
            child: _cards.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) => TimerCard(
                      id: _cards[index].id,
                      title: _cards[index].title,
                      duration: _cards[index].duration,
                      onDeleteTimer: deleteCard,
                    ),
                  )
                : Center(child: Text('Pas de timer.')),
          ),
        ],
      ),
    );
  }
}
