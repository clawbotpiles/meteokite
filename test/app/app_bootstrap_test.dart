import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokitev2_0/main.dart';

void main() {
  testWidgets('app starts on dashboard route in dev bypass mode', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    expect(find.text('MeteoKite'), findsOneWidget);
    expect(find.text('Spots'), findsWidgets);
    expect(find.text('Session'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}
