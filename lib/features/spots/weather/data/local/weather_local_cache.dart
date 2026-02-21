import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

abstract interface class WeatherLocalCache {
  Future<void> save({
    required double latitude,
    required double longitude,
    required WindSnapshot snapshot,
  });

  Future<WindSnapshot?> read({
    required double latitude,
    required double longitude,
  });
}
