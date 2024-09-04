// Importing necessary Flutter and Dart packages
import 'package:flutter/material.dart'; // Flutter's core material design package
import 'screens/home_screen.dart'; // Importing the home screen of the app
import 'features/score_calculation/services/score_calculation_service.dart'; // Importing the service for score calculation
import 'core/theme/theme.dart'; // Importing the theme file for light and dark modes

// The main function is the entry point of every Flutter app
void main() {
  runApp(MyApp()); // This runs the MyApp widget, the root of the application
}

// MyApp class is a stateless widget that represents the whole app
class MyApp extends StatelessWidget {
  // Instance of ScoreCalculationService, a service class for managing score calculation
  final ScoreCalculationService scoreCalculationService = ScoreCalculationService();

  // Constructor for MyApp with a key, a best practice for performance optimization in Flutter
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The build method returns a MaterialApp widget, which is the root of the application
    return MaterialApp(
      title: 'StrokeStakes', // The title of the app, used in the task switcher
      theme: AppTheme.lightTheme, // Applying the light theme from the imported theme file
      darkTheme: AppTheme.darkTheme, // Applying the dark theme from the imported theme file
      themeMode: ThemeMode.system, // The theme mode is set to follow the system setting (light or dark)
      home: HomeScreen(scoreCalculationService: scoreCalculationService), // Setting the home screen of the app, passing the score calculation service as a parameter
    );
  }
}
