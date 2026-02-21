import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSessionProvider = AsyncNotifierProvider<AuthSessionNotifier, void>(
  AuthSessionNotifier.new,
);

class AuthSessionNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> signInWithEmail(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      return 'Introduce un email valido';
    }

    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    state = const AsyncData(null);
    return null;
  }

  Future<String?> signInWithGoogle() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    state = const AsyncData(null);
    return null;
  }

  Future<String?> signInWithApple() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    state = const AsyncData(null);
    return null;
  }

  Future<void> signInDev() async {
    state = const AsyncLoading();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    state = const AsyncData(null);
  }
}
