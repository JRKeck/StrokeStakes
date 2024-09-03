import 'package:flutter/material.dart';

class PlayerNameEntry extends StatefulWidget {
  final int minPlayers;
  final int maxPlayers;
  final void Function(List<String>) onPlayersChanged;

  const PlayerNameEntry({
    super.key,
    this.minPlayers = 2,
    this.maxPlayers = 6,
    required this.onPlayersChanged,
  });

  @override
  State<PlayerNameEntry> createState() => _PlayerNameEntryState();
}

class _PlayerNameEntryState extends State<PlayerNameEntry> {
  late List<TextEditingController> _playerControllers;

  @override
  void initState() {
    super.initState();
    _playerControllers = List.generate(
      widget.minPlayers,
      (_) => TextEditingController(),
    );
  }

  void _addPlayerField() {
    if (_playerControllers.length < widget.maxPlayers) {
      setState(() {
        _playerControllers.add(TextEditingController());
      });
      _notifyPlayersChanged();
    }
  }

  void _removePlayerField() {
    if (_playerControllers.length > widget.minPlayers) {
      setState(() {
        _playerControllers.removeLast();
      });
      _notifyPlayersChanged();
    }
  }

  void _notifyPlayersChanged() {
    widget.onPlayersChanged(_playerControllers.map((c) => c.text).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._playerControllers.asMap().entries.map((entry) {
          int idx = entry.key;
          var controller = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Player ${idx + 1} Name'),
              onChanged: (_) => _notifyPlayersChanged(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for Player ${idx + 1}';
                }
                return null;
              },
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _playerControllers.length < widget.maxPlayers ? _addPlayerField : null,
              child: const Text('Add Player'),
            ),
            ElevatedButton(
              onPressed: _playerControllers.length > widget.minPlayers ? _removePlayerField : null,
              child: const Text('Remove Player'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}