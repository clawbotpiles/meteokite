import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/wind_condition.dart';

void main() {
  group('WindCondition.fromSpeedKn', () {
    test('returns info level for low wind', () {
      final condition = WindCondition.fromSpeedKn(12.0);

      expect(condition.level, AlertLevel.info);
      expect(condition.label, 'Viento flojo');
    });

    test('returns warning level for medium wind', () {
      final condition = WindCondition.fromSpeedKn(18.5);

      expect(condition.level, AlertLevel.warning);
      expect(condition.label, 'Condicion navegable');
    });

    test('returns critical level for strong wind', () {
      final condition = WindCondition.fromSpeedKn(28.3);

      expect(condition.level, AlertLevel.critical);
      expect(condition.label, 'Condicion exigente');
    });
  });
}
