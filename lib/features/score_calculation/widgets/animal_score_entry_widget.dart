import 'package:flutter/material.dart';
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';

class AnimalScoreEntryWidget extends StatefulWidget {
  final String animalName;
  final List<PlayerScore> playerScores;
  final bool isFrontNine;
  final ScoreCalculationService scoreCalculationService;
  final VoidCallback onScoreUpdated;

  const AnimalScoreEntryWidget({
    super.key,
    required this.animalName,
    required this.playerScores,
    required this.isFrontNine,
    required this.scoreCalculationService,
    required this.onScoreUpdated,
  });

  @override
  State<AnimalScoreEntryWidget> createState() => _AnimalScoreEntryWidgetState();
}

class _AnimalScoreEntryWidgetState extends State<AnimalScoreEntryWidget> {
  String? displayPlayerName;
  int? displayScore;

  @override
  void initState() {
    super.initState();
    _updateDisplayScore();
  }

  @override
  void didUpdateWidget(AnimalScoreEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFrontNine != widget.isFrontNine) {
      _updateDisplayScore();
    }
  }

  void _updateDisplayScore() {
    displayPlayerName = null;
    displayScore = null;
    for (var player in widget.playerScores) {
      int? score = widget.scoreCalculationService.getScore(player.name, widget.animalName);
      if (score != null && score > 0) {
        displayPlayerName = player.name;
        displayScore = score;
        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.animalName, style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                if (displayPlayerName != null && displayScore != null)
                  Text('$displayPlayerName: $displayScore'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showScoreInputDialog,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showScoreInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedPlayer = displayPlayerName;
        int score = displayScore ?? 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${displayPlayerName != null ? 'Update' : 'Add'} ${widget.animalName} Score'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedPlayer,
                    hint: const Text('Select Player'),
                    isExpanded: true,
                    items: widget.playerScores.map((PlayerScore player) {
                      return DropdownMenuItem<String>(
                        value: player.name,
                        child: Text(player.name),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedPlayer = value;
                      });
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Enter # of ${widget.animalName}s'),
                    controller: TextEditingController(text: score.toString()),
                    onChanged: (value) {
                      score = int.tryParse(value) ?? 0;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (selectedPlayer != null) {
                      widget.scoreCalculationService.updateScore(selectedPlayer!, widget.animalName, score);
                      Navigator.of(context).pop();
                      _updateDisplayScore();
                      widget.onScoreUpdated();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}