import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

class AuthSessions extends Table {
  IntColumn get id => integer()();

  BoolColumn get isAuthenticated => boolean()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Users extends Table {
  IntColumn get id => integer()();

  TextColumn get email => text().nullable()();

  TextColumn get displayName => text().nullable()();

  TextColumn get preferredDiscipline => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class WindAlerts extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().withDefault(const Constant(1))();

  RealColumn get minSpeedKn => real()();

  RealColumn get maxSpeedKn => real()();

  IntColumn get directionMinDeg => integer()();

  IntColumn get directionMaxDeg => integer()();

  IntColumn get startHour => integer()();

  IntColumn get endHour => integer()();

  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}

class Stations extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get province => text()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();
}

class StationReadings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get stationId => integer()();

  DateTimeColumn get timestamp => dateTime()();

  RealColumn get speedKn => real()();

  RealColumn get gustKn => real()();

  IntColumn get directionDeg => integer()();
}

class RideSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().withDefault(const Constant(1))();

  TextColumn get spotName => text()();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime()();

  IntColumn get durationMinutes => integer()();

  RealColumn get distanceKm => real()();

  RealColumn get avgSpeedKn => real()();

  RealColumn get maxSpeedKn => real()();
}

@DriftDatabase(
  tables: [
    AuthSessions,
    Users,
    WindAlerts,
    Stations,
    StationReadings,
    RideSessions,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(users);
      }
      if (from < 3) {
        await migrator.createTable(windAlerts);
      }
      if (from < 4) {
        await migrator.createTable(stations);
        await migrator.createTable(stationReadings);
      }
      if (from < 5) {
        await migrator.createTable(rideSessions);
      }
    },
  );

  Future<bool?> readAuthSession() async {
    final row = await (select(
      authSessions,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
    return row?.isAuthenticated;
  }

  Future<void> writeAuthSession({required bool isAuthenticated}) async {
    await into(authSessions).insertOnConflictUpdate(
      AuthSessionsCompanion(
        id: const Value(1),
        isAuthenticated: Value(isAuthenticated),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> ensureUserSkeleton() async {
    final row = await (select(
      users,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
    if (row != null) {
      return;
    }

    await into(
      users,
    ).insert(const UsersCompanion(id: Value(1), email: Value('dev@local')));
  }

  Future<void> upsertUserProfile({
    required String displayName,
    required String preferredDiscipline,
    String? email,
  }) async {
    final now = DateTime.now();
    final existing = await (select(
      users,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();

    await into(users).insertOnConflictUpdate(
      UsersCompanion(
        id: const Value(1),
        email: Value(email ?? existing?.email ?? 'dev@local'),
        displayName: Value(displayName),
        preferredDiscipline: Value(preferredDiscipline),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<User?> readUserProfile() async {
    return (select(users)..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
  }

  Future<bool> hasCompletedProfile() async {
    final row = await (select(
      users,
    )..where((tbl) => tbl.id.equals(1))).getSingleOrNull();

    final name = row?.displayName?.trim() ?? '';
    final discipline = row?.preferredDiscipline?.trim() ?? '';
    return name.isNotEmpty && discipline.isNotEmpty;
  }

  Stream<List<WindAlert>> watchWindAlerts() {
    return (select(windAlerts)..where((tbl) => tbl.userId.equals(1))).watch();
  }

  Future<void> createDefaultWindAlert() async {
    await into(windAlerts).insert(
      const WindAlertsCompanion(
        minSpeedKn: Value(12),
        maxSpeedKn: Value(28),
        directionMinDeg: Value(220),
        directionMaxDeg: Value(310),
        startHour: Value(10),
        endHour: Value(20),
        enabled: Value(true),
      ),
    );
  }

  Future<void> setWindAlertEnabled({
    required int alertId,
    required bool enabled,
  }) async {
    await (update(windAlerts)..where((tbl) => tbl.id.equals(alertId))).write(
      WindAlertsCompanion(enabled: Value(enabled)),
    );
  }

  Future<void> updateWindAlert({
    required int alertId,
    required double minSpeedKn,
    required double maxSpeedKn,
    required int directionMinDeg,
    required int directionMaxDeg,
    required int startHour,
    required int endHour,
  }) async {
    await (update(windAlerts)..where((tbl) => tbl.id.equals(alertId))).write(
      WindAlertsCompanion(
        minSpeedKn: Value(minSpeedKn),
        maxSpeedKn: Value(maxSpeedKn),
        directionMinDeg: Value(directionMinDeg),
        directionMaxDeg: Value(directionMaxDeg),
        startHour: Value(startHour),
        endHour: Value(endHour),
      ),
    );
  }

  Future<void> deleteWindAlert(int alertId) async {
    await (delete(windAlerts)..where((tbl) => tbl.id.equals(alertId))).go();
  }

  Future<void> seedStationsIfNeeded() async {
    final countExpr = stations.id.count();
    final query = selectOnly(stations)..addColumns([countExpr]);
    final result = await query.getSingle();
    final count = result.read(countExpr) ?? 0;
    if (count > 0) {
      return;
    }

    const stationSeeds =
        <({String name, String province, double lat, double lon})>[
          (name: 'Oliva', province: 'Valencia', lat: 38.919, lon: -0.112),
          (name: 'Piles', province: 'Valencia', lat: 38.944, lon: -0.132),
          (
            name: 'Punta de los Molinos',
            province: 'Alicante',
            lat: 38.843,
            lon: 0.108,
          ),
          (name: 'Calpe', province: 'Alicante', lat: 38.643, lon: 0.057),
          (name: 'Altea', province: 'Alicante', lat: 38.603, lon: -0.050),
          (name: 'Villajoyosa', province: 'Alicante', lat: 38.508, lon: -0.232),
          (name: 'Santa Pola', province: 'Alicante', lat: 38.193, lon: -0.555),
          (name: 'Cullera', province: 'Valencia', lat: 39.165, lon: -0.252),
          (name: 'Xeraco', province: 'Valencia', lat: 39.029, lon: -0.193),
          (
            name: 'El Perellonet',
            province: 'Valencia',
            lat: 39.305,
            lon: -0.279,
          ),
          (name: 'Tarifa', province: 'Cadiz', lat: 36.014, lon: -5.604),
        ];

    await batch((batch) {
      batch.insertAll(
        stations,
        stationSeeds
            .map(
              (seed) => StationsCompanion.insert(
                name: seed.name,
                province: seed.province,
                latitude: seed.lat,
                longitude: seed.lon,
              ),
            )
            .toList(),
      );
    });
  }

  Future<List<Station>> getStationsList() {
    return (select(
      stations,
    )..orderBy([(tbl) => OrderingTerm.asc(tbl.name)])).get();
  }

  Future<void> seedStationReadingsIfNeeded(int stationId) async {
    final existing = await (select(
      stationReadings,
    )..where((tbl) => tbl.stationId.equals(stationId))).getSingleOrNull();
    if (existing != null) {
      return;
    }

    final now = DateTime.now();
    final base = 13 + (stationId % 7);
    final directionBase = 190 + ((stationId * 13) % 100);

    await batch((batch) {
      final entries = List.generate(24, (index) {
        final hourAgo = 23 - index;
        final t = hourAgo / 23;
        final wave = math.sin(t * math.pi * 2);
        final speed = (base + wave * 6 + (index % 3) * 0.8).clamp(6, 38);
        final gust = (speed + 4 + ((index + stationId) % 4)).clamp(8, 45);
        final direction = (directionBase + ((index * 9) % 70)) % 360;

        return StationReadingsCompanion.insert(
          stationId: stationId,
          timestamp: now.subtract(Duration(hours: hourAgo)),
          speedKn: speed.toDouble(),
          gustKn: gust.toDouble(),
          directionDeg: direction,
        );
      });
      batch.insertAll(stationReadings, entries);
    });
  }

  Future<StationReading?> getLatestStationReading(int stationId) {
    return (select(stationReadings)
          ..where((tbl) => tbl.stationId.equals(stationId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<StationReading>> getRecentStationReadings(
    int stationId, {
    int limit = 12,
  }) {
    return (select(stationReadings)
          ..where((tbl) => tbl.stationId.equals(stationId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])
          ..limit(limit))
        .get();
  }

  Future<void> appendSimulatedStationReading(int stationId) async {
    final latest = await getLatestStationReading(stationId);
    if (latest == null) {
      await seedStationReadingsIfNeeded(stationId);
      return;
    }

    final now = DateTime.now();
    final latestTime = latest.timestamp;
    final elapsedMinutes = now.difference(latestTime).inMinutes;
    final nextTimestamp = elapsedMinutes < 5
        ? latestTime.add(const Duration(minutes: 5))
        : now;

    final minuteFactor = math.sin(nextTimestamp.minute / 60 * math.pi * 2);
    final trendFactor = math.cos(nextTimestamp.hour / 24 * math.pi * 2);
    final speed = (latest.speedKn + minuteFactor * 1.8 + trendFactor * 1.2)
        .clamp(6, 42)
        .toDouble();
    final gust = (speed + 3 + ((nextTimestamp.minute + stationId) % 4))
        .clamp(8, 48)
        .toDouble();
    final direction =
        (latest.directionDeg + 6 + (nextTimestamp.minute % 9)) % 360;

    await into(stationReadings).insert(
      StationReadingsCompanion.insert(
        stationId: stationId,
        timestamp: nextTimestamp,
        speedKn: speed,
        gustKn: gust,
        directionDeg: direction,
      ),
    );
  }

  Stream<List<RideSession>> watchRideSessions() {
    return (select(rideSessions)
          ..where((tbl) => tbl.userId.equals(1))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]))
        .watch();
  }

  Future<void> addRideSession({
    required String spotName,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationMinutes,
    required double distanceKm,
    required double avgSpeedKn,
    required double maxSpeedKn,
  }) async {
    await into(rideSessions).insert(
      RideSessionsCompanion.insert(
        spotName: spotName,
        startedAt: startedAt,
        endedAt: endedAt,
        durationMinutes: durationMinutes,
        distanceKm: distanceKm,
        avgSpeedKn: avgSpeedKn,
        maxSpeedKn: maxSpeedKn,
      ),
    );
  }

  Future<void> deleteRideSession(int sessionId) async {
    await (delete(rideSessions)..where((tbl) => tbl.id.equals(sessionId))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meteokite.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
