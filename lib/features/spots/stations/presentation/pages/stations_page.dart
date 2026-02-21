import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/spots/stations/presentation/providers/stations_providers.dart';
import 'package:meteokite/shared/widgets/station_card.dart';
import 'package:meteokite/shared/widgets/session_stats_card.dart';

class StationsPage extends ConsumerStatefulWidget {
  const StationsPage({super.key});

  @override
  ConsumerState<StationsPage> createState() => _StationsPageState();
}

class _StationsPageState extends ConsumerState<StationsPage> {
  static const _intervalOptions = <int>[5, 8, 15];

  Timer? _autoRefreshTimer;
  bool _autoRefreshEnabled = false;
  bool _isAutoTickRunning = false;
  int _autoRefreshSeconds = 8;

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _runTick() async {
    if (_isAutoTickRunning) {
      return;
    }

    final selectedStation = ref.read(selectedStationProvider);
    if (selectedStation == null) {
      return;
    }

    _isAutoTickRunning = true;
    try {
      final actions = ref.read(stationsActionsProvider);
      await actions.refreshStationTick(selectedStation.id);
      ref.invalidate(latestStationReadingProvider);
      ref.invalidate(stationHistoryProvider);
    } finally {
      _isAutoTickRunning = false;
    }
  }

  void _setAutoRefresh(bool enabled) {
    setState(() {
      _autoRefreshEnabled = enabled;
    });

    _autoRefreshTimer?.cancel();
    if (!enabled) {
      return;
    }

    _autoRefreshTimer = Timer.periodic(Duration(seconds: _autoRefreshSeconds), (
      _,
    ) {
      _runTick();
    });
  }

  void _setAutoRefreshInterval(int seconds) {
    setState(() {
      _autoRefreshSeconds = seconds;
    });

    if (_autoRefreshEnabled) {
      _setAutoRefresh(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final stationsState = ref.watch(stationsProvider);
    final selectedStation = ref.watch(selectedStationProvider);
    final latestReadingState = ref.watch(latestStationReadingProvider);
    final historyState = ref.watch(stationHistoryProvider);
    final historySummaryState = ref.watch(stationHistorySummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Spots Stations')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Estacion', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          stationsState.when(
            data: (stations) {
              if (stations.isEmpty) {
                return const Text('No hay estaciones disponibles');
              }

              final selectedId = selectedStation?.id ?? stations.first.id;
              return DropdownButtonFormField<int>(
                initialValue: selectedId,
                items: stations
                    .map(
                      (station) => DropdownMenuItem(
                        value: station.id,
                        child: Text('${station.name} (${station.province})'),
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  if (id != null) {
                    ref.read(selectedStationIdProvider.notifier).state = id;
                  }
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          const SizedBox(height: AppSpacing.lg),
          latestReadingState.when(
            data: (reading) {
              if (selectedStation == null || reading == null) {
                return const Text('Selecciona una estacion');
              }

              return StationCard(
                stationName: selectedStation.name,
                province: selectedStation.province,
                speedKn: reading.speedKn,
                gustKn: reading.gustKn,
                directionDeg: reading.directionDeg,
                timestamp: reading.timestamp,
                source: 'station-local',
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => Text('Error de lectura: $error'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: selectedStation == null
                ? null
                : () async {
                    await _runTick();
                  },
            icon: const Icon(Icons.refresh),
            label: const Text('Simular nueva lectura'),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            value: _autoRefreshEnabled,
            onChanged: selectedStation == null ? null : _setAutoRefresh,
            title: const Text('Auto-refresh demo'),
            subtitle: Text(
              'Genera una lectura cada $_autoRefreshSeconds segundos',
            ),
            contentPadding: EdgeInsets.zero,
          ),
          Row(
            children: [
              const Text('Intervalo:'),
              const SizedBox(width: AppSpacing.sm),
              DropdownButton<int>(
                value: _autoRefreshSeconds,
                items: _intervalOptions
                    .map(
                      (seconds) => DropdownMenuItem<int>(
                        value: seconds,
                        child: Text('${seconds}s'),
                      ),
                    )
                    .toList(),
                onChanged: selectedStation == null
                    ? null
                    : (seconds) {
                        if (seconds != null) {
                          _setAutoRefreshInterval(seconds);
                        }
                      },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Resumen rapido', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          historySummaryState.when(
            data: (summary) {
              final trendLabel = summary.trendDeltaKn.abs() < 0.1
                  ? 'Estable'
                  : summary.trendDeltaKn > 0
                  ? 'Subiendo'
                  : 'Bajando';

              return Column(
                children: [
                  SessionStatsCard(
                    title: 'Viento actual',
                    value: '${summary.latestSpeedKn.toStringAsFixed(1)} kn',
                    detail:
                        'Media ${summary.avgSpeedKn.toStringAsFixed(1)} kn | Tendencia $trendLabel',
                    icon: Icons.air,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SessionStatsCard(
                    title: 'Rango reciente',
                    value:
                        '${summary.minSpeedKn.toStringAsFixed(1)} - ${summary.maxSpeedKn.toStringAsFixed(1)} kn',
                    detail: 'Ultimas 12 muestras',
                    icon: Icons.show_chart,
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Text('Error de resumen: $error'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Historico (ultimas 12 muestras)', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          historyState.when(
            data: (history) {
              if (history.isEmpty) {
                return const Text('Sin historico disponible.');
              }

              final maxKn = history
                  .map((reading) => reading.speedKn)
                  .reduce((a, b) => a > b ? a : b);

              return Column(
                children: history
                    .map(
                      (reading) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                DateFormat('HH:mm').format(reading.timestamp),
                                style: textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: maxKn > 0 ? reading.speedKn / maxKn : 0,
                                minHeight: 10,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            SizedBox(
                              width: 56,
                              child: Text(
                                '${reading.speedKn.toStringAsFixed(1)} kn',
                                style: textTheme.bodySmall,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('Error de historico: $error'),
          ),
        ],
      ),
    );
  }
}
