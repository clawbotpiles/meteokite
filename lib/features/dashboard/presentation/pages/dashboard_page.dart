import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/sessions/presentation/providers/sessions_providers.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';
import 'package:meteokite/features/spots/weather/presentation/providers/weather_providers.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/session_stats_card.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';
import 'package:meteokite/shared/widgets/wind_quality.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  _NavigabilitySignal _buildSignal(double speedKn, double gustKn, DateTime ts) {
    final quality = WindQuality.fromSpeedAndGust(
      speedKn: speedKn,
      gustKn: gustKn,
    );
    final ageMinutes = DateTime.now().toUtc().difference(ts.toUtc()).inMinutes;

    if (ageMinutes > 180 ||
        quality.level == AlertLevel.critical ||
        speedKn < 10 ||
        speedKn > 35) {
      return const _NavigabilitySignal(
        label: 'Rojo',
        detail: 'Condicion exigente o dato muy antiguo',
        level: AlertLevel.critical,
      );
    }

    if (ageMinutes > 60 ||
        quality.level == AlertLevel.warning ||
        speedKn < 14 ||
        speedKn > 30) {
      return const _NavigabilitySignal(
        label: 'Ambar',
        detail: 'Navegable con precaucion y chequeo frecuente',
        level: AlertLevel.warning,
      );
    }

    return const _NavigabilitySignal(
      label: 'Verde',
      detail: 'Ventana estable para navegar',
      level: AlertLevel.info,
    );
  }

  _SystemStatus _buildSystemStatus(String source, DateTime timestamp) {
    final now = DateTime.now().toUtc();
    final ageMinutes = now.difference(timestamp.toUtc()).inMinutes;
    final isCache = source.toLowerCase().startsWith('cache:');
    final isFallback = source.toLowerCase().contains('fallback');

    final freshness = ageMinutes <= 10
        ? 'Reciente'
        : ageMinutes <= 60
        ? 'Intermedia'
        : 'Antigua';

    return _SystemStatus(
      sourceLabel: source,
      freshnessLabel: freshness,
      ageMinutes: ageMinutes,
      isCache: isCache,
      isFallback: isFallback,
      statusLevel: isCache || ageMinutes > 60
          ? AlertLevel.warning
          : AlertLevel.info,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final sessionsSummaryState = ref.watch(sessionsSummaryProvider);
    final currentWindState = ref.watch(currentWindProvider);
    final selectedSpot = ref.watch(selectedWeatherSpotProvider);
    final selectedSource = ref.watch(selectedWeatherSourcePreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MeteoKite')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Resumen del viento y el mar', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Panel tecnico para decidir si salir al agua hoy.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          if (selectedSource != WeatherSourcePreference.auto)
            AlertBadge(
              label: 'Proveedor personalizado en ${selectedSpot.name}',
              level: AlertLevel.warning,
            ),
          if (selectedSource != WeatherSourcePreference.auto) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () async {
                  ref
                      .read(selectedWeatherSourcePreferenceProvider.notifier)
                      .state = WeatherSourcePreference
                      .auto;
                  await ref
                      .read(weatherSourcePreferenceActionsProvider)
                      .writeForSpot(
                        spot: selectedSpot,
                        preference: WeatherSourcePreference.auto,
                      );
                  ref.invalidate(currentWindProvider);
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Restaurar Auto en este spot'),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          currentWindState.when(
            data: (wind) {
              final signal = _buildSignal(
                wind.speedKn,
                wind.gustKn,
                wind.timestamp,
              );
              return SessionStatsCard(
                title: 'Semaforo de navegabilidad',
                value: signal.label,
                detail: signal.detail,
                icon: Icons.traffic,
                trailing: AlertBadge(label: signal.label, level: signal.level),
              );
            },
            loading: () => const SessionStatsCard(
              title: 'Semaforo de navegabilidad',
              value: 'Calculando...',
              detail: 'Esperando lectura de viento',
              icon: Icons.traffic,
            ),
            error: (error, stackTrace) => SessionStatsCard(
              title: 'Semaforo de navegabilidad',
              value: 'Sin lectura',
              detail: '$error',
              icon: Icons.warning_amber,
            ),
          ),
          const SizedBox(height: 12),
          currentWindState.when(
            data: (wind) {
              final status = _buildSystemStatus(wind.source, wind.timestamp);
              final detail = StringBuffer()
                ..write(
                  'Fuente ${status.sourceLabel} | ${status.ageMinutes} min | ${status.freshnessLabel}',
                );
              if (status.isCache) {
                detail.write(' | cache');
              }
              if (status.isFallback) {
                detail.write(' | fallback');
              }

              return SessionStatsCard(
                title: 'Estado del sistema',
                value: status.freshnessLabel,
                detail: detail.toString(),
                icon: Icons.cloud_done_outlined,
                trailing: AlertBadge(
                  label: status.isCache ? 'Cache' : 'Live',
                  level: status.statusLevel,
                ),
              );
            },
            loading: () => const SessionStatsCard(
              title: 'Estado del sistema',
              value: 'Sincronizando...',
              detail: 'Esperando primera lectura',
              icon: Icons.cloud_sync,
            ),
            error: (error, stackTrace) => SessionStatsCard(
              title: 'Estado del sistema',
              value: 'Error de sync',
              detail: '$error',
              icon: Icons.cloud_off,
            ),
          ),
          const SizedBox(height: 12),
          currentWindState.when(
            data: (wind) => WindCard(
              title: 'Viento actual',
              speedKn: wind.speedKn,
              gustKn: wind.gustKn,
              directionDeg: wind.directionDeg,
              timestamp: wind.timestamp,
              source: wind.source,
            ),
            loading: () => const SessionStatsCard(
              title: 'Viento actual',
              value: 'Cargando...',
              detail: 'Consultando proveedor meteo',
              icon: Icons.air,
            ),
            error: (error, stackTrace) => SessionStatsCard(
              title: 'Viento actual',
              value: 'No disponible',
              detail: '$error',
              icon: Icons.warning_amber,
            ),
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
                onPressed: () => context.go(AppRoutes.spotsWeather),
                icon: const Icon(Icons.air),
                label: const Text('Meteo spot'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.spotsStations),
                icon: const Icon(Icons.sensors),
                label: const Text('Estaciones'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.sessionsHome),
                icon: const Icon(Icons.fiber_manual_record),
                label: const Text('Ir a grabar'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.go(AppRoutes.profileHome),
                icon: const Icon(Icons.person_outline),
                label: const Text('Perfil'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavigabilitySignal {
  const _NavigabilitySignal({
    required this.label,
    required this.detail,
    required this.level,
  });

  final String label;
  final String detail;
  final AlertLevel level;
}

class _SystemStatus {
  const _SystemStatus({
    required this.sourceLabel,
    required this.freshnessLabel,
    required this.ageMinutes,
    required this.isCache,
    required this.isFallback,
    required this.statusLevel,
  });

  final String sourceLabel;
  final String freshnessLabel;
  final int ageMinutes;
  final bool isCache;
  final bool isFallback;
  final AlertLevel statusLevel;
}
