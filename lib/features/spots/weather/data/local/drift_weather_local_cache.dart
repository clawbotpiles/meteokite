import 'package:meteokite/core/storage/local_database.dart';
import 'package:meteokite/features/spots/weather/data/local/weather_local_cache.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

class DriftWeatherLocalCache implements WeatherLocalCache {
  const DriftWeatherLocalCache(this._db);

  final LocalDatabase _db;

  @override
  Future<void> save({
    required double latitude,
    required double longitude,
    required WindSnapshot snapshot,
  }) {
    return _db.upsertWeatherSnapshot(
      latitude: latitude,
      longitude: longitude,
      timestamp: snapshot.timestamp,
      speedKn: snapshot.speedKn,
      gustKn: snapshot.gustKn,
      directionDeg: snapshot.directionDeg,
      source: snapshot.source,
    );
  }

  @override
  Future<WindSnapshot?> read({
    required double latitude,
    required double longitude,
  }) async {
    final row = await _db.getWeatherSnapshot(
      latitude: latitude,
      longitude: longitude,
    );
    if (row == null) {
      return null;
    }

    return WindSnapshot(
      speedKn: row.speedKn,
      gustKn: row.gustKn,
      directionDeg: row.directionDeg,
      timestamp: row.timestamp,
      source: row.source,
    );
  }
}
