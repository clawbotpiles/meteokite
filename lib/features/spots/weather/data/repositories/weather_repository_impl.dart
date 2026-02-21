import 'package:meteokite/features/spots/weather/data/local/weather_local_cache.dart';
import 'package:meteokite/features/spots/weather/data/remote/weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl({
    required WeatherRemoteDataSource openMeteo,
    required WeatherRemoteDataSource aemet,
    required WeatherLocalCache localCache,
  }) : _openMeteo = openMeteo,
       _aemet = aemet,
       _localCache = localCache;

  final WeatherRemoteDataSource _openMeteo;
  final WeatherRemoteDataSource _aemet;
  final WeatherLocalCache _localCache;

  @override
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
    WeatherSourcePreference preference = WeatherSourcePreference.auto,
  }) async {
    switch (preference) {
      case WeatherSourcePreference.aemetOnly:
        try {
          return await _fetchFromAemet(
            latitude: latitude,
            longitude: longitude,
          );
        } catch (error) {
          return _fetchFromCache(
            latitude: latitude,
            longitude: longitude,
            attemptedSources: {'aemet': error.toString()},
          );
        }

      case WeatherSourcePreference.openMeteoOnly:
        try {
          return await _fetchFromOpenMeteo(
            latitude: latitude,
            longitude: longitude,
          );
        } catch (error) {
          return _fetchFromCache(
            latitude: latitude,
            longitude: longitude,
            attemptedSources: {'open-meteo': error.toString()},
          );
        }

      case WeatherSourcePreference.auto:
      case WeatherSourcePreference.aemetFirst:
        try {
          return await _fetchFromAemet(
            latitude: latitude,
            longitude: longitude,
          );
        } catch (aemetError) {
          try {
            final fallback = await _fetchFromOpenMeteo(
              latitude: latitude,
              longitude: longitude,
            );
            return WindSnapshot(
              speedKn: fallback.speedKn,
              gustKn: fallback.gustKn,
              directionDeg: fallback.directionDeg,
              timestamp: fallback.timestamp,
              source: 'open-meteo(fallback:aemet)',
            );
          } catch (openMeteoError) {
            return _fetchFromCache(
              latitude: latitude,
              longitude: longitude,
              attemptedSources: {
                'aemet': aemetError.toString(),
                'open-meteo': openMeteoError.toString(),
              },
            );
          }
        }
    }
  }

  Future<WindSnapshot> _fetchFromAemet({
    required double latitude,
    required double longitude,
  }) async {
    if (!_aemet.isConfigured) {
      throw StateError('AEMET not configured');
    }
    final snapshot = await _aemet.getCurrentWind(
      latitude: latitude,
      longitude: longitude,
    );
    await _localCache.save(
      latitude: latitude,
      longitude: longitude,
      snapshot: snapshot,
    );
    return snapshot;
  }

  Future<WindSnapshot> _fetchFromOpenMeteo({
    required double latitude,
    required double longitude,
  }) async {
    final snapshot = await _openMeteo.getCurrentWind(
      latitude: latitude,
      longitude: longitude,
    );
    await _localCache.save(
      latitude: latitude,
      longitude: longitude,
      snapshot: snapshot,
    );
    return snapshot;
  }

  Future<WindSnapshot> _fetchFromCache({
    required double latitude,
    required double longitude,
    Map<String, String> attemptedSources = const {},
  }) async {
    final cached = await _localCache.read(
      latitude: latitude,
      longitude: longitude,
    );
    if (cached != null) {
      return WindSnapshot(
        speedKn: cached.speedKn,
        gustKn: cached.gustKn,
        directionDeg: cached.directionDeg,
        timestamp: cached.timestamp,
        source: 'cache:${cached.source}',
      );
    }

    final details = attemptedSources.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' | ');

    if (details.isEmpty) {
      throw StateError('No weather source available and cache empty');
    }

    throw StateError('No weather source available and cache empty | $details');
  }
}
