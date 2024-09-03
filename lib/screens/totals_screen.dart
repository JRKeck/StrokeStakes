import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart';
import '../features/score_calculation/models/score_calculation_model.dart';

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

    final animalPayouts = _calculateAnimalPayouts(calculation.playerScores, calculation.zookeeperBet);
    final greeniePayouts = scoreCalculationService.calculateGreeniePayouts();
    final wadPayouts = scoreCalculationService.calculateWadPayouts();
    final totalPayouts = _combinedPayouts([animalPayouts, greeniePayouts, wadPayouts]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var player in calculation.playerScores)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(player.name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    const Text('Front 9:'),
                    ..._buildAnimalList(player.frontNineScores),
                    ..._buildGreenieList(player.frontNineGreenies),
                    if (calculation.frontNineWadOwner?.playerName == player.name)
                      Text('  Wads: ${calculation.frontNineWadOwner!.wadCount}'),
                    const Text('Back 9:'),
                    ..._buildAnimalList(player.backNineScores),
                    ..._buildGreenieList(player.backNineGreenies),
                    if (calculation.backNineWadOwner?.playerName == player.name)
                      Text('  Wads: ${calculation.backNineWadOwner!.wadCount}'),
                    const SizedBox(height: 8),
                    Text('Total Animals: ${player.totalScore}', style: Theme.of(context).textTheme.titleMedium),
                    Text('Total Greenies: ${player.frontNineGreenies.length + player.backNineGreenies.length}', style: Theme.of(context).textTheme.titleMedium),
                    Text('Total Wads: ${_calculateTotalWads(calculation, player.name)}', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payouts', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  for (var entry in totalPayouts.entries)
                    Text('${entry.key}: ${entry.value >= 0 ? '+' : ''}\$${entry.value.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimalList(Map<String, int> scores) {
    return scores.entries
        .where((entry) => entry.value > 0)
        .map((entry) => Text('  ${entry.key}: ${entry.value}'))
        .toList();
  }

  List<Widget> _buildGreenieList(List<GreenieScore> greenies) {
    return greenies.map((greenie) => Text('  Greenie: ${_getGreenieResultText(greenie.result)}')).toList();
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

  int _calculateTotalWads(ScoreCalculation calculation, String playerName) {
    int totalWads = 0;
    if (calculation.frontNineWadOwner?.playerName == playerName) {
      totalWads += calculation.frontNineWadOwner!.wadCount;
    }
    if (calculation.backNineWadOwner?.playerName == playerName) {
      totalWads += calculation.backNineWadOwner!.wadCount;
    }
    return totalWads;
  }

  Map<String, double> _calculateAnimalPayouts(List<PlayerScore> players, double betAmount) {
    if (players.isEmpty) return {};

    final payouts = <String, double>{};
    for (var player in players) {
      payouts[player.name] = 0;
    }

    // Check for Zookeeper in Front 9
    final frontNineZookeeper = _checkForZookeeper(players, true);
    if (frontNineZookeeper != null) {
      _applyZookeeperRule(payouts, players, frontNineZookeeper, betAmount, true);
    } else {
      _calculateRegularPayouts(payouts, players, betAmount, true);
    }

    // Check for Zookeeper in Back 9
    final backNineZookeeper = _checkForZookeeper(players, false);
    if (backNineZookeeper != null) {
      _applyZookeeperRule(payouts, players, backNineZookeeper, betAmount, false);
    } else {
      _calculateRegularPayouts(payouts, players, betAmount, false);
    }

    return payouts;
  }

  PlayerScore? _checkForZookeeper(List<PlayerScore> players, bool isFrontNine) {
    for (var player in players) {
      final scores = isFrontNine ? player.frontNineScores : player.backNineScores;
      if (scores.values.every((score) => score > 0)) {
        return player;
      }
    }
    return null;
  }

  void _applyZookeeperRule(Map<String, double> payouts, List<PlayerScore> players, PlayerScore zookeeper, double betAmount, bool isFrontNine) {
    final totalAnimals = players.fold(0, (sum, player) => sum + (isFrontNine ? player.frontNineTotal : player.backNineTotal));
    final payoutPerPlayer = totalAnimals * betAmount;
    
    for (var player in players) {
      if (player != zookeeper) {
        payouts[player.name] = (payouts[player.name] ?? 0) - payoutPerPlayer;
        payouts[zookeeper.name] = (payouts[zookeeper.name] ?? 0) + payoutPerPlayer;
      }
    }
  }

  void _calculateRegularPayouts(Map<String, double> payouts, List<PlayerScore> players, double betAmount, bool isFrontNine) {
    for (var i = 0; i < players.length; i++) {
      for (var j = i + 1; j < players.length; j++) {
        var scoreDiff = (isFrontNine ? players[i].frontNineTotal : players[i].backNineTotal) - 
                        (isFrontNine ? players[j].frontNineTotal : players[j].backNineTotal);
        if (scoreDiff != 0) {
          var amount = scoreDiff.abs() * betAmount;
          if (scoreDiff > 0) {
            payouts[players[i].name] = (payouts[players[i].name] ?? 0) - amount;
            payouts[players[j].name] = (payouts[players[j].name] ?? 0) + amount;
          } else {
            payouts[players[i].name] = (payouts[players[i].name] ?? 0) + amount;
            payouts[players[j].name] = (payouts[players[j].name] ?? 0) - amount;
          }
        }
      }
    }
  }

  Map<String, double> _combinedPayouts(List<Map<String, double>> payoutsList) {
    final combinedPayouts = <String, double>{};
    
    for (var payouts in payoutsList) {
      for (var entry in payouts.entries) {
        combinedPayouts[entry.key] = (combinedPayouts[entry.key] ?? 0) + entry.value;
      }
    }

    return combinedPayouts;
  }
}