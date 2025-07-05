import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF4E61F6),
        brightness: Brightness.light,
        primary: Color(0xFF4E61F6),
        surface: Colors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          side: BorderSide(color: Color(0xFFD9D9D9), width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF4E61F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Color(0xFF4E61F6), width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
