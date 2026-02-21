import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

class GearPerformanceSummary {
  const GearPerformanceSummary({
    required this.gearLabel,
    required this.sessionsCount,
    required this.totalDistanceKm,
    required this.bestSpeedKn,
  });

  final String gearLabel;
  final int sessionsCount;
  final double totalDistanceKm;
  final double bestSpeedKn;
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

final gearPerformanceSummariesProvider =
    Provider<AsyncValue<List<GearPerformanceSummary>>>((ref) {
      final sessionsState = ref.watch(rideSessionsProvider);

      return sessionsState.whenData((sessions) {
        final statsByGear = <String, GearPerformanceSummary>{};

        for (final session in sessions) {
          final gear = (session.gearLabel == null || session.gearLabel!.isEmpty)
              ? 'Sin equipo'
              : session.gearLabel!;

          final existing = statsByGear[gear];
          if (existing == null) {
            statsByGear[gear] = GearPerformanceSummary(
              gearLabel: gear,
              sessionsCount: 1,
              totalDistanceKm: session.distanceKm,
              bestSpeedKn: session.maxSpeedKn,
            );
            continue;
          }

          statsByGear[gear] = GearPerformanceSummary(
            gearLabel: existing.gearLabel,
            sessionsCount: existing.sessionsCount + 1,
            totalDistanceKm: existing.totalDistanceKm + session.distanceKm,
            bestSpeedKn: session.maxSpeedKn > existing.bestSpeedKn
                ? session.maxSpeedKn
                : existing.bestSpeedKn,
          );
        }

        final list = statsByGear.values.toList()
          ..sort((a, b) {
            final byCount = b.sessionsCount.compareTo(a.sessionsCount);
            if (byCount != 0) {
              return byCount;
            }
            return b.bestSpeedKn.compareTo(a.bestSpeedKn);
          });

        return list;
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
    int? gearItemId,
    String? gearLabel,
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
      gearItemId: gearItemId,
      gearLabel: gearLabel,
    );
  }

  Future<void> deleteSession(int sessionId) => _db.deleteRideSession(sessionId);

  Future<String> exportSessionsCsv({
    required List<RideSession> sessions,
    required List<GearPerformanceSummary> gearSummaries,
  }) async {
    final rows = <String>[
      'seccion,fecha_inicio,spot,duracion_min,distancia_km,vel_media_kn,vel_max_kn,equipo',
    ];

    for (final session in sessions) {
      rows.add(
        [
          'session',
          session.startedAt.toIso8601String(),
          session.spotName,
          session.durationMinutes.toString(),
          session.distanceKm.toStringAsFixed(2),
          session.avgSpeedKn.toStringAsFixed(2),
          session.maxSpeedKn.toStringAsFixed(2),
          session.gearLabel ?? 'Sin equipo',
        ].map(_csvEscape).join(','),
      );
    }

    rows.add('');
    rows.add(
      'seccion,equipo,sesiones,distancia_total_km,mejor_velocidad_kn,fecha_export',
    );

    final exportedAt = DateTime.now().toIso8601String();
    for (final summary in gearSummaries) {
      rows.add(
        [
          'gear_summary',
          summary.gearLabel,
          summary.sessionsCount.toString(),
          summary.totalDistanceKm.toStringAsFixed(2),
          summary.bestSpeedKn.toStringAsFixed(2),
          exportedAt,
        ].map(_csvEscape).join(','),
      );
    }

    final csv = '${rows.join('\n')}\n';
    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'meteokite_sessions_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(p.join(dir.path, fileName));
    await file.writeAsString(csv);
    return file.path;
  }

  String _csvEscape(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
