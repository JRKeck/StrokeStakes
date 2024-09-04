import '../models/score_calculation_model.dart';

class ScoreCalculationService {
  ScoreCalculation? _currentCalculation;

  ScoreCalculation? get currentCalculation => _currentCalculation;

  void startNewCalculation({
    required List<String> playerNames,
    required double zookeeperBet,
    required double greeniesBet,
    required double wadBet,
  }) {
    final playerScores = playerNames.map((name) => PlayerScore(name: name)).toList();
    _currentCalculation = ScoreCalculation(
      playerScores: playerScores,
      zookeeperBet: zookeeperBet,
      greeniesBet: greeniesBet,
      wadBet: wadBet,
    );
  }

  void updateScore(String playerName, String animal, int score) {
    if (_currentCalculation == null) return;

    _removeAnimalFromAllPlayers(animal);
    _assignAnimalToPlayer(playerName, animal, score);
  }

  int? getScore(String playerName, String animal) {
    final playerScore = _currentCalculation?.playerScores.firstWhere((p) => p.name == playerName);
    return _currentCalculation?.isFrontNine ?? true
        ? playerScore?.frontNineScores[animal]
        : playerScore?.backNineScores[animal];
  }

  List<GreenieScore> getGreenies(bool isFrontNine) {
    return _currentCalculation?.playerScores
            .expand((player) => isFrontNine ? player.frontNineGreenies : player.backNineGreenies)
            .toList() ??
        [];
  }

  void updateGreenie(bool isFrontNine, GreenieScore newGreenie, GreenieScore? existingGreenie) {
    if (_currentCalculation == null) return;

    final greenies = _getPlayerGreenies(newGreenie.playerName, isFrontNine);
    if (existingGreenie != null) {
      final index = greenies.indexWhere((g) => g.playerName == existingGreenie.playerName);
      if (index != -1) greenies[index] = newGreenie;
    } else {
      greenies.add(newGreenie);
    }
  }

  void removeGreenie(bool isFrontNine, GreenieScore greenie) {
    _getPlayerGreenies(greenie.playerName, isFrontNine).removeWhere((g) => g.playerName == greenie.playerName);
  }

  void updateWad(bool isFrontNine, String playerName, int wadCount) {
    if (_currentCalculation == null) return;
    final newWadOwner = WadOwner(playerName: playerName, wadCount: wadCount);
    if (isFrontNine) {
      _currentCalculation!.frontNineWadOwner = newWadOwner;
    } else {
      _currentCalculation!.backNineWadOwner = newWadOwner;
    }
  }

  WadOwner? getWadOwner(bool isFrontNine) => 
      isFrontNine ? _currentCalculation?.frontNineWadOwner : _currentCalculation?.backNineWadOwner;

  void switchToBackNine() => _currentCalculation?.isFrontNine = false;

  void switchToFrontNine() => _currentCalculation?.isFrontNine = true;

  Map<String, double> calculateGreeniePayouts() {
    final payouts = _initializePayouts();
    if (_currentCalculation == null) return payouts;

    void processGreenies(List<GreenieScore> greenies) {
      for (var greenie in greenies) {
        for (var player in _currentCalculation!.playerScores) {
          if (player.name != greenie.playerName) {
            final payoutAdjustment = greenie.result == GreenieResult.birdie
                ? _currentCalculation!.greeniesBet * 2
                : greenie.result == GreenieResult.par
                    ? _currentCalculation!.greeniesBet
                    : -_currentCalculation!.greeniesBet;
            payouts[player.name] = (payouts[player.name] ?? 0) - payoutAdjustment;
            payouts[greenie.playerName] = (payouts[greenie.playerName] ?? 0) + payoutAdjustment;
          }
        }
      }
    }

    for (var player in _currentCalculation!.playerScores) {
      processGreenies(player.frontNineGreenies);
      processGreenies(player.backNineGreenies);
    }

    return payouts;
  }

  Map<String, double> calculateWadPayouts() {
    if (_currentCalculation == null) return {};

    final payouts = _initializePayouts();

    void processWad(WadOwner? wadOwner) {
      if (wadOwner != null) {
        double payout = wadOwner.wadCount * _currentCalculation!.wadBet * (_currentCalculation!.playerScores.length - 1);
        payouts[wadOwner.playerName] = (payouts[wadOwner.playerName] ?? 0) + payout;
        for (var player in _currentCalculation!.playerScores) {
          if (player.name != wadOwner.playerName) {
            payouts[player.name] = (payouts[player.name] ?? 0) - (_currentCalculation!.wadBet * wadOwner.wadCount);
          }
        }
      }
    }

    processWad(_currentCalculation!.frontNineWadOwner);
    processWad(_currentCalculation!.backNineWadOwner);

    return payouts;
  }

