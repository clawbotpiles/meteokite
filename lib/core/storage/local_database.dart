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

  IntColumn get gearItemId => integer().nullable()();

  TextColumn get gearLabel => text().nullable()();
}

class WeatherSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get spotKey => text().unique()();

  RealColumn get latitude => real()();

  RealColumn get longitude => real()();

  DateTimeColumn get timestamp => dateTime()();

  RealColumn get speedKn => real()();

  RealColumn get gustKn => real()();

  IntColumn get directionDeg => integer()();

  TextColumn get source => text()();

  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
}

class AlertNotificationStates extends Table {
  IntColumn get alertId => integer()();

  DateTimeColumn get lastNotifiedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {alertId};
}

class AlertNotificationEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get alertId => integer()();

  TextColumn get spotName => text()();

  DateTimeColumn get activatedAt => dateTime()();

  RealColumn get speedKn => real()();

  IntColumn get directionDeg => integer()();

  TextColumn get source => text()();
}

class GearItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().withDefault(const Constant(1))();

  TextColumn get name => text()();

  TextColumn get type => text()();

  TextColumn get size => text().nullable()();

  TextColumn get notes => text().nullable()();

  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class RecentAuthAccounts extends Table {
  TextColumn get email => text()();

  DateTimeColumn get lastUsedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {email};
}

class WeatherSourcePreferences extends Table {
  TextColumn get spotKey => text()();

  TextColumn get preference => text()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {spotKey};
}

