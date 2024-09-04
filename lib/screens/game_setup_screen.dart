// Importing necessary Flutter packages and widgets/services
import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart'; // Service for score calculation
import '../features/player_management/widgets/player_name_entry.dart'; // Widget for player name entry
import '../features/game_setup/widgets/bet_amount_inputs.dart'; // Widget for bet amount inputs
import 'score_entry_screen.dart'; // Screen for entering game scores

// GameSetupScreen is a stateful widget that allows the user to set up a game
class GameSetupScreen extends StatefulWidget {
  final ScoreCalculationService scoreCalculationService; // Service to manage score calculations

  const GameSetupScreen({super.key, required this.scoreCalculationService});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

// State class for GameSetupScreen
class _GameSetupScreenState extends State<GameSetupScreen> {
  final _formKey = GlobalKey<FormState>(); // Key to uniquely identify and validate the form
  final TextEditingController _zookeeperBetController = TextEditingController(text: '1'); // Controller for zookeeper bet input
  final TextEditingController _greeniesBetController = TextEditingController(text: '5'); // Controller for greenies bet input
  final TextEditingController _wadBetController = TextEditingController(text: '5'); // Controller for wad bet input
  final List<String> _players = []; // List to store player names

  @override
  Widget build(BuildContext context) {
    // Builds the UI using a Scaffold widget with an AppBar and Form
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'), // Title of the AppBar
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0), // Padding around the ListView
          children: [
            // Widget for entering player names
            PlayerNameEntry(
              onPlayersChanged: (players) {
                setState(() {
                  _players.clear();
                  _players.addAll(players); // Updates the player list whenever changes occur
                });
              },
            ),
            const SizedBox(height: 20), // Spacer
            // Widget for entering bet amounts
            BetAmountInputs(
              zookeeperController: _zookeeperBetController,
              greeniesController: _greeniesBetController,
              wadController: _wadBetController,
            ),
            const SizedBox(height: 20), // Spacer
            ElevatedButton(
              onPressed: _enterGameScores, // Calls _enterGameScores when pressed
              child: const Text('ENTER GAME SCORES'), // Button label
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle entering game scores
  void _enterGameScores() {
    // Validates the form and checks if the player list is not empty
    if (_formKey.currentState!.validate()) {
      if (_players.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one player')), // Error message if no players are added
        );
      } else {
        // Calls the score calculation service to start a new game calculation
        widget.scoreCalculationService.startNewCalculation(
          playerNames: _players,
          zookeeperBet: double.parse(_zookeeperBetController.text),
          greeniesBet: double.parse(_greeniesBetController.text),
          wadBet: double.parse(_wadBetController.text),
        );
        // Navigates to the score entry screen, replacing the current screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ScoreEntryScreen(scoreCalculationService: widget.scoreCalculationService),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Disposes of the controllers when the widget is removed from the widget tree
    _zookeeperBetController.dispose();
    _greeniesBetController.dispose();
    _wadBetController.dispose();
    super.dispose();
  }
}
