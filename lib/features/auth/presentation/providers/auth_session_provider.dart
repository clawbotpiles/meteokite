import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/features/auth/domain/repositories/auth_repository.dart';
import 'package:meteokite/features/auth/presentation/providers/auth_repository_provider.dart';

class AuthSession {
  const AuthSession({
    required this.isAuthenticated,
    required this.hasCompletedProfile,
  });

  final bool isAuthenticated;
  final bool hasCompletedProfile;
}

class AuthSessionNotifier extends AsyncNotifier<AuthSession> {
  late final AuthRepository _repository;

  @override
  Future<AuthSession> build() async {
    _repository = ref.read(authRepositoryProvider);
    final persisted = await _repository.readPersistedSession();
    final hasCompletedProfile = await _repository.hasCompletedProfile();
    return AuthSession(
      isAuthenticated: persisted || EnvConfig.devBypassEnabled,
      hasCompletedProfile: hasCompletedProfile,
    );
  }

  Future<void> signInDev() async {
    await _repository.signInWithEmail(email: 'dev@meteokite.local');
    final hasCompletedProfile = await _repository.hasCompletedProfile();
    state = AsyncData(
      AuthSession(
        isAuthenticated: true,
        hasCompletedProfile: hasCompletedProfile,
      ),
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    final hasCompletedProfile = await _repository.hasCompletedProfile();
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
    await _repository.completeProfile(
      displayName: displayName,
      preferredDiscipline: preferredDiscipline,
    );

    final isAuthenticated = state.valueOrNull?.isAuthenticated ?? false;
    state = const AsyncLoading();
    state = AsyncData(
      AuthSession(isAuthenticated: isAuthenticated, hasCompletedProfile: true),
    );
  }

  Future<String?> signInWithEmail(String email) async {
    final result = await _repository.signInWithEmail(email: email);
    return _applySignInResult(result.success, result.message);
  }

  Future<String?> signInWithGoogle() async {
    final result = await _repository.signInWithGoogle();
    return _applySignInResult(result.success, result.message);
  }

  Future<String?> signInWithApple() async {
    final result = await _repository.signInWithApple();
    return _applySignInResult(result.success, result.message);
  }

  Future<String?> _applySignInResult(bool success, String? message) async {
    if (!success) {
      return message ?? 'No se pudo iniciar sesion.';
    }

    final hasCompletedProfile = await _repository.hasCompletedProfile();
    state = AsyncData(
      AuthSession(
        isAuthenticated: true,
        hasCompletedProfile: hasCompletedProfile,
      ),
    );
    return null;
  }
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSession>(
      AuthSessionNotifier.new,
    );
