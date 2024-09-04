import 'package:flutter/material.dart';
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';
import '../widgets/dialog_title_bar.dart'; // Import the custom dialog title bar widget

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
  String? _validationError; // Variable to hold validation error message

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
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              title: DialogTitleBar(title: existingGreenie != null ? 'Update Greenie' : 'Add Greenie'),
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
                        _validationError = null; // Clear validation error when a player is selected
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
                        _validationError = null; // Clear validation error when a result is selected
                      });
                    },
                  ),
                  if (_validationError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _validationError!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                if (existingGreenie != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Save'),
                  onPressed: () {
                    if (selectedPlayer == null && selectedResult == null) {
                      setState(() {
                        _validationError = 'Please select both a player and a result.';
                      });
                    } else if (selectedPlayer == null) {
                      setState(() {
                        _validationError = 'Please select a player.';
                      });
                    } else if (selectedResult == null) {
                      setState(() {
                        _validationError = 'Please select a result.';
                      });
                    } else {
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
