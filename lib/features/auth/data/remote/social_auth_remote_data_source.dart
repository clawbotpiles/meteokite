import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/features/auth/domain/entities/auth_sign_in_result.dart';

class SocialAuthRemoteDataSource {
  const SocialAuthRemoteDataSource();

  bool get googleEnabled => EnvConfig.googleAuthEnabled;
  bool get appleEnabled => EnvConfig.appleAuthEnabled;

  Future<AuthSignInResult> signInWithGoogle() async {
    if (!googleEnabled) {
      return const AuthSignInResult(
        success: false,
        provider: 'google',
        message: 'Google login aun no esta habilitado en este build.',
      );
    }

    return const AuthSignInResult(success: true, provider: 'google');
  }

  Future<AuthSignInResult> signInWithApple() async {
    if (!appleEnabled) {
      return const AuthSignInResult(
        success: false,
        provider: 'apple',
        message: 'Apple login aun no esta habilitado en este build.',
      );
    }

    return const AuthSignInResult(success: true, provider: 'apple');
  }
}
