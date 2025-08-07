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
  String _selectedDurationText = '';

  Future<void> _showDurationPicker() async {
    final Duration? result = await showDurationPicker(
      context: context,
      durationPickerMode: DurationPickerMode.hms,
    );
    if (result != null) {
      setState(() {
        _selectedDuration = result;
        _selectedDurationText =
            '${_selectedDuration!.hour}h ${_selectedDuration!.minute}m ${_selectedDuration!.second}s';
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Nom de votre timer',
                    labelText: 'Titre',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  spacing: 8.0,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showDurationPicker,
                      icon: Icon(Icons.timelapse),
                      label: Text('Durée'),
                    ),
                    Text(
                      _selectedDurationText.isEmpty
                          ? 'Pas de durée sélectionnée'
                          : _selectedDurationText,
                    ),
                  ],
                ),
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
