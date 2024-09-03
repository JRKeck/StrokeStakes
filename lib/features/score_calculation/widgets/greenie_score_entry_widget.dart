import 'package:flutter/material.dart';
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';

class GreenieScoreEntryWidget extends StatefulWidget {
  final List<PlayerScore> playerScores;
  final bool isFrontNine;
  final ScoreCalculationService scoreCalculationService;
  final VoidCallback onScoreUpdated;

  const GreenieScoreEntryWidget({
    super.key,
    required this.playerScores,
    required this.isFrontNine,
    required this.scoreCalculationService,
    required this.onScoreUpdated,
  });

  @override
  State<GreenieScoreEntryWidget> createState() => _GreenieScoreEntryWidgetState();
}

class _GreenieScoreEntryWidgetState extends State<GreenieScoreEntryWidget> {
  @override
  Widget build(BuildContext context) {
    final greenies = widget.scoreCalculationService.getGreenies(widget.isFrontNine);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Greenies', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showGreenieInputDialog,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...greenies.map((greenie) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${greenie.playerName}: ${_getGreenieResultText(greenie.result)}'),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _showGreenieInputDialog(existingGreenie: greenie),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showGreenieInputDialog({GreenieScore? existingGreenie}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedPlayer = existingGreenie?.playerName;
        GreenieResult? selectedResult = existingGreenie?.result;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingGreenie != null ? 'Update Greenie' : 'Add Greenie'),
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
                  DropdownButton<GreenieResult>(
                    value: selectedResult,
                    hint: const Text('Select Result'),
                    isExpanded: true,
                    items: GreenieResult.values.map((GreenieResult result) {
                      return DropdownMenuItem<GreenieResult>(
                        value: result,
                        child: Text(_getGreenieResultText(result)),
                      );
                    }).toList(),
                    onChanged: (GreenieResult? value) {
                      setState(() {
                        selectedResult = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                if (existingGreenie != null)
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      widget.scoreCalculationService.removeGreenie(
                        widget.isFrontNine,
                        existingGreenie,
                      );
                      Navigator.of(context).pop();
                      widget.onScoreUpdated();
                    },
                  ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (selectedPlayer != null && selectedResult != null) {
                      widget.scoreCalculationService.updateGreenie(
                        widget.isFrontNine,
                        GreenieScore(playerName: selectedPlayer!, result: selectedResult!),
                        existingGreenie,
                      );
                      Navigator.of(context).pop();
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
}