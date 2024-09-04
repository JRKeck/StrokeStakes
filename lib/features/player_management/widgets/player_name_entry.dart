import 'package:flutter/material.dart';

// A stateful widget that allows the user to add, remove, and edit player names.
class PlayerNameEntry extends StatefulWidget {
  final int minPlayers; // Minimum number of players allowed
  final int maxPlayers; // Maximum number of players allowed
  final void Function(List<String>) onPlayersChanged; // Callback function to notify the parent widget of changes in player names

  const PlayerNameEntry({
    super.key,
    this.minPlayers = 2,
    this.maxPlayers = 6,
    required this.onPlayersChanged,
  });

  @override
  State<PlayerNameEntry> createState() => _PlayerNameEntryState();
}

// The state class for PlayerNameEntry
class _PlayerNameEntryState extends State<PlayerNameEntry> {
  late List<TextEditingController> _playerControllers; // List of controllers for player name input fields
  late List<FocusNode> _focusNodes; // List of FocusNodes for managing focus of each text field
  late ValueNotifier<List<String>> _playerNamesNotifier; // Notifier to keep track of the current list of player names

  @override
  void initState() {
    super.initState();
    // Initialize controllers and FocusNodes for the minimum number of players
    _playerControllers = List.generate(
      widget.minPlayers,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.minPlayers,
      (_) => FocusNode(),
    );

    // Initialize ValueNotifier with the initial list of player names (currently empty)
    _playerNamesNotifier = ValueNotifier<List<String>>(
      _playerControllers.map((c) => c.text).toList(),
    );

    // Add listeners to each controller to notify changes when the text is edited
    for (var controller in _playerControllers) {
      controller.addListener(_notifyPlayersChanged);
    }
  }

  // Method to add a new player field
  void _addPlayerField() {
    // Ensure that the number of player fields does not exceed the maximum allowed
    if (_playerControllers.length < widget.maxPlayers) {
      setState(() {
        // Add a new TextEditingController and FocusNode for the new player field
        final newController = TextEditingController();
        final newFocusNode = FocusNode();
        newController.addListener(_notifyPlayersChanged); // Listen to changes in the new controller
        _playerControllers.add(newController); // Add the new controller to the list
        _focusNodes.add(newFocusNode); // Add the new focus node to the list
      });

      // Request focus on the new field
      _focusNodes.last.requestFocus();
      _notifyPlayersChanged(); // Notify the parent widget of the change
    }
  }

  // Method to remove the last player field
  void _removePlayerField() {
    // Ensure that the number of player fields does not go below the minimum allowed
    if (_playerControllers.length > widget.minPlayers) {
      setState(() {
        // Remove the last player field and dispose of its controller and focus node
        _playerControllers.removeLast().dispose();
        _focusNodes.removeLast().dispose();
      });
      _notifyPlayersChanged(); // Notify the parent widget of the change
    }
  }

  // Method to notify the parent widget about the current list of player names
  void _notifyPlayersChanged() {
    // Update the ValueNotifier with the new list of player names
    _playerNamesNotifier.value = _playerControllers.map((c) => c.text).toList();
    // Invoke the callback function to update the parent with the new list of names
    widget.onPlayersChanged(_playerNamesNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use ValueListenableBuilder to only rebuild the widget when player names change
        ValueListenableBuilder<List<String>>(
          valueListenable: _playerNamesNotifier, // Listens to changes in the player names list
          builder: (context, playerNames, child) {
            return Column(
              children: [
                // Dynamically generate TextFormFields for each player
                ..._playerControllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Adds padding between the input fields
                    child: TextFormField(
                      controller: controller, // Binds the controller to the input field
                      focusNode: _focusNodes[idx], // Attach the corresponding FocusNode
                      textCapitalization: TextCapitalization.words, // Capitalizes the first letter of each word
                      decoration: InputDecoration(labelText: 'Player ${idx + 1} Name'), // Sets label text for the field
                      onChanged: (_) => _notifyPlayersChanged(), // Notify parent widget when text changes
                      validator: (value) {
                        // Validation to ensure each player name is not empty
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name for Player ${idx + 1}'; // Error message for empty fields
                        }
                        return null;
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Aligns the buttons evenly
          children: [
            ElevatedButton(
              onPressed: _playerControllers.length < widget.maxPlayers ? _addPlayerField : null, // Enable button only if under maxPlayers
              child: const Text('ADD PLAYER'), // Button to add a new player field
            ),
            const SizedBox(width: 10), // Adds horizontal space between the buttons
            ElevatedButton(
              onPressed: _playerControllers.length > widget.minPlayers ? _removePlayerField : null, // Enable button only if above minPlayers
              child: const Text('REMOVE PLAYER'), // Button to remove the last player field
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers and FocusNodes to free up resources
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _playerNamesNotifier.dispose(); // Dispose of the ValueNotifier
    super.dispose();
  }
}
