import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({
    super.key,
    required this.title,
    required this.deviceName,
    required this.endedAt,
    required this.durationLabel,
    required this.summary,
  });

  final String title;
  final String deviceName;
  final DateTime endedAt;
  final String durationLabel;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de sesion')),
      body: ScrollConfiguration(
        behavior: const _NoStretchScrollBehavior(),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${endedAt.day.toString().padLeft(2, '0')}/${endedAt.month.toString().padLeft(2, '0')} ${endedAt.hour.toString().padLeft(2, '0')}:${endedAt.minute.toString().padLeft(2, '0')}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.watch_rounded, size: 16),
                          label: Text(deviceName),
                        ),
                        Chip(
                          avatar: const Icon(Icons.timer_rounded, size: 16),
                          label: Text(durationLabel),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumen', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(summary, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metricas (placeholder)',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Aqui iran los detalles completos de la sesion: saltos, velocidad maxima, distancia, tiempo planeando, bateria del dispositivo y eventos.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
