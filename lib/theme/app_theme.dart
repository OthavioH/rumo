import 'package:flutter/material.dart';

class AppTheme {
  ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: Color(0xFF4E61F6),
    brightness: Brightness.light,
    primary: Color(0xFF4E61F6),
    surface: Colors.white,
  );

  ThemeData get theme {
    return ThemeData(
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          side: BorderSide(color: Color(0xFFD9D9D9), width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size.fromHeight(48),
          backgroundColor: Color(0xFF4E61F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Color(0xFF4E61F6), width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Color(0xFF4E61F6),
          textStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 24 / 12,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black,
          ),
        ),
      ),

      /// InputDecorationTheme controla a aparência dos inputs de texto
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9EA2AE),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EA), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EA), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFEE443F), width: 1.5),
        ),
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return Color(0xFFFDECEC);
          }
          return Color(0xFFF9FAFB);
        }),
        filled: true,
      ),

      dialogTheme: DialogThemeData(backgroundColor: colorScheme.surface),

      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states){
          if(states.contains(WidgetState.selected)) {
            return Color(0xFF4E61F6);
          }
          return Color(0xFFE5E7EA);
        }),
        thumbColor: WidgetStatePropertyAll(Colors.white),
        thumbIcon: WidgetStatePropertyAll(const Icon(null)),
        trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
