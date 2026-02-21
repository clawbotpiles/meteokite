import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

final windAlertsProvider = StreamProvider<List<WindAlert>>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return db.watchWindAlerts();
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
}
