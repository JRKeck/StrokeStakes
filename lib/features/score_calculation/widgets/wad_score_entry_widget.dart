import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for haptic feedback
import '../models/score_calculation_model.dart';
import '../services/score_calculation_service.dart';
import '../widgets/dialog_title_bar.dart'; // Import the custom dialog title bar widget

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
  String? _validationError; // Variable to hold validation error message

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
    setState(() {
      displayPlayerName = wadOwner?.playerName;
      displayWadCount = wadOwner?.wadCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

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
            final Color primaryTextColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              title: const DialogTitleBar(title: 'Update Wads'),
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
                  if (_validationError != null)
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
                        onTap: wadCount > 0
                            ? () {
                                HapticFeedback.lightImpact(); // Add haptic feedback when decrementing
                                setState(() => wadCount--);
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryTextColor,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('$wadCount', style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact(); // Add haptic feedback when incrementing
                          setState(() => wadCount++);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryTextColor,
                              width: 2.0,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: primaryTextColor,
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
                      widget.scoreCalculationService.updateWad(
                          widget.isFrontNine, selectedPlayer!, wadCount);
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
