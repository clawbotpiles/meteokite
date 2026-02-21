import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/storage/local_database.dart';

class AuthSession {
  const AuthSession({
    required this.isAuthenticated,
    required this.hasCompletedProfile,
  });

  final bool isAuthenticated;
  final bool hasCompletedProfile;
}

class AuthSessionNotifier extends AsyncNotifier<AuthSession> {
  late final LocalDatabase _db;

  @override
  Future<AuthSession> build() async {
    _db = ref.read(localDatabaseProvider);
    final persisted = await _db.readAuthSession();
    final hasCompletedProfile = await _db.hasCompletedProfile();
    return AuthSession(
      isAuthenticated: persisted ?? EnvConfig.devBypassEnabled,
      hasCompletedProfile: hasCompletedProfile,
    );
  }

  Future<void> signInDev() async {
    await _db.writeAuthSession(isAuthenticated: true);
    await _db.ensureUserSkeleton();
    final hasCompletedProfile = await _db.hasCompletedProfile();
    state = AsyncData(
      AuthSession(
        isAuthenticated: true,
        hasCompletedProfile: hasCompletedProfile,
      ),
    );
  }

  Future<void> signOut() async {
    await _db.writeAuthSession(isAuthenticated: false);
    final hasCompletedProfile = await _db.hasCompletedProfile();
    state = AsyncData(
      AuthSession(
        isAuthenticated: false,
        hasCompletedProfile: hasCompletedProfile,
      ),
    );
  }

  Future<void> completeProfile({
    required String displayName,
    required String preferredDiscipline,
  }) async {
    await _db.upsertUserProfile(
      displayName: displayName,
      preferredDiscipline: preferredDiscipline,
    );

    final isAuthenticated = state.valueOrNull?.isAuthenticated ?? false;
    state = const AsyncLoading();
    state = AsyncData(
      AuthSession(isAuthenticated: isAuthenticated, hasCompletedProfile: true),
    );
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSession>(
      AuthSessionNotifier.new,
    );
