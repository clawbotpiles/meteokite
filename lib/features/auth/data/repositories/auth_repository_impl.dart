import 'package:meteokite/features/auth/data/local/auth_local_data_source.dart';
import 'package:meteokite/features/auth/data/remote/social_auth_remote_data_source.dart';
import 'package:meteokite/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:meteokite/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthLocalDataSource local,
    required SocialAuthRemoteDataSource socialRemote,
  }) : _local = local,
       _socialRemote = socialRemote;

  final AuthLocalDataSource _local;
  final SocialAuthRemoteDataSource _socialRemote;

  @override
  Future<bool> readPersistedSession() {
    return _local.readPersistedSession();
  }

  @override
  Future<bool> hasCompletedProfile() {
    return _local.hasCompletedProfile();
  }

  @override
  Future<AuthSignInResult> signInWithEmail({required String email}) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      return const AuthSignInResult(
        success: false,
        provider: 'email',
        message: 'Email invalido.',
      );
    }

    await _local.setAuthenticated(true);
    await _local.ensureUserSkeleton();
    await _local.touchRecentEmail(email);
    return const AuthSignInResult(success: true, provider: 'email');
  }

  @override
  Future<AuthSignInResult> signInWithGoogle() async {
    final result = await _socialRemote.signInWithGoogle();
    if (!result.success) {
      return result;
    }

    await _local.setAuthenticated(true);
    await _local.ensureUserSkeleton();
    await _local.touchRecentEmail('google@social.local');
    return result;
  }

  @override
  Future<AuthSignInResult> signInWithApple() async {
    final result = await _socialRemote.signInWithApple();
    if (!result.success) {
      return result;
    }

    await _local.setAuthenticated(true);
    await _local.ensureUserSkeleton();
    await _local.touchRecentEmail('apple@social.local');
    return result;
  }

  @override
  Future<void> signOut() {
    return _local.setAuthenticated(false);
  }

  @override
  Future<void> completeProfile({
    required String displayName,
    required String preferredDiscipline,
  }) {
    return _local.completeProfile(
      displayName: displayName,
      preferredDiscipline: preferredDiscipline,
    );
  }
}
