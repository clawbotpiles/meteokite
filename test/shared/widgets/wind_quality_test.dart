import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/wind_quality.dart';

void main() {
  group('WindQuality.fromSpeedAndGust', () {
    test('returns stable when gust delta is small', () {
      final quality = WindQuality.fromSpeedAndGust(speedKn: 15, gustKn: 17);

      expect(quality.level, AlertLevel.info);
      expect(quality.label, 'Lectura estable');
      expect(quality.guidance, contains('consistente'));
    });

    test('returns variable when gust delta is medium', () {
      final quality = WindQuality.fromSpeedAndGust(speedKn: 15, gustKn: 20);

      expect(quality.level, AlertLevel.warning);
      expect(quality.label, 'Lectura variable');
      expect(quality.guidance, contains('cambiar'));
    });

    test('returns gusty when gust delta is high', () {
      final quality = WindQuality.fromSpeedAndGust(speedKn: 15, gustKn: 24);

      expect(quality.level, AlertLevel.critical);
      expect(quality.label, 'Lectura racheada');
      expect(quality.guidance, contains('Rachas'));
    });
  });
}
