import 'package:flutter/material.dart';
import 'package:date_app/core/theme/app_colors.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDark => theme.brightness == Brightness.dark;

  Color get appBackground => theme.scaffoldBackgroundColor;
  Color get surfaceCard => isDark ? AppColors.surfaceCard : Colors.white;
  Color get surfaceDark =>
      isDark ? AppColors.surfaceDark : const Color(0xFFF3F1F6);
  Color get textPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get stroke =>
      isDark ? AppColors.strokes : const Color(0xFFE5E2EC);
  Color get navBackground => isDark
      ? AppColors.background.withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.92);
}
