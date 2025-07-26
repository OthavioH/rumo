import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color successColor;
  AppColors({this.successColor = const Color(0xFF01E17B)});

  @override
  ThemeExtension<AppColors> copyWith({
    Color? successColor,
  }) {
    return AppColors(
      successColor: successColor ?? this.successColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) return this;
    return AppColors(
      successColor: Color.lerp(successColor, other.successColor, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors? get appColors => Theme.of(this).extension<AppColors>();
}
