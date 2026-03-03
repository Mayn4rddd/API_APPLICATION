import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8FB3C7),
      brightness: Brightness.light,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Color(0xFF555555),
        height: 1.5,
      ),
      bodySmall: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: const Color(0xFF8FB3C7),
      unselectedItemColor: const Color(0xFFB0B0B0),
      type: BottomNavigationBarType.fixed,
    ),
  );

  // Pastel gradient background
  static const LinearGradient pastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB3E5FC), // Light blue
      Color(0xFFE1BEE7), // Lavender
    ],
  );

  // Softer alternative gradient
  static const LinearGradient softPastelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDEF8FF), // Very light blue
      Color(0xFFF0E5FF), // Very light lavender
    ],
  );

  static const Color primaryColor = Color(0xFF8FB3C7);
  static const Color accentColor = Color(0xFFD4A5D4);
  static const Color backgroundColor = Color(0xFFFAFAFA);
}
