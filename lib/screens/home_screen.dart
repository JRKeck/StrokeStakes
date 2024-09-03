import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart';
import 'game_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  final ScoreCalculationService scoreCalculationService;

  const HomeScreen({super.key, required this.scoreCalculationService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Center(
                child: FlutterLogo(size: 100), // Placeholder for your app logo
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameSetupScreen(scoreCalculationService: scoreCalculationService)),
                      );
                    },
                    child: const Text('Game Calculator'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement rules/help functionality
                    },
                    child: const Text('Rules/Help'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}