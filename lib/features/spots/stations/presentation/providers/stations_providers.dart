import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

final selectedStationIdProvider = StateProvider<int?>((ref) => null);

final stationsProvider = FutureProvider<List<Station>>((ref) async {
  final db = ref.watch(localDatabaseProvider);
  await db.seedStationsIfNeeded();
  final stations = await db.getStationsList();

  if (stations.isNotEmpty) {
    final selected = ref.read(selectedStationIdProvider);
    if (selected == null) {
      ref.read(selectedStationIdProvider.notifier).state = stations.first.id;
    }
  }

  return stations;
});

final selectedStationProvider = Provider<Station?>((ref) {
  final stationsState = ref.watch(stationsProvider);
  final selectedId = ref.watch(selectedStationIdProvider);
  final stations = stationsState.valueOrNull;

  if (stations == null || stations.isEmpty || selectedId == null) {
    return null;
  }

  for (final station in stations) {
    if (station.id == selectedId) {
      return station;
    }
  }
  return null;
});

final latestStationReadingProvider = FutureProvider<StationReading?>((
  ref,
) async {
  final db = ref.watch(localDatabaseProvider);
  final station = ref.watch(selectedStationProvider);
  if (station == null) {
    return null;
  }

  await db.seedStationReadingsIfNeeded(station.id);
  return db.getLatestStationReading(station.id);
});

final stationHistoryProvider = FutureProvider<List<StationReading>>((
  ref,
) async {
  final db = ref.watch(localDatabaseProvider);
  final station = ref.watch(selectedStationProvider);
  if (station == null) {
    return const [];
  }

  await db.seedStationReadingsIfNeeded(station.id);
  return db.getRecentStationReadings(station.id, limit: 12);
});

final stationsActionsProvider = Provider<StationsActions>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return StationsActions(db);
});

class StationsActions {
  const StationsActions(this._db);

  final LocalDatabase _db;

  Future<void> refreshStationTick(int stationId) {
    return _db.appendSimulatedStationReading(stationId);
  }
}
