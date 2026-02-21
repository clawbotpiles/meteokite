import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/features/spots/weather/data/remote/weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

class AemetWeatherRemoteDataSource implements WeatherRemoteDataSource {
  const AemetWeatherRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  bool get isConfigured =>
      EnvConfig.aemetBaseUrl.isNotEmpty && EnvConfig.aemetApiKey.isNotEmpty;

  @override
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
  }) async {
    if (!isConfigured) {
      throw StateError('AEMET is not configured');
    }

    final metadata = await _dio.get<Map<String, dynamic>>(
      '${EnvConfig.aemetBaseUrl}/opendata/api/observacion/convencional/todas',
      queryParameters: {'api_key': EnvConfig.aemetApiKey},
    );

    final metadataPayload = metadata.data;
    final dataUrl = metadataPayload?['datos'] as String?;
    if (dataUrl == null || dataUrl.isEmpty) {
      throw StateError('Invalid AEMET metadata response');
    }

    final dataResponse = await _dio.get<dynamic>(dataUrl);
    final data = dataResponse.data;
    if (data is! List) {
      throw StateError('Invalid AEMET observations payload');
    }

    Map<String, dynamic>? best;
    double bestScore = double.negativeInfinity;
    for (final item in data) {
      if (item is! Map) {
        continue;
      }

      final obs = Map<String, dynamic>.from(item);
      final speedRaw = _toDouble(obs['vv'] ?? obs['viento'] ?? obs['v']);
      final directionRaw = _toInt(obs['dv'] ?? obs['dir']);
      if (speedRaw == null || directionRaw == null) {
        continue;
      }

      final currentTs = _parseTimestamp(obs['fint'] ?? obs['fecha']);
      final lat = _toDouble(obs['lat']);
      final lon = _toDouble(obs['lon'] ?? obs['lng'] ?? obs['longitud']);
      final distance = lat != null && lon != null
          ? _distance(latitude, longitude, lat, lon)
          : 400;
      final recencyBoost = currentTs == null
          ? 0.0
          : currentTs.millisecondsSinceEpoch / 10000000000.0;
      final score = recencyBoost - distance;

      if (best == null || score > bestScore) {
        best = obs;
        bestScore = score;
      }
    }

    if (best == null) {
      throw StateError('No valid AEMET wind observation found');
    }

    final speedRaw = _toDouble(best['vv'] ?? best['viento'] ?? best['v']);
    final gustRaw = _toDouble(best['vx'] ?? best['racha'] ?? best['gust']);
    final direction = _toInt(best['dv'] ?? best['dir']);
    final timestamp =
        _parseTimestamp(best['fint'] ?? best['fecha']) ?? DateTime.now();

    if (speedRaw == null || direction == null) {
      throw StateError('AEMET wind fields are missing');
    }

    final speedKn = _toKnots(speedRaw);
    final gustKn = _toKnots(gustRaw ?? speedRaw);

    return WindSnapshot(
      speedKn: speedKn,
      gustKn: gustKn,
      directionDeg: direction,
      timestamp: timestamp.toUtc(),
      source: 'aemet',
    );
  }

  double _toKnots(double raw) {
    if (raw > 45) {
      return raw * 0.539957;
    }
    return raw * 1.94384;
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.'));
    }
    return null;
  }

  int? _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  DateTime? _parseTimestamp(dynamic value) {
    if (value is! String) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  double _distance(double latA, double lonA, double latB, double lonB) {
    final dLat = latA - latB;
    final dLon = lonA - lonB;
    return math.sqrt(dLat * dLat + dLon * dLon);
  }
}
