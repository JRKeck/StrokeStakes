// features/score_calculation/widgets/player_score_card_widget.dart
import 'package:flutter/material.dart';
import '../models/score_calculation_model.dart';

class PlayerScoreCardWidget extends StatelessWidget {
  final PlayerScore player;
  final ScoreCalculation calculation;

  const PlayerScoreCardWidget({
    super.key,
    required this.player,
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(player.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildNineHoleScores('Front 9:', player.frontNineScores, player.frontNineGreenies, calculation.frontNineWadOwner, player.name),
            _buildNineHoleScores('Back 9:', player.backNineScores, player.backNineGreenies, calculation.backNineWadOwner, player.name),
            const SizedBox(height: 8),
            _buildTotals(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNineHoleScores(String title, Map<String, int> scores, List<GreenieScore> greenies, WadOwner? wadOwner, String playerName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...scores.entries
            .where((entry) => entry.value > 0)
            .map((entry) => Text('  ${entry.key}: ${entry.value}')),
        ...greenies.map((greenie) => Text('  Greenie: ${_getGreenieResultText(greenie.result)}')),
        if (wadOwner?.playerName == playerName)
          Text('  Wads: ${wadOwner!.wadCount}'),
      ],
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Totals:', style: Theme.of(context).textTheme.titleMedium),
        Text('Animals: ${player.totalScore}'),
        Text('Greenies: ${player.frontNineGreenies.length + player.backNineGreenies.length}'),
        Text('Wads: ${_calculateTotalWads()}'),
      ],
    );
  }

  String _getGreenieResultText(GreenieResult result) {
    switch (result) {
      case GreenieResult.birdie:
        return 'Birdie';
      case GreenieResult.par:
        return 'Par';
      case GreenieResult.bogeyOrWorse:
        return 'Bogey+';
    }
  }

  int _calculateTotalWads() {
    int totalWads = 0;
    if (calculation.frontNineWadOwner?.playerName == player.name) {
      totalWads += calculation.frontNineWadOwner!.wadCount;
    }
    if (calculation.backNineWadOwner?.playerName == player.name) {
      totalWads += calculation.backNineWadOwner!.wadCount;
    }
    return totalWads;
  }
}