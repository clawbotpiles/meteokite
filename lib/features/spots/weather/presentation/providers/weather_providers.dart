import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart' as ldb;
import 'package:meteokite/core/network/dio_provider.dart';
import 'package:meteokite/features/profile/domain/services/wind_alert_evaluator.dart';
import 'package:meteokite/features/profile/presentation/providers/wind_alerts_provider.dart';
import 'package:meteokite/features/spots/weather/data/local/drift_weather_local_cache.dart';
import 'package:meteokite/features/spots/weather/data/local/weather_local_cache.dart';
import 'package:meteokite/features/spots/weather/data/remote/aemet_weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/data/repositories/weather_repository_impl.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/repositories/weather_repository.dart';
import 'package:meteokite/features/spots/weather/domain/usecases/get_spot_weather_usecase.dart';
import 'package:meteokite/shared/constants/spots.dart';

final selectedWeatherSpotProvider = StateProvider<SpotSeed>(
  (ref) => SpainInitialSpots.all.first,
);

final selectedWeatherSourcePreferenceProvider =
    StateProvider<WeatherSourcePreference>((ref) {
      return WeatherSourcePreference.auto;
    });

final weatherSourcePreferenceActionsProvider =
    Provider<WeatherSourcePreferenceActions>((ref) {
      final db = ref.watch(localDatabaseProvider);
      return WeatherSourcePreferenceActions(db);
    });

final openMeteoWeatherRemoteDataSourceProvider =
    Provider<OpenMeteoWeatherRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return OpenMeteoWeatherRemoteDataSource(dio);
    });

final aemetWeatherRemoteDataSourceProvider =
    Provider<AemetWeatherRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return AemetWeatherRemoteDataSource(dio);
    });

final weatherLocalCacheProvider = Provider<WeatherLocalCache>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return DriftWeatherLocalCache(db);
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final openMeteo = ref.watch(openMeteoWeatherRemoteDataSourceProvider);
  final aemet = ref.watch(aemetWeatherRemoteDataSourceProvider);
  final localCache = ref.watch(weatherLocalCacheProvider);
  return WeatherRepositoryImpl(
    openMeteo: openMeteo,
    aemet: aemet,
    localCache: localCache,
  );
});

final getSpotWeatherUseCaseProvider = Provider<GetSpotWeatherUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetSpotWeatherUseCase(repository);
});

final currentWindProvider = FutureProvider<WindSnapshot>((ref) {
  final spot = ref.watch(selectedWeatherSpotProvider);
  final useCase = ref.watch(getSpotWeatherUseCaseProvider);
  final preference = ref.watch(selectedWeatherSourcePreferenceProvider);

  return useCase(
    latitude: spot.latitude,
    longitude: spot.longitude,
    preference: preference,
  );
});

class WindAlertEvaluationView {
  const WindAlertEvaluationView({
    required this.alertId,
    required this.summary,
    required this.isActive,
    required this.reason,
  });

  final int alertId;
  final String summary;
  final bool isActive;
  final String reason;
}

final windAlertEvaluationsProvider =
    Provider<AsyncValue<List<WindAlertEvaluationView>>>((ref) {
      final alertsState = ref.watch(windAlertsProvider);
      final windState = ref.watch(currentWindProvider);

      if (alertsState.isLoading || windState.isLoading) {
        return const AsyncLoading();
      }

      if (alertsState.hasError) {
        return AsyncError(alertsState.error!, alertsState.stackTrace!);
      }

      if (windState.hasError) {
        return AsyncError(windState.error!, windState.stackTrace!);
      }

      final alerts = alertsState.valueOrNull ?? const [];
      final wind = windState.valueOrNull;
      if (wind == null) {
        return const AsyncData([]);
      }

      final evaluations = alerts.map((alert) {
        final summary =
            '${alert.minSpeedKn.toStringAsFixed(0)}-${alert.maxSpeedKn.toStringAsFixed(0)} kn | ${alert.directionMinDeg}°-${alert.directionMaxDeg}° | ${alert.startHour}:00-${alert.endHour}:00';

        if (!alert.enabled) {
          return WindAlertEvaluationView(
            alertId: alert.id,
            summary: summary,
            isActive: false,
            reason: 'Desactivada',
          );
        }

        final result = evaluateWindAlertRule(
          wind: wind,
          minSpeedKn: alert.minSpeedKn,
          maxSpeedKn: alert.maxSpeedKn,
          directionMinDeg: alert.directionMinDeg,
          directionMaxDeg: alert.directionMaxDeg,
          startHour: alert.startHour,
          endHour: alert.endHour,
        );

        return WindAlertEvaluationView(
          alertId: alert.id,
          summary: summary,
          isActive: result.matches,
          reason: result.reason,
        );
      }).toList();

      return AsyncData(evaluations);
    });

class WeatherSourcePreferenceActions {
  const WeatherSourcePreferenceActions(this._db);

  final ldb.LocalDatabase _db;

  Future<WeatherSourcePreference> readForSpot(SpotSeed spot) async {
    final raw = await _db.readWeatherSourcePreference(
      latitude: spot.latitude,
      longitude: spot.longitude,
    );
    return _decodePreference(raw);
  }

  Future<void> writeForSpot({
    required SpotSeed spot,
    required WeatherSourcePreference preference,
  }) {
    return _db.writeWeatherSourcePreference(
      latitude: spot.latitude,
      longitude: spot.longitude,
      preference: _encodePreference(preference),
    );
  }

  String _encodePreference(WeatherSourcePreference preference) {
    return preference.name;
  }

  WeatherSourcePreference _decodePreference(String? raw) {
    switch (raw) {
      case 'aemetFirst':
        return WeatherSourcePreference.aemetFirst;
      case 'aemetOnly':
        return WeatherSourcePreference.aemetOnly;
      case 'openMeteoOnly':
        return WeatherSourcePreference.openMeteoOnly;
      case 'auto':
      default:
        return WeatherSourcePreference.auto;
    }
  }
}