@DriftDatabase(
  tables: [
    AuthSessions,
    Users,
    WindAlerts,
    Stations,
    StationReadings,
    RideSessions,
    WeatherSnapshots,
    AlertNotificationStates,
    AlertNotificationEvents,
    GearItems,
    RecentAuthAccounts,
    WeatherSourcePreferences,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 12;

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
      if (from < 6) {
        await migrator.createTable(weatherSnapshots);
      }
      if (from < 7) {
        await migrator.createTable(alertNotificationStates);
      }
      if (from < 8) {
        await migrator.createTable(alertNotificationEvents);
      }
      if (from < 9) {
        await migrator.createTable(gearItems);
      }
      if (from < 10) {
        await customStatement(
          'ALTER TABLE ride_sessions ADD COLUMN gear_item_id INTEGER NULL',
        );
        await customStatement(
          'ALTER TABLE ride_sessions ADD COLUMN gear_label TEXT NULL',
        );
      }
      if (from < 11) {
        await migrator.createTable(recentAuthAccounts);
      }
      if (from < 12) {
        await migrator.createTable(weatherSourcePreferences);
      }
    },
  );

  String _weatherSpotKey(double latitude, double longitude) {
    final lat = latitude.toStringAsFixed(4);
    final lon = longitude.toStringAsFixed(4);
    return '$lat|$lon';
  }

  Future<void> upsertWeatherSnapshot({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    required double speedKn,
    required double gustKn,
    required int directionDeg,
    required String source,
  }) async {
    await into(weatherSnapshots).insertOnConflictUpdate(
      WeatherSnapshotsCompanion(
        spotKey: Value(_weatherSpotKey(latitude, longitude)),
        latitude: Value(latitude),
        longitude: Value(longitude),
        timestamp: Value(timestamp),
        speedKn: Value(speedKn),
        gustKn: Value(gustKn),
        directionDeg: Value(directionDeg),
        source: Value(source),
        fetchedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<WeatherSnapshot?> getWeatherSnapshot({
    required double latitude,
    required double longitude,
  }) {
    return (select(weatherSnapshots)
          ..where(
            (tbl) => tbl.spotKey.equals(_weatherSpotKey(latitude, longitude)),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<DateTime?> readAlertLastNotifiedAt(int alertId) async {
    final row =
        await (select(alertNotificationStates)
              ..where((tbl) => tbl.alertId.equals(alertId))
              ..limit(1))
            .getSingleOrNull();
    return row?.lastNotifiedAt;
  }

  Future<void> writeAlertLastNotifiedAt({
    required int alertId,
    required DateTime at,
  }) {
    return into(alertNotificationStates).insertOnConflictUpdate(
      AlertNotificationStatesCompanion(
        alertId: Value(alertId),
        lastNotifiedAt: Value(at.toUtc()),
      ),
    );
  }

  Future<void> addAlertNotificationEvent({
    required int alertId,
    required String spotName,
    required DateTime activatedAt,
    required double speedKn,
    required int directionDeg,
    required String source,
  }) {
    return into(alertNotificationEvents).insert(
      AlertNotificationEventsCompanion.insert(
        alertId: alertId,
        spotName: spotName,
        activatedAt: activatedAt.toUtc(),
        speedKn: speedKn,
        directionDeg: directionDeg,
        source: source,
      ),
    );
  }

  Stream<List<AlertNotificationEvent>> watchRecentAlertNotificationEvents({
    int limit = 20,
  }) {
    return (select(alertNotificationEvents)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.activatedAt)])
          ..limit(limit))
        .watch();
  }

  Future<void> clearAlertNotificationEvents() {
    return delete(alertNotificationEvents).go();
  }

  Future<void> clearAlertNotificationEventsFiltered({
    int? alertId,
    String? spotName,
    DateTime? activatedAfter,
  }) {
    final query = delete(alertNotificationEvents)
      ..where((tbl) {
        Expression<bool> predicate = const Constant(true);

        if (alertId != null) {
          predicate = predicate & tbl.alertId.equals(alertId);
        }
        if (spotName != null) {
          predicate = predicate & tbl.spotName.equals(spotName);
        }
        if (activatedAfter != null) {
          predicate =
              predicate & tbl.activatedAt.isBiggerOrEqualValue(activatedAfter);
        }

        return predicate;
      });

    return query.go();
  }

  Stream<List<GearItem>> watchGearItems() {
    return (select(gearItems)
          ..where((tbl) => tbl.userId.equals(1))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.isPrimary),
            (tbl) => OrderingTerm.asc(tbl.createdAt),
          ]))
        .watch();
  }

  Future<int> addGearItem({
    required String name,
    required String type,
    String? size,
    String? notes,
  }) {
    return into(gearItems).insert(
      GearItemsCompanion.insert(
        name: name,
        type: type,
        size: Value(size),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteGearItem(int itemId) {
    return (delete(gearItems)..where((tbl) => tbl.id.equals(itemId))).go();
  }

  Future<void> setPrimaryGearItem(int itemId) async {
    await transaction(() async {
      await (update(gearItems)..where((tbl) => tbl.userId.equals(1))).write(
        const GearItemsCompanion(isPrimary: Value(false)),
      );

      await (update(gearItems)..where((tbl) => tbl.id.equals(itemId))).write(
        const GearItemsCompanion(isPrimary: Value(true)),
      );
    });
  }

  Future<void> touchRecentAuthAccount(String email) {
    return into(recentAuthAccounts).insertOnConflictUpdate(
      RecentAuthAccountsCompanion(
        email: Value(email.trim().toLowerCase()),
        lastUsedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Stream<List<RecentAuthAccount>> watchRecentAuthAccounts({int limit = 5}) {
    return (select(recentAuthAccounts)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.lastUsedAt)])
          ..limit(limit))
        .watch();
  }

  Future<void> deleteRecentAuthAccount(String email) {
    final normalized = email.trim().toLowerCase();
    return (delete(
      recentAuthAccounts,
    )..where((tbl) => tbl.email.equals(normalized))).go();
  }

  Future<String?> readWeatherSourcePreference({
    required double latitude,
    required double longitude,
  }) async {
    final row =
        await (select(weatherSourcePreferences)
              ..where(
                (tbl) =>
                    tbl.spotKey.equals(_weatherSpotKey(latitude, longitude)),
              )
              ..limit(1))
            .getSingleOrNull();
    return row?.preference;
  }

  Future<void> writeWeatherSourcePreference({
    required double latitude,
    required double longitude,
    required String preference,
  }) {
    return into(weatherSourcePreferences).insertOnConflictUpdate(
      WeatherSourcePreferencesCompanion(
        spotKey: Value(_weatherSpotKey(latitude, longitude)),
        preference: Value(preference),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

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
    int? gearItemId,
    String? gearLabel,
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
        gearItemId: Value(gearItemId),
        gearLabel: Value(gearLabel),
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
