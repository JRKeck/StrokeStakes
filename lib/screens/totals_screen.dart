// screens/totals_screen.dart
import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart';
import '../features/score_calculation/widgets/player_score_card_widget.dart';
import '../features/payouts_card/widgets/payouts_card_widget.dart';

class TotalsScreen extends StatelessWidget {
  final ScoreCalculationService scoreCalculationService;

  const TotalsScreen({super.key, required this.scoreCalculationService});

  @override
  Widget build(BuildContext context) {
    final calculation = scoreCalculationService.currentCalculation;
    if (calculation == null) {
      return const Scaffold(
        body: Center(child: Text('No active calculation')),
      );
    }

    final totalPayouts = scoreCalculationService.calculateTotalPayouts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PayoutsCardWidget(payouts: totalPayouts),
          const SizedBox(height: 24),  // Add some extra space after the payouts
          const Text(
            'Individual Scores',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (var player in calculation.playerScores)
            PlayerScoreCardWidget(
              player: player,
              calculation: calculation,
            ),
        ],
      ),
    );
  }
}