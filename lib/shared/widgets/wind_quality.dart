import 'package:meteokite/shared/widgets/alert_badge.dart';

class WindQuality {
  const WindQuality({
    required this.level,
    required this.label,
    required this.guidance,
  });

  final AlertLevel level;
  final String label;
  final String guidance;

  static WindQuality fromSpeedAndGust({
    required double speedKn,
    required double gustKn,
  }) {
    final delta = gustKn - speedKn;

    if (delta <= 3) {
      return const WindQuality(
        level: AlertLevel.info,
        label: 'Lectura estable',
        guidance: 'Condicion consistente para planificar maniobras.',
      );
    }

    if (delta <= 7) {
      return const WindQuality(
        level: AlertLevel.warning,
        label: 'Lectura variable',
        guidance: 'Puede cambiar rapido; revisa rachas antes de entrar.',
      );
    }

    return const WindQuality(
      level: AlertLevel.critical,
      label: 'Lectura racheada',
      guidance: 'Rachas fuertes; ajusta tamano y margen de seguridad.',
    );
  }
}
