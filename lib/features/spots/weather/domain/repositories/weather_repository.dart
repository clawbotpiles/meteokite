import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';

abstract interface class WeatherRepository {
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
    WeatherSourcePreference preference = WeatherSourcePreference.auto,
  });
}
