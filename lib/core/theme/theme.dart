import 'package:flutter/material.dart';

// Common color variables
const Color _primaryColor = Color(0xFF5DB444); // Updated green from the UI
const Color _secondaryColor =
    Color(0xFF2A472A); // Darker green for secondary elements
const Color _surfaceColor = Color(0xFF1A1A1A); // Dark background
const Color _errorColor = Color(0xFFD32F2F); // Darker red for better contrast
const Color _primaryTextColor = Colors.white;
const Color _secondaryTextColor =
    Color(0xFF5DB444); // Using the updated green for accent text

// Dark theme color variables
const Color _darkPrimaryColor = Color(0xFF5DB444); // Same updated green
const Color _darkSecondaryColor = Color(0xFF2A472A); // Same darker green
const Color _darkSurfaceColor =
    Color(0xFF121212); // Even darker background for dark mode
const Color _darkErrorColor = Color(0xFFD32F2F); // Matching error color
const Color _darkPrimaryTextColor = Colors.white;

// Font variables
const String _primaryFont = 'Roboto';
const String _secondaryFont = 'Lato';

// Base TextTheme with all Material defaults (without colors)
const TextTheme _baseTextTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, fontFamily: _secondaryFont),
  displayMedium: TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, fontFamily: _secondaryFont),
  displaySmall: TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, fontFamily: _secondaryFont),
  headlineLarge: TextStyle(
      fontSize: 22, fontWeight: FontWeight.w600, fontFamily: _primaryFont),
  headlineMedium: TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, fontFamily: _primaryFont),
  headlineSmall: TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, fontFamily: _primaryFont),
  titleLarge: TextStyle(
      fontSize: 20, fontWeight: FontWeight.w500, fontFamily: _primaryFont),
  titleMedium: TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, fontFamily: _primaryFont),
  titleSmall: TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, fontFamily: _primaryFont),
  bodyLarge: TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, fontFamily: _primaryFont),
  bodyMedium: TextStyle(
      fontSize: 14, fontWeight: FontWeight.normal, fontFamily: _primaryFont),
  bodySmall: TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, fontFamily: _primaryFont),
  labelLarge: TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, fontFamily: _primaryFont),
  labelMedium: TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, fontFamily: _primaryFont),
  labelSmall: TextStyle(
      fontSize: 12, fontWeight: FontWeight.bold, fontFamily: _primaryFont),
);

// Shared button style to manage radius and other button properties
final ButtonStyle _sharedElevatedButtonStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0), // Unified button roundness
  ),
  textStyle: const TextStyle(
    fontFamily: _primaryFont, // Set the desired font for ElevatedButton
    fontSize: 16, // Set the desired font size
    fontWeight: FontWeight.w600, // Set the desired font weight
  ),
);

// Shared dialog theme
final DialogTheme _sharedDialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(8.0), // Reduced rounded corners for all dialogs
  ),
);

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
      textTheme: _baseTextTheme.apply(
        bodyColor: _primaryTextColor,
        displayColor: _primaryTextColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 22, // Set the label font size to 22px
          fontWeight: FontWeight.bold, // Bold weight for visibility
          color: _primaryTextColor,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 22, // Set the floating label font size to 22px
          fontWeight: FontWeight.bold,
          color: _primaryTextColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _sharedElevatedButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(_primaryColor),
          foregroundColor: WidgetStateProperty.all(_secondaryTextColor),
        ),
      ),
      dialogTheme: _sharedDialogTheme.copyWith(
        titleTextStyle:
            _baseTextTheme.titleMedium!.copyWith(color: _primaryTextColor),
        contentTextStyle:
            _baseTextTheme.bodyMedium!.copyWith(color: _primaryTextColor),
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
        error: _darkErrorColor,
      ),
      scaffoldBackgroundColor: _darkSurfaceColor,
      fontFamily: _primaryFont,
      textTheme: _baseTextTheme.apply(
        bodyColor: _darkPrimaryTextColor,
        displayColor: _darkPrimaryTextColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 18, // Set the label font size to 22px
          color: _darkPrimaryTextColor,
        ),
        floatingLabelStyle: TextStyle(
          fontSize: 22, // Set the floating label font size to 22px
          color: _darkPrimaryTextColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _sharedElevatedButtonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(_darkPrimaryColor),
          foregroundColor: WidgetStateProperty.all(_darkPrimaryTextColor),
        ),
      ),
      dialogTheme: _sharedDialogTheme.copyWith(
        titleTextStyle:
            _baseTextTheme.titleMedium!.copyWith(color: _darkPrimaryTextColor),
        contentTextStyle:
            _baseTextTheme.bodyMedium!.copyWith(color: _darkPrimaryTextColor),
      ),
    );
  }
}
