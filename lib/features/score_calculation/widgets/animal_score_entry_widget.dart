import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';
import '../widgets/dialog_title_bar.dart'; // Import the custom dialog title bar widget

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
  String? _validationError; // Variable to hold validation error message

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
            // Determine the dialog title dynamically
            final String dialogTitle = displayScore != null && displayScore! > 0
                ? 'Update ${widget.animalName} Score'
                : 'Add ${widget.animalName} Score';

            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              title: DialogTitleBar(title: dialogTitle),
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
                  if (_validationError != null) // Display validation error if necessary
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _validationError!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: score > 0
                            ? () {
                                HapticFeedback.lightImpact(); // Add haptic feedback when decrementing
                                setState(() => score--);
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('$score', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact(); // Add haptic feedback when incrementing
                          setState(() => score++);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                          ),
                        ),
                      ),
                    ],
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Save'),
                  onPressed: () {
                    if (selectedPlayer == null) {
                      setState(() {
                        _validationError = 'Please select a player.';
                      });
                    } else {
                      widget.scoreCalculationService.updateScore(
                          selectedPlayer!, widget.animalName, score);
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
