import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/notifications/local_notifications_service.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/profile/domain/services/wind_alert_activation_notifier.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/presentation/providers/weather_providers.dart';
import 'package:meteokite/shared/constants/spots.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/data_freshness_badge.dart';
import 'package:meteokite/shared/widgets/source_badge.dart';
import 'package:meteokite/shared/widgets/wind_condition.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  bool _isSyncingPreference = false;
  bool _didInitSourceSync = false;

  Future<void> _syncSourcePreferenceForSpot(SpotSeed spot) async {
    if (_isSyncingPreference) {
      return;
    }

    _isSyncingPreference = true;
    try {
      final actions = ref.read(weatherSourcePreferenceActionsProvider);
      final persisted = await actions.readForSpot(spot);
      if (!mounted) {
        return;
      }
      ref.read(selectedWeatherSourcePreferenceProvider.notifier).state =
          persisted;
      ref.invalidate(currentWindProvider);
    } finally {
      _isSyncingPreference = false;
    }
  }

  Set<int> _activeAlertIds(List<WindAlertEvaluationView> evaluations) {
    return evaluations
        .where((evaluation) => evaluation.isActive)
        .map((evaluation) => evaluation.alertId)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedSpot = ref.watch(selectedWeatherSpotProvider);
    final selectedSource = ref.watch(selectedWeatherSourcePreferenceProvider);
    final currentWind = ref.watch(currentWindProvider);
    final alertEvaluations = ref.watch(windAlertEvaluationsProvider);

    if (!_didInitSourceSync) {
      _didInitSourceSync = true;
      Future.microtask(() => _syncSourcePreferenceForSpot(selectedSpot));
    }

    ref.listen<SpotSeed>(selectedWeatherSpotProvider, (previous, next) {
      final changed =
          previous == null ||
          previous.latitude != next.latitude ||
          previous.longitude != next.longitude;
      if (changed) {
        _syncSourcePreferenceForSpot(next);
      }
    });

    ref.listen<AsyncValue<List<WindAlertEvaluationView>>>(
      windAlertEvaluationsProvider,
      (previous, next) {
        final previousSet = _activeAlertIds(previous?.valueOrNull ?? const []);
        final current = next.valueOrNull ?? const [];
        final currentSet = _activeAlertIds(current);

        final justActivated = newlyActivatedAlertIds(
          previousActiveIds: previousSet,
          currentActiveIds: currentSet,
        );

        if (justActivated.isEmpty) {
          return;
        }

        _notifyActiveAlertsIfNeeded(
          justActivatedAlertIds: justActivated,
          totalActiveAlerts: currentSet.length,
          spotName: selectedSpot.name,
          latestWind: ref.read(currentWindProvider).valueOrNull,
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Spots Weather')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Spot', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<SpotSeed>(
            initialValue: selectedSpot,
            decoration: const InputDecoration(labelText: 'Selecciona spot'),
            items: SpainInitialSpots.all
                .map(
                  (spot) => DropdownMenuItem<SpotSeed>(
                    value: spot,
                    child: Text('${spot.name} (${spot.province})'),
                  ),
                )
                .toList(),
            onChanged: (spot) {
              if (spot != null) {
                ref.read(selectedWeatherSpotProvider.notifier).state = spot;
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<WeatherSourcePreference>(
            initialValue: selectedSource,
            decoration: const InputDecoration(
              labelText: 'Proveedor meteo',
              helperText: 'Define estrategia de fallback por spot',
            ),
            items: const [
              DropdownMenuItem(
                value: WeatherSourcePreference.auto,
                child: Text('Auto (AEMET > Open-Meteo > cache)'),
              ),
              DropdownMenuItem(
                value: WeatherSourcePreference.aemetOnly,
                child: Text('Solo AEMET (si falla -> cache)'),
              ),
              DropdownMenuItem(
                value: WeatherSourcePreference.openMeteoOnly,
                child: Text('Solo Open-Meteo (si falla -> cache)'),
              ),
              DropdownMenuItem(
                value: WeatherSourcePreference.aemetFirst,
                child: Text('AEMET preferente (igual que Auto)'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref
                        .read(selectedWeatherSourcePreferenceProvider.notifier)
                        .state =
                    value;
                ref
                    .read(weatherSourcePreferenceActionsProvider)
                    .writeForSpot(spot: selectedSpot, preference: value);
                ref.invalidate(currentWindProvider);
              }
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          if (selectedSource != WeatherSourcePreference.auto)
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                const AlertBadge(
                  label: 'Preferencia personalizada activa',
                  level: AlertLevel.warning,
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(selectedWeatherSourcePreferenceProvider.notifier)
                        .state = WeatherSourcePreference
                        .auto;
                    ref
                        .read(weatherSourcePreferenceActionsProvider)
                        .writeForSpot(
                          spot: selectedSpot,
                          preference: WeatherSourcePreference.auto,
                        );
                    ref.invalidate(currentWindProvider);
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Restaurar Auto'),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.lg),
          currentWind.when(
            data: (wind) {
              final condition = WindCondition.fromSpeedKn(wind.speedKn);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      AlertBadge(
                        label: condition.label,
                        level: condition.level,
                      ),
                      SourceBadge(source: wind.source),
                      DataFreshnessBadge(timestamp: wind.timestamp),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(condition.guidance, style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Trazabilidad: ${wind.source}',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  WindCard(
                    title: 'Viento actual',
                    speedKn: wind.speedKn,
                    gustKn: wind.gustKn,
                    directionDeg: wind.directionDeg,
                    timestamp: wind.timestamp,
                    source: wind.source,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Estado de alertas', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  alertEvaluations.when(
                    data: (evaluations) {
                      if (evaluations.isEmpty) {
                        return const Text(
                          'No hay alertas configuradas en perfil.',
                        );
                      }

                      final active = evaluations
                          .where((e) => e.isActive)
                          .length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AlertBadge(
                            label: active > 0
                                ? '$active alerta(s) activa(s)'
                                : 'Sin alertas activas ahora',
                            level: active > 0
                                ? AlertLevel.warning
                                : AlertLevel.info,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ...evaluations
                              .take(3)
                              .map(
                                (evaluation) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.xs,
                                  ),
                                  child: Text(
                                    '${evaluation.summary} -> ${evaluation.reason}',
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: LinearProgressIndicator(),
                    ),
                    error: (error, stackTrace) => Text(
                      'No se pudo evaluar alertas: $error',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No se pudo obtener el viento actual.',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('$error', style: textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.tonal(
                  onPressed: () {
                    ref.invalidate(currentWindProvider);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () {
              ref.invalidate(currentWindProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar ahora'),
          ),
        ],
      ),
    );
  }

  Future<void> _notifyActiveAlertsIfNeeded({
    required Set<int> justActivatedAlertIds,
    required int totalActiveAlerts,
    required String spotName,
    required WindSnapshot? latestWind,
  }) async {
    final db = ref.read(localDatabaseProvider);
    final now = DateTime.now().toUtc();
    final eligibleAlertIds = <int>[];

    for (final alertId in justActivatedAlertIds) {
      final lastNotifiedAt = await db.readAlertLastNotifiedAt(alertId);
      final canNotify = shouldNotifyAlertActivation(
        now: now,
        lastNotifiedAt: lastNotifiedAt,
      );

      if (canNotify) {
        eligibleAlertIds.add(alertId);
      }
    }

    if (eligibleAlertIds.isEmpty || !mounted) {
      return;
    }

    final message = totalActiveAlerts == 1
        ? 'Alerta de viento activa ahora.'
        : '$totalActiveAlerts alertas de viento activas ahora.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

    await LocalNotificationsService.instance.showWindAlertActivation(
      activeAlerts: totalActiveAlerts,
      spotName: spotName,
    );

    for (final alertId in eligibleAlertIds) {
      await db.writeAlertLastNotifiedAt(alertId: alertId, at: now);
      if (latestWind != null) {
        await db.addAlertNotificationEvent(
          alertId: alertId,
          spotName: spotName,
          activatedAt: now,
          speedKn: latestWind.speedKn,
          directionDeg: latestWind.directionDeg,
          source: latestWind.source,
        );
      }
    }
  }
}
