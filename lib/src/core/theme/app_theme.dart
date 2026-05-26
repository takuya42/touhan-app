import 'package:flutter/material.dart';

class AppTheme {
  static const _mint = Color(0xFF4CC9B0);
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: _mint, brightness: Brightness.light, surface: const Color(0xFFF6F7F9));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F7F9), elevation: 0),
      cardTheme: CardThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)), elevation: 0.8, margin: const EdgeInsets.symmetric(vertical: 6)),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.white.withOpacity(0.95), indicatorColor: _mint.withOpacity(0.18), elevation: 8),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none)),
    );
  }

  static ThemeData dark() => ThemeData.dark(useMaterial3: true);
}
