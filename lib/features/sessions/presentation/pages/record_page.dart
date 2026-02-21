import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/theme/app_spacing.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grabar sesion')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Modo grabacion',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Inicia tu sesion en vivo por GPS o abre el panel completo de sesiones.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.sessionsHome),
            icon: const Icon(Icons.fiber_manual_record),
            label: const Text('Abrir grabacion y sesiones'),
          ),
        ],
      ),
    );
  }
}
