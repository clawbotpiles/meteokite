import 'package:meteokite/core/storage/local_database.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._db);

  final LocalDatabase _db;

  Future<bool> readPersistedSession() async {
    return await _db.readAuthSession() ?? false;
  }

  Future<void> setAuthenticated(bool value) {
    return _db.writeAuthSession(isAuthenticated: value);
  }

  Future<void> ensureUserSkeleton() {
    return _db.ensureUserSkeleton();
  }

  Future<bool> hasCompletedProfile() {
    return _db.hasCompletedProfile();
  }

  Future<void> completeProfile({
    required String displayName,
    required String preferredDiscipline,
  }) {
    return _db.upsertUserProfile(
      displayName: displayName,
      preferredDiscipline: preferredDiscipline,
    );
  }

  Future<void> touchRecentEmail(String email) {
    return _db.touchRecentAuthAccount(email);
  }

  Stream<List<String>> watchRecentEmails({int limit = 5}) {
    return _db
        .watchRecentAuthAccounts(limit: limit)
        .map((rows) => rows.map((row) => row.email).toList());
  }

  Future<void> removeRecentEmail(String email) {
    return _db.deleteRecentAuthAccount(email);
  }
}
