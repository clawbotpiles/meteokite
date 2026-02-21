import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/network/dio_provider.dart';
import 'package:meteokite/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/data/repositories/weather_repository_impl.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';
import 'package:meteokite/features/spots/weather/domain/repositories/weather_repository.dart';
import 'package:meteokite/features/spots/weather/domain/usecases/get_spot_weather_usecase.dart';
import 'package:meteokite/shared/constants/spots.dart';

final selectedWeatherSpotProvider = StateProvider<SpotSeed>(
  (ref) => SpainInitialSpots.all.first,
);

final openMeteoWeatherRemoteDataSourceProvider =
    Provider<OpenMeteoWeatherRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return OpenMeteoWeatherRemoteDataSource(dio);
    });

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final remote = ref.watch(openMeteoWeatherRemoteDataSourceProvider);
  return WeatherRepositoryImpl(remote);
});

final getSpotWeatherUseCaseProvider = Provider<GetSpotWeatherUseCase>((ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetSpotWeatherUseCase(repository);
});

final currentWindProvider = FutureProvider<WindSnapshot>((ref) {
  final spot = ref.watch(selectedWeatherSpotProvider);
  final useCase = ref.watch(getSpotWeatherUseCaseProvider);

  return useCase(latitude: spot.latitude, longitude: spot.longitude);
});
