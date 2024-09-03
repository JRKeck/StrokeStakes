class ScoreCalculation {
  final List<PlayerScore> playerScores;
  final double zookeeperBet;
  final double greeniesBet;
  final double wadBet;
  bool isFrontNine = true;
  WadOwner? frontNineWadOwner;
  WadOwner? backNineWadOwner;
  
  ScoreCalculation({
    required this.playerScores,
    required this.zookeeperBet,
    required this.greeniesBet,
    required this.wadBet,
    this.frontNineWadOwner,
    this.backNineWadOwner,
  });
}

class PlayerScore {
  final String name;
  final Map<String, int> frontNineScores = {
    'Snake': 0,
    'Camel': 0,
    'Frog': 0,
    'Gorilla': 0,
  };
  final Map<String, int> backNineScores = {
    'Snake': 0,
    'Camel': 0,
    'Frog': 0,
    'Gorilla': 0,
  };
  final List<GreenieScore> frontNineGreenies = [];
  final List<GreenieScore> backNineGreenies = [];

  PlayerScore({required this.name});

  int get frontNineTotal => frontNineScores.values.reduce((a, b) => a + b);
  int get backNineTotal => backNineScores.values.reduce((a, b) => a + b);
  int get totalScore => frontNineTotal + backNineTotal;
}

class GreenieScore {
  final String playerName;
  final GreenieResult result;

  GreenieScore({required this.playerName, required this.result});
}

enum GreenieResult {
  birdie,
  par,
  bogeyOrWorse,
}

class WadOwner {
  final String playerName;
  final int wadCount;

  WadOwner({required this.playerName, required this.wadCount});
}