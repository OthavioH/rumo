import 'package:flutter/material.dart';
import 'package:rumo/theme/app_colors.dart';

class AppSnackBarTheme extends SnackBarThemeData {
  AppSnackBarTheme({required AppColors appColors})
    : super(
        backgroundColor: Color(0xFF2D3438),
        showCloseIcon: true,
        closeIconColor: appColors.successColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      );
}
