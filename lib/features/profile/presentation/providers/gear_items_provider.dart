import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

final gearItemsProvider = StreamProvider<List<GearItem>>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return db.watchGearItems();
});

final gearItemsActionsProvider = Provider<GearItemsActions>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return GearItemsActions(db);
});

class GearItemsActions {
  const GearItemsActions(this._db);

  final LocalDatabase _db;

  Future<int> add({
    required String name,
    required String type,
    String? size,
    String? notes,
  }) {
    return _db.addGearItem(name: name, type: type, size: size, notes: notes);
  }

  Future<void> remove(int itemId) => _db.deleteGearItem(itemId);

  Future<void> setPrimary(int itemId) => _db.setPrimaryGearItem(itemId);
}
