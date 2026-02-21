class AuthSignInResult {
  const AuthSignInResult({
    required this.success,
    required this.provider,
    this.message,
  });

  final bool success;
  final String provider;
  final String? message;
}
