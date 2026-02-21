import 'package:meteokite/features/auth/domain/entities/auth_sign_in_result.dart';

abstract interface class AuthRepository {
  Future<bool> readPersistedSession();

  Future<bool> hasCompletedProfile();

  Future<AuthSignInResult> signInWithEmail({required String email});

  Future<AuthSignInResult> signInWithGoogle();

  Future<AuthSignInResult> signInWithApple();

  Future<void> signOut();

  Future<void> completeProfile({
    required String displayName,
    required String preferredDiscipline,
  });
}
