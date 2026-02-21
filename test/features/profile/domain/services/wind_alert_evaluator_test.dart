import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/features/profile/domain/services/wind_alert_evaluator.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

void main() {
  WindSnapshot buildWind({
    required double speedKn,
    required int directionDeg,
    required DateTime timestamp,
  }) {
    return WindSnapshot(
      speedKn: speedKn,
      gustKn: speedKn + 4,
      directionDeg: directionDeg,
      timestamp: timestamp,
      source: 'test',
    );
  }

  test('matches when wind fits speed direction and time ranges', () {
    final result = evaluateWindAlertRule(
      wind: buildWind(
        speedKn: 18,
        directionDeg: 250,
        timestamp: DateTime.utc(2026, 2, 21, 12),
      ),
      minSpeedKn: 15,
      maxSpeedKn: 25,
      directionMinDeg: 220,
      directionMaxDeg: 300,
      startHour: 10,
      endHour: 20,
    );

    expect(result.matches, isTrue);
  });

  test('supports circular direction range crossing north', () {
    final result = evaluateWindAlertRule(
      wind: buildWind(
        speedKn: 20,
        directionDeg: 350,
        timestamp: DateTime.utc(2026, 2, 21, 12),
      ),
      minSpeedKn: 15,
      maxSpeedKn: 25,
      directionMinDeg: 320,
      directionMaxDeg: 30,
      startHour: 10,
      endHour: 20,
    );

    expect(result.matches, isTrue);
  });

  test('supports circular hour range crossing midnight', () {
    final result = evaluateWindAlertRule(
      wind: buildWind(
        speedKn: 20,
        directionDeg: 350,
        timestamp: DateTime.utc(2026, 2, 21, 1),
      ),
      minSpeedKn: 15,
      maxSpeedKn: 25,
      directionMinDeg: 320,
      directionMaxDeg: 30,
      startHour: 22,
      endHour: 4,
    );

    expect(result.matches, isTrue);
  });

  test('returns non-match reason when out of speed range', () {
    final result = evaluateWindAlertRule(
      wind: buildWind(
        speedKn: 11,
        directionDeg: 250,
        timestamp: DateTime.utc(2026, 2, 21, 12),
      ),
      minSpeedKn: 15,
      maxSpeedKn: 25,
      directionMinDeg: 220,
      directionMaxDeg: 300,
      startHour: 10,
      endHour: 20,
    );

    expect(result.matches, isFalse);
    expect(result.reason, contains('viento'));
  });
}
