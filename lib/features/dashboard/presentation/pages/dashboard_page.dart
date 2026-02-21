import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/theme/app_colors.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/sessions/presentation/providers/sessions_providers.dart';
import 'package:meteokite/shared/widgets/session_stats_card.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final mkColors = context.mkColors;
    final sessionsSummaryState = ref.watch(sessionsSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MeteoKite')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Resumen del viento y el mar', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Base inicial del proyecto. Aqui conectaremos el pronostico real.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              Chip(
                label: const Text('Wind low'),
                backgroundColor: mkColors.windLow.withValues(alpha: 0.2),
              ),
              Chip(
                label: const Text('Wind mid'),
                backgroundColor: mkColors.windMid.withValues(alpha: 0.2),
              ),
              Chip(
                label: const Text('Wind strong'),
                backgroundColor: mkColors.windStrong.withValues(alpha: 0.2),
              ),
              Chip(
                label: const Text('Accent'),
                backgroundColor: mkColors.accent.withValues(alpha: 0.2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SessionStatsCard(
            title: 'Viento',
            value: '-- kn',
            detail: 'Direccion --',
            icon: Icons.air,
          ),
          const SizedBox(height: 12),
          SessionStatsCard(
            title: 'Oleaje',
            value: '-- m',
            detail: 'Periodo -- s',
            icon: Icons.waves,
          ),
          const SizedBox(height: 12),
          SessionStatsCard(
            title: 'Lluvia',
            value: '-- mm',
            detail: 'Probabilidad -- %',
            icon: Icons.grain,
          ),
          const SizedBox(height: AppSpacing.sm),
          WindCard(
            title: 'Viento actual (demo)',
            speedKn: 15.8,
            gustKn: 20.4,
            directionDeg: 248,
            timestamp: DateTime.now(),
            source: 'simulado',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Resumen de sesiones', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          sessionsSummaryState.when(
            data: (summary) {
              return Column(
                children: [
                  SessionStatsCard(
                    title: 'Total distancia',
                    value: '${summary.totalDistanceKm.toStringAsFixed(1)} km',
                    detail: 'Acumulado local',
                    icon: Icons.straighten,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SessionStatsCard(
                    title: 'Mejor velocidad',
                    value: '${summary.bestSpeedKn.toStringAsFixed(1)} kn',
                    detail: 'Pico maximo registrado',
                    icon: Icons.speed,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SessionStatsCard(
                    title: 'Sesiones del mes',
                    value: '${summary.monthSessions}',
                    detail: 'Mes actual',
                    icon: Icons.calendar_month,
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => SessionStatsCard(
              title: 'Resumen de sesiones',
              value: 'Sin datos',
              detail: '$error',
              icon: Icons.warning_amber,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Accesos rapidos', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.profileHome),
                icon: const Icon(Icons.person_outline),
                label: const Text('Profile'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.spotsWeather),
                icon: const Icon(Icons.air),
                label: const Text('Weather'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.spotsStations),
                icon: const Icon(Icons.sensors),
                label: const Text('Stations'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.sessionsHome),
                icon: const Icon(Icons.route),
                label: const Text('Sessions'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              minimumSize: const Size(44, 44),
            ),
            icon: const Icon(Icons.navigation),
            label: const Text('Comenzar sesion'),
          ),
        ],
      ),
    );
  }
}
