import 'package:flutter/material.dart';

// Color variables - easily changeable
const Color _primaryColor = Color(0xFF4CAF50); // Green
const Color _secondaryColor = Color(0xFFFFA000); // Amber
const Color _surfaceColor = Color(0xFFF5F5F5); // Light Grey
const Color _errorColor = Colors.red;

// Dark theme color variables
const Color _darkPrimaryColor = Color(0xFF81C784); // Light Green
const Color _darkSecondaryColor = Color(0xFFFFD54F); // Light Amber
const Color _darkSurfaceColor = Color(0xFF303030); // Dark Grey

// Font variables - easily changeable
const String _primaryFont = 'Roboto';
const String _secondaryFont = 'Lato';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        error: _errorColor,
      ),
      scaffoldBackgroundColor: _surfaceColor,
      fontFamily: _primaryFont,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: _secondaryFont),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _darkPrimaryColor,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkSecondaryColor,
        surface: _darkSurfaceColor,
        error: _errorColor,
      ),
      scaffoldBackgroundColor: _darkSurfaceColor,
      fontFamily: _primaryFont,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: _secondaryFont),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}