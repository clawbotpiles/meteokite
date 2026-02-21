import 'package:meteokite/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._remoteDataSource);

  final OpenMeteoWeatherRemoteDataSource _remoteDataSource;

  @override
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
  }) {
    return _remoteDataSource.getCurrentWind(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
