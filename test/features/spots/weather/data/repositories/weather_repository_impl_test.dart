import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/features/spots/weather/data/local/weather_local_cache.dart';
import 'package:meteokite/features/spots/weather/data/remote/weather_remote_data_source.dart';
import 'package:meteokite/features/spots/weather/data/repositories/weather_repository_impl.dart';
import 'package:meteokite/features/spots/weather/domain/entities/wind_snapshot.dart';

class _FakeRemoteDataSource implements WeatherRemoteDataSource {
  _FakeRemoteDataSource({
    required this.isConfigured,
    this.snapshot,
    this.shouldThrow = false,
  });

  @override
  final bool isConfigured;
  final WindSnapshot? snapshot;
  final bool shouldThrow;

  @override
  Future<WindSnapshot> getCurrentWind({
    required double latitude,
    required double longitude,
  }) async {
    if (shouldThrow) {
      throw StateError('remote failure');
    }
    return snapshot!;
  }
}

class _FakeWeatherLocalCache implements WeatherLocalCache {
  WindSnapshot? value;

  @override
  Future<WindSnapshot?> read({
    required double latitude,
    required double longitude,
  }) async {
    return value;
  }

  @override
  Future<void> save({
    required double latitude,
    required double longitude,
    required WindSnapshot snapshot,
  }) async {
    value = snapshot;
  }
}

void main() {
  final openMeteoSnapshot = WindSnapshot(
    speedKn: 15,
    gustKn: 20,
    directionDeg: 240,
    timestamp: DateTime(2026, 1, 1),
    source: 'open-meteo',
  );

  final aemetSnapshot = WindSnapshot(
    speedKn: 18,
    gustKn: 24,
    directionDeg: 230,
    timestamp: DateTime(2026, 1, 1),
    source: 'aemet',
  );

  test('uses AEMET when configured and available', () async {
    final cache = _FakeWeatherLocalCache();
    final repository = WeatherRepositoryImpl(
      openMeteo: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: openMeteoSnapshot,
      ),
      aemet: _FakeRemoteDataSource(isConfigured: true, snapshot: aemetSnapshot),
      localCache: cache,
    );

    final result = await repository.getCurrentWind(
      latitude: 39.0,
      longitude: -0.1,
    );

    expect(result.source, 'aemet');
  });

  test('falls back to Open-Meteo when AEMET fails', () async {
    final cache = _FakeWeatherLocalCache();
    final repository = WeatherRepositoryImpl(
      openMeteo: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: openMeteoSnapshot,
      ),
      aemet: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: aemetSnapshot,
        shouldThrow: true,
      ),
      localCache: cache,
    );

    final result = await repository.getCurrentWind(
      latitude: 39.0,
      longitude: -0.1,
    );

    expect(result.source, contains('open-meteo'));
  });

  test('uses Open-Meteo when AEMET is not configured', () async {
    final cache = _FakeWeatherLocalCache();
    final repository = WeatherRepositoryImpl(
      openMeteo: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: openMeteoSnapshot,
      ),
      aemet: _FakeRemoteDataSource(
        isConfigured: false,
        snapshot: aemetSnapshot,
      ),
      localCache: cache,
    );

    final result = await repository.getCurrentWind(
      latitude: 39.0,
      longitude: -0.1,
    );

    expect(result.source, contains('open-meteo'));
  });

  test('falls back to cache when all remotes fail', () async {
    final cache = _FakeWeatherLocalCache()
      ..value = WindSnapshot(
        speedKn: 17,
        gustKn: 22,
        directionDeg: 235,
        timestamp: DateTime(2026, 1, 2),
        source: 'aemet',
      );

    final repository = WeatherRepositoryImpl(
      openMeteo: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: openMeteoSnapshot,
        shouldThrow: true,
      ),
      aemet: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: aemetSnapshot,
        shouldThrow: true,
      ),
      localCache: cache,
    );

    final result = await repository.getCurrentWind(
      latitude: 39.0,
      longitude: -0.1,
    );

    expect(result.source, 'cache:aemet');
    expect(result.speedKn, 17);
  });

  test('includes source errors when remotes fail and cache is empty', () async {
    final cache = _FakeWeatherLocalCache();

    final repository = WeatherRepositoryImpl(
      openMeteo: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: openMeteoSnapshot,
        shouldThrow: true,
      ),
      aemet: _FakeRemoteDataSource(
        isConfigured: true,
        snapshot: aemetSnapshot,
        shouldThrow: true,
      ),
      localCache: cache,
    );

    expect(
      () => repository.getCurrentWind(latitude: 39.0, longitude: -0.1),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('No weather source available and cache empty'),
            contains('aemet:'),
            contains('open-meteo:'),
          ),
        ),
      ),
    );
  });
}
