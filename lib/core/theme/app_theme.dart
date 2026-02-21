import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_colors.dart';
import 'package:meteokite/core/theme/app_radius.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/core/theme/app_typography.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    colorScheme: AppColorScheme.light,
    scaffoldBackgroundColor: const Color(0xFFF2F7FA),
    textTheme: AppTypography.textTheme(Brightness.light),
    extensions: const [MeteoKiteColors.light],
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      elevation: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    colorScheme: AppColorScheme.dark,
    scaffoldBackgroundColor: const Color(0xFF0B1B26),
    textTheme: AppTypography.textTheme(Brightness.dark),
    extensions: const [MeteoKiteColors.dark],
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      color: const Color(0xFF132735),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      elevation: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    ),
  );
}
