import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/entities/weather_source_preference.dart';
import 'package:meteokite/features/spots/weather/domain/repositories/weather_repository.dart';

class GetSpotWeatherUseCase {
  const GetSpotWeatherUseCase(this._repository);

  final WeatherRepository _repository;

  Future<WindSnapshot> call({
    required double latitude,
    required double longitude,
    WeatherSourcePreference preference = WeatherSourcePreference.auto,
  }) {
    return _repository.getCurrentWind(
      latitude: latitude,
      longitude: longitude,
      preference: preference,
    );
  }
}
