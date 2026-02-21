import 'package:dio/dio.dart';
import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

class OpenMeteoWeatherRemoteDataSource {
  const OpenMeteoWeatherRemoteDataSource(this._dio);

  final Dio _dio;

  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
  }) async {
    final baseUrl = EnvConfig.openMeteoBaseUrl.isEmpty
        ? 'https://api.open-meteo.com'
        : EnvConfig.openMeteoBaseUrl;

    final response = await _dio.get<Map<String, dynamic>>(
      '$baseUrl/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'wind_speed_10m,wind_gusts_10m,wind_direction_10m,time',
        'wind_speed_unit': 'kn',
      },
    );

    final data = response.data;
    if (data == null || data['current'] is! Map<String, dynamic>) {
      throw StateError('Invalid Open-Meteo response');
    }

    final current = data['current']! as Map<String, dynamic>;
    final speed = (current['wind_speed_10m'] as num?)?.toDouble();
    final gust = (current['wind_gusts_10m'] as num?)?.toDouble();
    final direction = (current['wind_direction_10m'] as num?)?.toInt();
    final timeRaw = current['time'] as String?;

    if (speed == null || gust == null || direction == null || timeRaw == null) {
      throw StateError('Missing wind fields from Open-Meteo');
    }

    return WindSnapshot(
      speedKn: speed,
      gustKn: gust,
      directionDeg: direction,
      timestamp: DateTime.tryParse(timeRaw)?.toUtc() ?? DateTime.now().toUtc(),
      source: 'open-meteo',
    );
  }
}
