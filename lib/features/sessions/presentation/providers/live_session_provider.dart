import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LiveSessionState {
  const LiveSessionState({
    required this.isTracking,
    required this.startedAt,
    required this.distanceKm,
    required this.currentSpeedKn,
    required this.maxSpeedKn,
    required this.elapsed,
    required this.error,
    required this.hasSignal,
  });

  final bool isTracking;
  final DateTime? startedAt;
  final double distanceKm;
  final double currentSpeedKn;
  final double maxSpeedKn;
  final Duration elapsed;
  final String? error;
  final bool hasSignal;

  static const empty = LiveSessionState(
    isTracking: false,
    startedAt: null,
    distanceKm: 0,
    currentSpeedKn: 0,
    maxSpeedKn: 0,
    elapsed: Duration.zero,
    error: null,
    hasSignal: false,
  );

  LiveSessionState copyWith({
    bool? isTracking,
    DateTime? startedAt,
    double? distanceKm,
    double? currentSpeedKn,
    double? maxSpeedKn,
    Duration? elapsed,
    String? error,
    bool? hasSignal,
  }) {
    return LiveSessionState(
      isTracking: isTracking ?? this.isTracking,
      startedAt: startedAt ?? this.startedAt,
      distanceKm: distanceKm ?? this.distanceKm,
      currentSpeedKn: currentSpeedKn ?? this.currentSpeedKn,
      maxSpeedKn: maxSpeedKn ?? this.maxSpeedKn,
      elapsed: elapsed ?? this.elapsed,
      error: error,
      hasSignal: hasSignal ?? this.hasSignal,
    );
  }
}

class LiveSessionSnapshot {
  const LiveSessionSnapshot({
    required this.durationMinutes,
    required this.distanceKm,
    required this.avgSpeedKn,
    required this.maxSpeedKn,
  });

  final int durationMinutes;
  final double distanceKm;
  final double avgSpeedKn;
  final double maxSpeedKn;
}

class LiveSessionNotifier extends AutoDisposeNotifier<LiveSessionState> {
  StreamSubscription<Position>? _positionSub;
  Timer? _ticker;
  Position? _lastPosition;
  DateTime? _lastSignalAt;

  @override
  LiveSessionState build() {
    ref.onDispose(() async {
      await _positionSub?.cancel();
      _ticker?.cancel();
    });
    return LiveSessionState.empty;
  }

  Future<void> start() async {
    if (state.isTracking) {
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(error: 'Activa ubicacion del dispositivo.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = state.copyWith(error: 'Permiso de ubicacion denegado.');
      return;
    }

    state = LiveSessionState(
      isTracking: true,
      startedAt: DateTime.now().toUtc(),
      distanceKm: 0,
      currentSpeedKn: 0,
      maxSpeedKn: 0,
      elapsed: Duration.zero,
      error: null,
      hasSignal: false,
    );

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final startedAt = state.startedAt;
      if (startedAt == null || !state.isTracking) {
        return;
      }
      state = state.copyWith(
        elapsed: DateTime.now().toUtc().difference(startedAt),
      );

      final lastSignalAt = _lastSignalAt;
      if (lastSignalAt != null) {
        final secondsWithoutSignal = DateTime.now()
            .toUtc()
            .difference(lastSignalAt)
            .inSeconds;
        if (secondsWithoutSignal >= 20 && state.hasSignal) {
          state = state.copyWith(hasSignal: false);
        }
      }
    });

    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen(
          _onPosition,
          onError: (Object _) {
            state = state.copyWith(error: 'Error leyendo GPS en vivo.');
          },
        );
  }

  Future<LiveSessionSnapshot?> stop() async {
    if (!state.isTracking) {
      return null;
    }

    await _positionSub?.cancel();
    _positionSub = null;
    _ticker?.cancel();
    _ticker = null;

    final elapsed = state.elapsed;
    final distanceKm = state.distanceKm;
    final durationHours = elapsed.inSeconds / 3600;
    final avg = durationHours > 0 ? distanceKm / durationHours / 1.852 : 0.0;

    final snapshot = LiveSessionSnapshot(
      durationMinutes: elapsed.inMinutes > 0 ? elapsed.inMinutes : 1,
      distanceKm: distanceKm,
      avgSpeedKn: avg,
      maxSpeedKn: state.maxSpeedKn,
    );

    state = LiveSessionState.empty;
    _lastPosition = null;
    _lastSignalAt = null;

    return snapshot;
  }

  Future<void> cancel() async {
    await _positionSub?.cancel();
    _positionSub = null;
    _ticker?.cancel();
    _ticker = null;
    _lastPosition = null;
    _lastSignalAt = null;
    state = LiveSessionState.empty;
  }

  void _onPosition(Position position) {
    if (!state.isTracking) {
      return;
    }

    double distanceKm = state.distanceKm;
    if (_lastPosition != null) {
      final meters = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (meters.isFinite && meters > 0) {
        distanceKm += meters / 1000;
      }
    }

    final speedMs = position.speed < 0 ? 0 : position.speed;
    final speedKn = speedMs * 1.94384;
    final maxSpeed = speedKn > state.maxSpeedKn ? speedKn : state.maxSpeedKn;

    _lastPosition = position;
    _lastSignalAt = DateTime.now().toUtc();
    state = state.copyWith(
      distanceKm: distanceKm,
      currentSpeedKn: speedKn,
      maxSpeedKn: maxSpeed,
      hasSignal: true,
      error: null,
    );
  }
}

final liveSessionProvider =
    AutoDisposeNotifierProvider<LiveSessionNotifier, LiveSessionState>(
      LiveSessionNotifier.new,
    );
