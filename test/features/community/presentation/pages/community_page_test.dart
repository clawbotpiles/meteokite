import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteokitev2_0/features/community/presentation/pages/community_page.dart';

void main() {
  testWidgets('community shows leaderboard and following segments', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Amigos'), findsOneWidget);
    expect(find.text('Salto mas alto (m)'), findsOneWidget);
  });

  testWidgets('leaderboard header changes with selected metric', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

    await tester.tap(find.text('Mostrar filtros'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salto mas alto').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Big Air score').last);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Aplicar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('Big Air score (pts)'), findsOneWidget);
  });

  testWidgets('leaderboard filters are visible', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

    await tester.tap(find.text('Mostrar filtros'));
    await tester.pumpAndSettle();

    expect(find.text('Periodo'), findsWidgets);
    expect(find.text('Spot'), findsWidgets);
    expect(find.text('Scope'), findsWidgets);
    expect(find.text('Orden'), findsWidgets);
    expect(
      find.widgetWithText(FilledButton, 'Aplicar filtros'),
      findsOneWidget,
    );
  });

  testWidgets(
    'amigos shows followed users section and session social actions',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

      await tester.tap(find.text('Amigos'));
      await tester.pumpAndSettle();

      expect(find.text('Usuarios que sigues'), findsOneWidget);
      await tester.tap(find.text('Usuarios que sigues'));
      await tester.pumpAndSettle();
      expect(find.text('Buscar entre tus amigos'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      await tester.tap(find.byTooltip('Cerrar'));
      await tester.pumpAndSettle();

      expect(find.textContaining('likes'), findsWidgets);
      expect(find.byTooltip('Dar like'), findsWidgets);
      expect(find.byTooltip('Comentar'), findsWidgets);
    },
  );

  testWidgets('community actions navigate to placeholders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

    await tester.tap(find.text('@air_lucas').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ver perfil').first);
    await tester.pumpAndSettle();
    expect(find.text('Perfil de usuario'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('@air_lucas').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver sesiones').first);
    await tester.pumpAndSettle();
    expect(find.text('Sesiones de usuario'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets('amigos session card opens session detail page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));

    await tester.tap(find.text('Amigos'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Foto de la sesion').first);
    await tester.pumpAndSettle();

    expect(find.text('Detalle de sesion'), findsOneWidget);
  });

  testWidgets('community layout remains stable on narrow screens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: CommunityPage()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
