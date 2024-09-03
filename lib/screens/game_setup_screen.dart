import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart';
import '../features/player_management/widgets/player_name_entry.dart';
import '../features/game_setup/widgets/bet_amount_inputs.dart';
import 'score_entry_screen.dart';

class GameSetupScreen extends StatefulWidget {
  final ScoreCalculationService scoreCalculationService;

  const GameSetupScreen({super.key, required this.scoreCalculationService});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _zookeeperBetController = TextEditingController(text: '1');
  final TextEditingController _greeniesBetController = TextEditingController(text: '5');
  final TextEditingController _wadBetController = TextEditingController(text: '5');
  final List<String> _players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            PlayerNameEntry(
              onPlayersChanged: (players) {
                setState(() {
                  _players.clear();
                  _players.addAll(players);
                });
              },
            ),
            const SizedBox(height: 20),
            BetAmountInputs(
              zookeeperController: _zookeeperBetController,
              greeniesController: _greeniesBetController,
              wadController: _wadBetController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _enterGameScores,
              child: const Text('Enter Game Scores'),
            ),
          ],
        ),
      ),
    );
  }

  void _enterGameScores() {
    if (_formKey.currentState!.validate()) {
      if (_players.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one player')),
        );
      } else {
        widget.scoreCalculationService.startNewCalculation(
          playerNames: _players,
          zookeeperBet: double.parse(_zookeeperBetController.text),
          greeniesBet: double.parse(_greeniesBetController.text),
          wadBet: double.parse(_wadBetController.text),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScoreEntryScreen(scoreCalculationService: widget.scoreCalculationService)),
        );
      }
    }
  }

  @override
  void dispose() {
    _zookeeperBetController.dispose();
    _greeniesBetController.dispose();
    _wadBetController.dispose();
    super.dispose();
  }
}