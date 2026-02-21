import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/spots/weather/presentation/providers/weather_providers.dart';
import 'package:meteokite/shared/constants/spots.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/wind_condition.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final selectedSpot = ref.watch(selectedWeatherSpotProvider);
    final currentWind = ref.watch(currentWindProvider);

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
          const SizedBox(height: AppSpacing.lg),
          currentWind.when(
            data: (wind) {
              final condition = WindCondition.fromSpeedKn(wind.speedKn);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AlertBadge(label: condition.label, level: condition.level),
                  const SizedBox(height: AppSpacing.xs),
                  Text(condition.guidance, style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.sm),
                  WindCard(
                    title: 'Viento actual',
                    speedKn: wind.speedKn,
                    gustKn: wind.gustKn,
                    directionDeg: wind.directionDeg,
                    timestamp: wind.timestamp,
                    source: wind.source,
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
}
