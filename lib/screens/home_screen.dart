// Importing necessary Flutter packages and the score calculation service
import 'package:flutter/material.dart'; // Flutter's core material design package
import '../features/score_calculation/services/score_calculation_service.dart'; // Importing the score calculation service
import 'game_setup_screen.dart'; // Importing the screen for game setup

// HomeScreen widget is a stateless widget that serves as the main entry screen of the app
class HomeScreen extends StatelessWidget {
  // Dependency injection: The ScoreCalculationService is passed into the HomeScreen
  final ScoreCalculationService scoreCalculationService;

  // Constructor for HomeScreen, marked as constant to optimize rebuilds
  const HomeScreen({super.key, required this.scoreCalculationService});

  @override
  Widget build(BuildContext context) {
    // The build method returns a Scaffold, which provides a basic visual structure for the app screen
    return Scaffold(
      body: SafeArea(
        // SafeArea ensures the UI does not overlap with system UI elements (like the status bar)
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2, // Takes up 2/3 of the available vertical space
              child: Center(
                child: Image.asset(
                  'lib/core/assets/images/strokestakes_logo.png', // Path to your custom image
                  width: 275, // Adjust width as needed
                  height: 275, // Adjust height as needed
                  fit: BoxFit.contain, // Adjust how the image should fit within the widget
                ),
              ),
            ),
            // Moving the "Game Calculator" button up and making it larger
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding for button width
              child: ElevatedButton(
                onPressed: () {
                  // Navigates to the GameSetupScreen, passing the scoreCalculationService instance
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameSetupScreen(scoreCalculationService: scoreCalculationService),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0), // Increase vertical padding for a larger button
                ),
                child: const Text(
                  'GAME CALCULATOR', // Text for the button
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Larger font size
                ),
              ),
            ),
            const SizedBox(height: 120), // Add some space between the buttons
            // Keeping the "Game Rules" button smaller
            ElevatedButton(
              onPressed: () {
                // Placeholder for rules/help functionality
                // TODO: Implement rules/help functionality
              },
              child: const Text('GAME RULES'), // Text for the button
            ),
            const SizedBox(height: 20), // Add some bottom spacing
          ],
        ),
      ),
    );
  }
}