  Map<String, double> calculateTotalPayouts() {
    if (_currentCalculation == null) return {};

    final animalPayouts = _calculateAnimalPayouts();
    final greeniePayouts = calculateGreeniePayouts();
    final wadPayouts = calculateWadPayouts();

    final totalPayouts = <String, double>{};
    for (var player in _currentCalculation!.playerScores) {
      totalPayouts[player.name] = (animalPayouts[player.name] ?? 0) +
          (greeniePayouts[player.name] ?? 0) +
          (wadPayouts[player.name] ?? 0);
    }

    return totalPayouts;
  }

  Map<String, double> _calculateAnimalPayouts() {
  if (_currentCalculation == null) return {};

  final payouts = _initializePayouts();

  void processNine(bool isFrontNine) {
    // Check ownership of each type of animal for all players
    final animalTypes = ['Camel', 'Gorilla', 'Frog', 'Snake'];
    final playersWithAllAnimals = _currentCalculation!.playerScores.where((player) {
      final animalOwnership = animalTypes.every((animal) {
        final count = isFrontNine ? player.frontNineScores[animal] : player.backNineScores[animal];
        return count != null && count > 0;
      });
      return animalOwnership;
    }).toList();

    // Determine if there is a Zookeeper
    if (playersWithAllAnimals.length == 1) {
      // Only one player owns all four types of animals
      final zookeeperName = playersWithAllAnimals.first.name;
      final totalAnimals = _currentCalculation!.playerScores.fold<int>(0, (sum, player) {
        final frontNineCount = player.frontNineScores.values.fold(0, (a, b) => a + b);
        final backNineCount = player.backNineScores.values.fold(0, (a, b) => a + b);
        return sum + (isFrontNine ? frontNineCount : backNineCount);
      });

      for (var player in _currentCalculation!.playerScores) {
        if (player.name != zookeeperName) {
          payouts[player.name] = (payouts[player.name] ?? 0) - totalAnimals * _currentCalculation!.zookeeperBet;
          payouts[zookeeperName] = (payouts[zookeeperName] ?? 0) + totalAnimals * _currentCalculation!.zookeeperBet;
        }
      }
    } else {
      // No Zookeeper, calculate payouts normally
      final scores = _currentCalculation!.playerScores.map((p) => isFrontNine ? p.frontNineTotal : p.backNineTotal).toList();
      for (var i = 0; i < _currentCalculation!.playerScores.length; i++) {
        for (var j = i + 1; j < _currentCalculation!.playerScores.length; j++) {
          final scoreDiff = scores[i] - scores[j];
          if (scoreDiff != 0) {
            final amount = scoreDiff.abs() * _currentCalculation!.zookeeperBet;
            final playerI = _currentCalculation!.playerScores[i].name;
            final playerJ = _currentCalculation!.playerScores[j].name;
            if (scoreDiff > 0) {
              payouts[playerI] = (payouts[playerI] ?? 0) - amount;
              payouts[playerJ] = (payouts[playerJ] ?? 0) + amount;
            } else {
              payouts[playerI] = (payouts[playerI] ?? 0) + amount;
              payouts[playerJ] = (payouts[playerJ] ?? 0) - amount;
            }
          }
        }
      }
    }
  }

  processNine(true);  // Front nine
  processNine(false);  // Back nine

  return payouts;
}

  // Helper functions to keep the main logic clean
  void _removeAnimalFromAllPlayers(String animal) {
    final currentNineScores = _currentCalculation!.isFrontNine
        ? _currentCalculation!.playerScores.map((p) => p.frontNineScores)
        : _currentCalculation!.playerScores.map((p) => p.backNineScores);

    for (var scores in currentNineScores) {
      scores[animal] = 0;
    }
  }

  void _assignAnimalToPlayer(String playerName, String animal, int score) {
    final playerScore = _currentCalculation!.playerScores.firstWhere((p) => p.name == playerName);
    if (_currentCalculation!.isFrontNine) {
      playerScore.frontNineScores[animal] = score;
    } else {
      playerScore.backNineScores[animal] = score;
    }
  }

  List<GreenieScore> _getPlayerGreenies(String playerName, bool isFrontNine) {
    final playerScore = _currentCalculation!.playerScores.firstWhere((p) => p.name == playerName);
    return isFrontNine ? playerScore.frontNineGreenies : playerScore.backNineGreenies;
  }

  Map<String, double> _initializePayouts() {
    final payouts = <String, double>{};
    for (var player in _currentCalculation?.playerScores ?? []) {
      payouts[player.name] = 0;
    }
    return payouts;
  }

  void endCalculation() => _currentCalculation = null;
}
