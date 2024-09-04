@TestOn('vm')
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stroke_stakes/features/score_calculation/widgets/wad_score_entry_widget.dart'; // Replace with your correct import path
import 'package:stroke_stakes/features/score_calculation/models/score_calculation_model.dart';
import 'package:stroke_stakes/features/score_calculation/services/score_calculation_service.dart';

void main() {
  testWidgets('WadScoreEntryWidget increments and decrements wad count correctly', (WidgetTester tester) async {
    // Initialize the required dependencies for the test
    final List<PlayerScore> playerScores = [
      PlayerScore(name: 'Player 1'), // Use the correct constructor with only the 'name' parameter
      PlayerScore(name: 'Player 2'),
    ];

    final ScoreCalculationService scoreCalculationService = ScoreCalculationService();

    // Create the widget for testing
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: WadScoreEntryWidget(
          playerScores: playerScores,
          isFrontNine: true,
          scoreCalculationService: scoreCalculationService,
          onScoreUpdated: () {},
        ),
      ),
    ));

    // Open the dialog
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    // Tap on the '+' button and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the wad count has incremented
    expect(find.text('1'), findsOneWidget);

    // Tap on the '-' button and trigger a frame
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    // Verify that the wad count has decremented
    expect(find.text('0'), findsOneWidget);
  });
}