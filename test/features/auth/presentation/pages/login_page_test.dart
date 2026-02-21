import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteokitev2_0/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('login page shows main actions from v1.0', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginPage())),
    );

    expect(find.text('Bienvenido a MeteoKite'), findsOneWidget);
    expect(find.text('Continuar con email'), findsOneWidget);
    expect(find.textContaining('Google'), findsOneWidget);
    expect(find.textContaining('Apple'), findsOneWidget);
    expect(find.text('Entrar con DEV BYPASS'), findsOneWidget);
  });
}
