import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

final rideSessionsProvider = StreamProvider<List<RideSession>>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return db.watchRideSessions();
});

class SessionsSummary {
  const SessionsSummary({
    required this.totalDistanceKm,
    required this.bestSpeedKn,
    required this.monthSessions,
  });

  final double totalDistanceKm;
  final double bestSpeedKn;
  final int monthSessions;
}

final sessionsSummaryProvider = Provider<AsyncValue<SessionsSummary>>((ref) {
  final sessionsState = ref.watch(rideSessionsProvider);

  return sessionsState.whenData((sessions) {
    final now = DateTime.now();
    var totalDistance = 0.0;
    var bestSpeed = 0.0;
    var monthSessions = 0;

    for (final session in sessions) {
      totalDistance += session.distanceKm;
      if (session.maxSpeedKn > bestSpeed) {
        bestSpeed = session.maxSpeedKn;
      }

      if (session.startedAt.year == now.year &&
          session.startedAt.month == now.month) {
        monthSessions++;
      }
    }

    return SessionsSummary(
      totalDistanceKm: totalDistance,
      bestSpeedKn: bestSpeed,
      monthSessions: monthSessions,
    );
  });
});

final sessionsActionsProvider = Provider<SessionsActions>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return SessionsActions(db);
});

class SessionsActions {
  const SessionsActions(this._db);

  final LocalDatabase _db;

  Future<void> addSession({
    required String spotName,
    required int durationMinutes,
    required double distanceKm,
    required double avgSpeedKn,
    required double maxSpeedKn,
  }) {
    final endedAt = DateTime.now();
    final startedAt = endedAt.subtract(Duration(minutes: durationMinutes));

    return _db.addRideSession(
      spotName: spotName,
      startedAt: startedAt,
      endedAt: endedAt,
      durationMinutes: durationMinutes,
      distanceKm: distanceKm,
      avgSpeedKn: avgSpeedKn,
      maxSpeedKn: maxSpeedKn,
    );
  }

  Future<void> deleteSession(int sessionId) => _db.deleteRideSession(sessionId);
}
