import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteokitev2_0/features/sessions/presentation/pages/sessions_page.dart';

void main() {
  testWidgets('includes phone device in linked devices list', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SessionsPage()));

    expect(find.text('Telefono del usuario'), findsOneWidget);

    final phoneY = tester.getCenter(find.text('Telefono del usuario')).dy;
    final wooY = tester.getCenter(find.text('Woo Sports 3')).dy;
    expect(phoneY, lessThan(wooY));
  });

  testWidgets('shows selected device capabilities and updates when changed', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SessionsPage()));

    expect(find.text('Capacidades del dispositivo'), findsOneWidget);
    expect(find.text('7/9 sensores disponibles'), findsOneWidget);

    await tester.tap(find.text('Apple Watch Ultra'));
    await tester.pumpAndSettle();

    expect(find.text('9/9 sensores disponibles'), findsOneWidget);
  });

  testWidgets('imports file and creates session with jump history', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SessionsPage()));

    final importButton = find.widgetWithText(OutlinedButton, 'Importar sesion');

    await tester.ensureVisible(importButton);
    await tester.pumpAndSettle();

    await tester.tap(importButton);
    await tester.pumpAndSettle();

    expect(find.text('Sesion importada en Oliva Norte'), findsOneWidget);

    await tester.tap(find.text('Sesion importada en Oliva Norte'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Historico de saltos'),
      250,
      scrollable: find.byType(Scrollable),
    );

    expect(find.text('Historico de saltos'), findsOneWidget);
    expect(find.text('Min:Seg'), findsOneWidget);
  });
}
