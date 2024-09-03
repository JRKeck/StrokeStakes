import 'package:flutter/material.dart';
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';

class WadScoreEntryWidget extends StatefulWidget {
  final List<PlayerScore> playerScores;
  final bool isFrontNine;
  final ScoreCalculationService scoreCalculationService;
  final VoidCallback onScoreUpdated;

  const WadScoreEntryWidget({
    super.key,
    required this.playerScores,
    required this.isFrontNine,
    required this.scoreCalculationService,
    required this.onScoreUpdated,
  });

  @override
  State<WadScoreEntryWidget> createState() => _WadScoreEntryWidgetState();
}

class _WadScoreEntryWidgetState extends State<WadScoreEntryWidget> {
  String? displayPlayerName;
  int? displayWadCount;

  @override
  void initState() {
    super.initState();
    _updateDisplayScore();
  }

  @override
  void didUpdateWidget(WadScoreEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFrontNine != widget.isFrontNine) {
      _updateDisplayScore();
    }
  }

  void _updateDisplayScore() {
    final wadOwner = widget.scoreCalculationService.getWadOwner(widget.isFrontNine);
    displayPlayerName = wadOwner?.playerName;
    displayWadCount = wadOwner?.wadCount;
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
            Text('Wads', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                if (displayPlayerName != null && displayWadCount != null)
                  Text('$displayPlayerName: $displayWadCount'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showWadInputDialog,
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

  void _showWadInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedPlayer = displayPlayerName;
        int wadCount = displayWadCount ?? 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Wads'),
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: wadCount > 0
                            ? () => setState(() => wadCount--)
                            : null,
                      ),
                      Text('$wadCount', style: Theme.of(context).textTheme.headlineSmall),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => wadCount++),
                      ),
                    ],
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
                      widget.scoreCalculationService.updateWad(widget.isFrontNine, selectedPlayer!, wadCount);
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