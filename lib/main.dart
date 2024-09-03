import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'features/score_calculation/services/score_calculation_service.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ScoreCalculationService scoreCalculationService = ScoreCalculationService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrokeStakes',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomeScreen(scoreCalculationService: scoreCalculationService),
    );
  }
}