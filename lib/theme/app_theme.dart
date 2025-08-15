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
      searchViewTheme: SearchViewThemeData(
        constraints: BoxConstraints(maxHeight: 250),
        backgroundColor: Color(0xFFF9FAFB),
        side: BorderSide(color: Color(0xFFE5E7EA), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        headerHintStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF757575),
        ),
        headerTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(0xFF1E1E1E),
        ),
        dividerColor: Colors.transparent,
        barPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(Color(0xFFF9FAFB)),
        side: WidgetStatePropertyAll(
          BorderSide(color: Color(0xFFE5E7EA), width: 1.5),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: WidgetStatePropertyAll(0),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
          ),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        clipBehavior: Clip.antiAlias,
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
          padding: EdgeInsets.all(16),
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
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF4E61F6);
          }
          return Color(0xFFE5E7EA);
        }),
        thumbColor: WidgetStatePropertyAll(Colors.white),
        thumbIcon: WidgetStatePropertyAll(const Icon(null)),
        trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        horizontalTitleGap: 10,
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: MenuItemButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 26, vertical: 4),
          maximumSize: Size.fromWidth(120),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
