import 'package:flutter/material.dart';

class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final headingColor = isDark
        ? const Color(0xFFEAF3F8)
        : const Color(0xFF102A43);
    final bodyColor = isDark
        ? const Color(0xFFB7CBD8)
        : const Color(0xFF334E68);

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Barlow Condensed',
        fontSize: 40,
        height: 44 / 40,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Barlow Condensed',
        fontSize: 32,
        height: 36 / 32,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Barlow Condensed',
        fontSize: 28,
        height: 32 / 28,
        fontWeight: FontWeight.w600,
        color: headingColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Barlow Condensed',
        fontSize: 24,
        height: 28 / 24,
        fontWeight: FontWeight.w500,
        color: headingColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 18,
        height: 26 / 18,
        color: bodyColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 16,
        height: 24 / 16,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 14,
        height: 20 / 14,
        color: bodyColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: bodyColor,
      ),
    );
  }
}
