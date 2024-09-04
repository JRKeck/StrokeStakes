import 'package:flutter/material.dart';
import '../features/score_calculation/services/score_calculation_service.dart';
import '../features/score_calculation/widgets/animal_score_entry_widget.dart';
import '../features/score_calculation/widgets/greenie_score_entry_widget.dart';
import 'totals_screen.dart';
import '../features/score_calculation/widgets/wad_score_entry_widget.dart';
import '../features/score_calculation/widgets/dialog_title_bar.dart'; // Import the custom dialog title bar widget

class ScoreEntryScreen extends StatefulWidget {
  final ScoreCalculationService scoreCalculationService;

  const ScoreEntryScreen({super.key, required this.scoreCalculationService});

  @override
  State<ScoreEntryScreen> createState() => _ScoreEntryScreenState();
}

class _ScoreEntryScreenState extends State<ScoreEntryScreen> {
  final List<String> animals = ['Snake', 'Camel', 'Frog', 'Gorilla'];

  void _onScoreUpdated() {
    setState(() {});
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero, // Remove default padding around title
          contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          title: const DialogTitleBar(title: 'Exit Game'),
          content: const Text('Are you sure you want to exit the game? All progress will be lost.'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
                widget.scoreCalculationService.endCalculation();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final calculation = widget.scoreCalculationService.currentCalculation;
    if (calculation == null) {
      return const Scaffold(
        body: Center(child: Text('No active calculation')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(calculation.isFrontNine ? 'Front 9 Scores' : 'Back 9 Scores'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ...animals.map((animal) => AnimalScoreEntryWidget(
                    key: ValueKey('${animal}_${calculation.isFrontNine}'),
                    animalName: animal,
                    playerScores: calculation.playerScores,
                    isFrontNine: calculation.isFrontNine,
                    scoreCalculationService: widget.scoreCalculationService,
                    onScoreUpdated: _onScoreUpdated,
                  )),
                  GreenieScoreEntryWidget(
                    key: ValueKey('Greenie_${calculation.isFrontNine}'),
                    playerScores: calculation.playerScores,
                    isFrontNine: calculation.isFrontNine,
                    scoreCalculationService: widget.scoreCalculationService,
                    onScoreUpdated: _onScoreUpdated,
                  ),
                  WadScoreEntryWidget(
                    key: ValueKey('Wad_${calculation.isFrontNine}'),
                    playerScores: calculation.playerScores,
                    isFrontNine: calculation.isFrontNine,
                    scoreCalculationService: widget.scoreCalculationService,
                    onScoreUpdated: _onScoreUpdated,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (calculation.isFrontNine) {
                          widget.scoreCalculationService.switchToBackNine();
                        } else {
                          widget.scoreCalculationService.switchToFrontNine();
                        }
                      });
                    },
                    child: Text(calculation.isFrontNine ? 'Switch to Back 9' : 'Switch to Front 9'),
                  ),
                  if (!calculation.isFrontNine)
                    const SizedBox(height: 8),
                  if (!calculation.isFrontNine)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TotalsScreen(scoreCalculationService: widget.scoreCalculationService),
                          ),
                        );
                      },
                      child: const Text('Calculate Results'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
