import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

abstract interface class WeatherRepository {
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
  });
}
