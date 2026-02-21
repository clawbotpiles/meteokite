// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meteokite/app/app.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/presentation/providers/weather_providers.dart';

void main() {
  testWidgets('renders MeteoKite dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentWindProvider.overrideWith(
            (ref) async => WindSnapshot(
              speedKn: 18,
              gustKn: 22,
              directionDeg: 245,
              timestamp: DateTime.now().toUtc(),
              source: 'test',
            ),
          ),
        ],
        child: const MeteoKiteApp(),
      ),
    );

    expect(find.text('MeteoKite'), findsOneWidget);
    expect(find.text('Semaforo de navegabilidad'), findsOneWidget);
    expect(find.text('Estado del sistema'), findsOneWidget);
  });
}
