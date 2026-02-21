import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

final windAlertsProvider = StreamProvider<List<WindAlert>>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return db.watchWindAlerts();
});

final alertNotificationHistoryProvider =
    StreamProvider<List<AlertNotificationEvent>>((ref) {
      final db = ref.watch(localDatabaseProvider);
      return db.watchRecentAlertNotificationEvents(limit: 200);
    });

final alertHistoryAlertIdFilterProvider = StateProvider<int?>((ref) => null);
final alertHistorySpotFilterProvider = StateProvider<String?>((ref) => null);
final alertHistoryDaysFilterProvider = StateProvider<int>((ref) => 7);

final filteredAlertNotificationHistoryProvider =
    Provider<AsyncValue<List<AlertNotificationEvent>>>((ref) {
      final historyState = ref.watch(alertNotificationHistoryProvider);
      final alertIdFilter = ref.watch(alertHistoryAlertIdFilterProvider);
      final spotFilter = ref.watch(alertHistorySpotFilterProvider);
      final daysFilter = ref.watch(alertHistoryDaysFilterProvider);

      return historyState.whenData((events) {
        final now = DateTime.now().toUtc();
        final threshold = now.subtract(Duration(days: daysFilter));

        return events.where((event) {
          if (alertIdFilter != null && event.alertId != alertIdFilter) {
            return false;
          }
          if (spotFilter != null && event.spotName != spotFilter) {
            return false;
          }
          return event.activatedAt.toUtc().isAfter(threshold);
        }).toList();
      });
    });

final alertHistorySpotOptionsProvider = Provider<List<String>>((ref) {
  final events =
      ref.watch(alertNotificationHistoryProvider).valueOrNull ?? const [];
  final set = <String>{for (final e in events) e.spotName};
  final list = set.toList()..sort();
  return list;
});

final alertHistoryAlertIdOptionsProvider = Provider<List<int>>((ref) {
  final events =
      ref.watch(alertNotificationHistoryProvider).valueOrNull ?? const [];
  final set = <int>{for (final e in events) e.alertId};
  final list = set.toList()..sort();
  return list;
});

final windAlertsActionsProvider = Provider<WindAlertsActions>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return WindAlertsActions(db);
});

class WindAlertsActions {
  const WindAlertsActions(this._db);

  final LocalDatabase _db;

  Future<void> addDefault() => _db.createDefaultWindAlert();

  Future<void> toggle({required int alertId, required bool enabled}) {
    return _db.setWindAlertEnabled(alertId: alertId, enabled: enabled);
  }

  Future<void> update({
    required int alertId,
    required double minSpeedKn,
    required double maxSpeedKn,
    required int directionMinDeg,
    required int directionMaxDeg,
    required int startHour,
    required int endHour,
  }) {
    return _db.updateWindAlert(
      alertId: alertId,
      minSpeedKn: minSpeedKn,
      maxSpeedKn: maxSpeedKn,
      directionMinDeg: directionMinDeg,
      directionMaxDeg: directionMaxDeg,
      startHour: startHour,
      endHour: endHour,
    );
  }

  Future<void> remove(int alertId) => _db.deleteWindAlert(alertId);

  Future<void> clearHistory() => _db.clearAlertNotificationEvents();

  Future<void> clearHistoryFiltered({
    int? alertId,
    String? spotName,
    DateTime? activatedAfter,
  }) {
    return _db.clearAlertNotificationEventsFiltered(
      alertId: alertId,
      spotName: spotName,
      activatedAfter: activatedAfter,
    );
  }
}
