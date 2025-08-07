import 'package:flutter/material.dart';
import 'package:material_duration_picker/material_duration_picker.dart';

class NewTimerPage extends StatefulWidget {
  final Function onAddCard;

  const NewTimerPage({super.key, required this.onAddCard});

  @override
  State<NewTimerPage> createState() => _NewTimerPageState();
}

class _NewTimerPageState extends State<NewTimerPage> {
  final titleController = TextEditingController();
  Duration? _selectedDuration;

  Future<void> _showDurationPicker() async {
    final Duration? result = await showDurationPicker(
      context: context,
      durationPickerMode: DurationPickerMode.hms,
    );
    if (result != null) {
      setState(() {
        _selectedDuration = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Ajouter un timer'),
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Titre'),
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showDurationPicker,
                    icon: Icon(Icons.timelapse),
                    label: Text('Durée'),
                  ),
                  Text(
                    _selectedDuration != null
                        ? _selectedDuration!.toString()
                        : 'Pas de durée sélectionnée',
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Retour'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          _selectedDuration == null) {
                        return;
                      }
                      widget.onAddCard(titleController.text, _selectedDuration);
                      Navigator.pop(context);
                    },
                    child: Text('Ajouter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
