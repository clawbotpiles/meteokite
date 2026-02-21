import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteokitev2_0/features/spots/presentation/pages/spots_page.dart';

void main() {
  testWidgets('adds a spot from floating action button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    expect(
      find.textContaining('Todavia no has agregado spots'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Zona / provincia (opcional)'),
      'Valencia',
    );

    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);
    expect(find.text('Valencia'), findsOneWidget);
  });

  testWidgets('suggests available spots while typing name', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oli',
    );
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);

    await tester.tap(find.text('Oliva'));
    await tester.pumpAndSettle();

    expect(find.text('Valencia'), findsOneWidget);
  });

  testWidgets('supports custom map point from Personalizado button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();

    expect(find.text('Selecciona punto en el mapa'), findsOneWidget);

    await tester.tap(find.byKey(const Key('custom-map-area')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Usar punto'));
    await tester.pumpAndSettle();

    expect(find.text('Punto del mapa seleccionado'), findsOneWidget);
  });

  testWidgets('prevents adding duplicated spots', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    expect(find.text('Ese spot ya esta agregado'), findsOneWidget);
  });

  testWidgets('allows deleting a spot from the list', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);

    await tester.tap(find.byTooltip('Eliminar spot'));
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsNothing);
    expect(
      find.textContaining('Todavia no has agregado spots'),
      findsOneWidget,
    );
  });

  testWidgets('does not allow editing predefined list spots', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Editar spot'), findsNothing);
  });

  testWidgets('allows editing custom spots only', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('custom-map-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar punto'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Mi spot custom',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Editar spot Mi spot custom'));
    await tester.pumpAndSettle();

    expect(find.text('Editar spot'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Mi spot custom editado',
    );
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.text('Mi spot custom editado'), findsOneWidget);
  });

  testWidgets('shows Oficial and Custom chips correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('custom-map-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar punto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Spot libre',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    expect(find.text('Oficial'), findsOneWidget);
    expect(find.text('Custom'), findsWidgets);
  });

  testWidgets('filters spots by type', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('custom-map-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar punto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Spot libre',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('spots-filter-custom')));
    await tester.pumpAndSettle();

    expect(find.text('Spot libre'), findsOneWidget);
    expect(find.text('Oliva'), findsNothing);

    await tester.tap(find.byKey(const Key('spots-filter-official')));
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);
    expect(find.text('Spot libre'), findsNothing);
  });

  testWidgets('filters spots by search text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Oliva',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agregar spot'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personalizado'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('custom-map-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar punto'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Nombre del spot'),
      'Mi custom',
    );
    await tester.tap(find.text('Guardar spot'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('spots-search-input')), 'oli');
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);
    expect(find.text('Mi custom'), findsNothing);

    await tester.tap(find.byTooltip('Limpiar busqueda'));
    await tester.pumpAndSettle();

    expect(find.text('Oliva'), findsOneWidget);
    expect(find.text('Mi custom'), findsOneWidget);
  });

  testWidgets('sorts spots by A-Z and Z-A', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SpotsPage())),
    );

    Future<void> addSpot(String name) async {
      await tester.tap(find.byTooltip('Agregar spot'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Nombre del spot'),
        name,
      );
      await tester.tap(find.text('Guardar spot'));
      await tester.pumpAndSettle();
    }

    await addSpot('Tarifa');
    await addSpot('Altea');

    await tester.tap(find.byKey(const Key('spots-sort-az')));
    await tester.pumpAndSettle();

    final azTitles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .toList();
    expect((azTitles.first.title as Text).data, 'Altea');

    await tester.tap(find.byKey(const Key('spots-sort-za')));
    await tester.pumpAndSettle();

    final zaTitles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .toList();
    expect((zaTitles.first.title as Text).data, 'Tarifa');
  });
}
