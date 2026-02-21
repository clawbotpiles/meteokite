import 'package:meteokite/shared/widgets/alert_badge.dart';

class WindCondition {
  const WindCondition({
    required this.level,
    required this.label,
    required this.guidance,
  });

  final AlertLevel level;
  final String label;
  final String guidance;

  static WindCondition fromSpeedKn(double speedKn) {
    if (speedKn >= 24) {
      return const WindCondition(
        level: AlertLevel.critical,
        label: 'Condicion exigente',
        guidance: 'Revisa material y nivel tecnico antes de entrar.',
      );
    }

    if (speedKn >= 16) {
      return const WindCondition(
        level: AlertLevel.warning,
        label: 'Condicion navegable',
        guidance: 'Buen rango para sesion con control y margen.',
      );
    }

    return const WindCondition(
      level: AlertLevel.info,
      label: 'Viento flojo',
      guidance: 'Valora equipo de poco viento o esperar ventana mejor.',
    );
  }
}
