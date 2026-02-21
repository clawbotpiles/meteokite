import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/features/spots/weather/data/remote/open_meteo_weather_remote_data_source.dart';

class _CapturingAdapter implements HttpClientAdapter {
  String? path;
  Map<String, dynamic>? query;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    path = options.path;
    query = Map<String, dynamic>.from(options.queryParameters);

    return ResponseBody.fromString(
      jsonEncode({
        'current': {
          'wind_speed_10m': 14.5,
          'wind_gusts_10m': 20.0,
          'wind_direction_10m': 230,
          'time': '2026-02-21T19:40:00Z',
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('requests valid current variables for Open-Meteo', () async {
    final dio = Dio();
    final adapter = _CapturingAdapter();
    dio.httpClientAdapter = adapter;

    final dataSource = OpenMeteoWeatherRemoteDataSource(dio);
    await dataSource.getCurrentWind(latitude: 39.0, longitude: -0.1);

    expect(adapter.path, contains('/v1/forecast'));
    final currentParam = adapter.query?['current'] as String?;
    expect(currentParam, isNotNull);
    expect(currentParam!, contains('wind_speed_10m'));
    expect(currentParam, contains('wind_gusts_10m'));
    expect(currentParam, contains('wind_direction_10m'));
    expect(currentParam, isNot(contains('time')));
  });
}
