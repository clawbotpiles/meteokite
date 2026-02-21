import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

class WindAlertEvaluationResult {
  const WindAlertEvaluationResult({
    required this.matches,
    required this.reason,
  });

  final bool matches;
  final String reason;
}

WindAlertEvaluationResult evaluateWindAlertRule({
  required WindSnapshot wind,
  required double minSpeedKn,
  required double maxSpeedKn,
  required int directionMinDeg,
  required int directionMaxDeg,
  required int startHour,
  required int endHour,
}) {
  final speedOk = wind.speedKn >= minSpeedKn && wind.speedKn <= maxSpeedKn;
  final directionOk = _inCircularRange(
    wind.directionDeg,
    directionMinDeg,
    directionMaxDeg,
    maxValue: 359,
  );
  final hourOk = _inCircularRange(
    wind.timestamp.toLocal().hour,
    startHour,
    endHour,
    maxValue: 23,
  );

  if (speedOk && directionOk && hourOk) {
    return const WindAlertEvaluationResult(
      matches: true,
      reason: 'Activa ahora',
    );
  }

  final reasons = <String>[];
  if (!speedOk) {
    reasons.add('fuera de rango de viento');
  }
  if (!directionOk) {
    reasons.add('direccion fuera de rango');
  }
  if (!hourOk) {
    reasons.add('fuera de horario');
  }

  return WindAlertEvaluationResult(matches: false, reason: reasons.join(', '));
}

bool _inCircularRange(int value, int start, int end, {required int maxValue}) {
  if (start == end) {
    return value == start;
  }

  if (start < end) {
    return value >= start && value <= end;
  }

  return value >= start || value <= end;
}
