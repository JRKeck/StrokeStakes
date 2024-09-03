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

    final currentNineScores = _currentCalculation!.isFrontNine
        ? _currentCalculation!.playerScores.map((p) => p.frontNineScores)
        : _currentCalculation!.playerScores.map((p) => p.backNineScores);

    // Remove the animal from all players
    for (var scores in currentNineScores) {
      scores[animal] = 0;
    }

    // Assign the animal to the selected player
    final playerScore = _currentCalculation!.playerScores.firstWhere((p) => p.name == playerName);
    if (_currentCalculation!.isFrontNine) {
      playerScore.frontNineScores[animal] = score;
    } else {
      playerScore.backNineScores[animal] = score;
    }
  }

  int? getScore(String playerName, String animal) {
    final playerScore = _currentCalculation?.playerScores.firstWhere((p) => p.name == playerName);
    if (playerScore != null) {
      if (_currentCalculation!.isFrontNine) {
        return playerScore.frontNineScores[animal];
      } else {
        return playerScore.backNineScores[animal];
      }
    }
    return null;
  }

  List<GreenieScore> getGreenies(bool isFrontNine) {
    if (_currentCalculation == null) return [];
    return _currentCalculation!.playerScores
        .expand((player) => isFrontNine ? player.frontNineGreenies : player.backNineGreenies)
        .toList();
  }

  void updateGreenie(bool isFrontNine, GreenieScore newGreenie, GreenieScore? existingGreenie) {
    if (_currentCalculation == null) return;

    final playerScore = _currentCalculation!.playerScores.firstWhere((p) => p.name == newGreenie.playerName);
    final greenies = isFrontNine ? playerScore.frontNineGreenies : playerScore.backNineGreenies;

    if (existingGreenie != null) {
      final index = greenies.indexWhere((g) => g.playerName == existingGreenie.playerName);
      if (index != -1) {
        greenies[index] = newGreenie;
      }
    } else {
      greenies.add(newGreenie);
    }
  }

  void removeGreenie(bool isFrontNine, GreenieScore greenie) {
    if (_currentCalculation == null) return;

    final playerScore = _currentCalculation!.playerScores.firstWhere((p) => p.name == greenie.playerName);
    final greenies = isFrontNine ? playerScore.frontNineGreenies : playerScore.backNineGreenies;
    greenies.removeWhere((g) => g.playerName == greenie.playerName);
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

  WadOwner? getWadOwner(bool isFrontNine) {
    if (_currentCalculation == null) return null;
    return isFrontNine ? _currentCalculation!.frontNineWadOwner : _currentCalculation!.backNineWadOwner;
  }

  void switchToBackNine() {
    if (_currentCalculation != null) {
      _currentCalculation!.isFrontNine = false;
    }
  }

  void switchToFrontNine() {
    if (_currentCalculation != null) {
      _currentCalculation!.isFrontNine = true;
    }
  }

  Map<String, double> calculateGreeniePayouts() {
    if (_currentCalculation == null) return {};

    final payouts = <String, double>{};
    for (var player in _currentCalculation!.playerScores) {
      payouts[player.name] = 0;
    }

    void processGreenies(List<GreenieScore> greenies) {
      for (var greenie in greenies) {
        switch (greenie.result) {
          case GreenieResult.birdie:
            for (var player in _currentCalculation!.playerScores) {
              if (player.name != greenie.playerName) {
                payouts[player.name] = (payouts[player.name] ?? 0) - (_currentCalculation!.greeniesBet * 2);
                payouts[greenie.playerName] = (payouts[greenie.playerName] ?? 0) + (_currentCalculation!.greeniesBet * 2);
              }
            }
            break;
          case GreenieResult.par:
            for (var player in _currentCalculation!.playerScores) {
              if (player.name != greenie.playerName) {
                payouts[player.name] = (payouts[player.name] ?? 0) - _currentCalculation!.greeniesBet;
                payouts[greenie.playerName] = (payouts[greenie.playerName] ?? 0) + _currentCalculation!.greeniesBet;
              }
            }
            break;
          case GreenieResult.bogeyOrWorse:
            for (var player in _currentCalculation!.playerScores) {
              if (player.name != greenie.playerName) {
                payouts[player.name] = (payouts[player.name] ?? 0) + _currentCalculation!.greeniesBet;
                payouts[greenie.playerName] = (payouts[greenie.playerName] ?? 0) - _currentCalculation!.greeniesBet;
              }
            }
            break;
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

    final payouts = <String, double>{};
    for (var player in _currentCalculation!.playerScores) {
      payouts[player.name] = 0;
    }

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

  void endCalculation() {
    _currentCalculation = null;
  }
}