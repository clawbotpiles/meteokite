import 'package:flutter/material.dart';

@immutable
class MeteoKiteColors extends ThemeExtension<MeteoKiteColors> {
  const MeteoKiteColors({
    required this.accent,
    required this.surfaceVariant,
    required this.windLow,
    required this.windMid,
    required this.windStrong,
  });

  final Color accent;
  final Color surfaceVariant;
  final Color windLow;
  final Color windMid;
  final Color windStrong;

  static const light = MeteoKiteColors(
    accent: Color(0xFFF4A300),
    surfaceVariant: Color(0xFFE7EEF3),
    windLow: Color(0xFF1D9BF0),
    windMid: Color(0xFF0F9D58),
    windStrong: Color(0xFFD9480F),
  );

  static const dark = MeteoKiteColors(
    accent: Color(0xFFFFC857),
    surfaceVariant: Color(0xFF1D3445),
    windLow: Color(0xFF4AB3FF),
    windMid: Color(0xFF45D483),
    windStrong: Color(0xFFFF8A4C),
  );

  @override
  ThemeExtension<MeteoKiteColors> copyWith({
    Color? accent,
    Color? surfaceVariant,
    Color? windLow,
    Color? windMid,
    Color? windStrong,
  }) {
    return MeteoKiteColors(
      accent: accent ?? this.accent,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      windLow: windLow ?? this.windLow,
      windMid: windMid ?? this.windMid,
      windStrong: windStrong ?? this.windStrong,
    );
  }

  @override
  ThemeExtension<MeteoKiteColors> lerp(
    covariant ThemeExtension<MeteoKiteColors>? other,
    double t,
  ) {
    if (other is! MeteoKiteColors) {
      return this;
    }

    return MeteoKiteColors(
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      windLow: Color.lerp(windLow, other.windLow, t) ?? windLow,
      windMid: Color.lerp(windMid, other.windMid, t) ?? windMid,
      windStrong: Color.lerp(windStrong, other.windStrong, t) ?? windStrong,
    );
  }
}

class AppColorScheme {
  static final light =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F6E8C),
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFF0F6E8C),
        secondary: const Color(0xFF1A8FB3),
        surface: const Color(0xFFFFFFFF),
        onSurface: const Color(0xFF102A43),
        error: const Color(0xFFC62828),
      );

  static final dark =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF3BA8C6),
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFF3BA8C6),
        secondary: const Color(0xFF67C0D9),
        surface: const Color(0xFF132735),
        onSurface: const Color(0xFFEAF3F8),
        error: const Color(0xFFFF6B6B),
      );
}

extension MeteoKiteThemeContext on BuildContext {
  MeteoKiteColors get mkColors => Theme.of(this).extension<MeteoKiteColors>()!;
}
