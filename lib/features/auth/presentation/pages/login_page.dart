import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokitev2_0/app/router/app_routes.dart';
import 'package:meteokitev2_0/core/config/env/env_config.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:meteokitev2_0/features/auth/presentation/providers/recent_auth_accounts_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _runSignIn(Future<String?> Function() action) async {
    setState(() {
      _isSubmitting = true;
    });

    final error = await action();
    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    context.go(AppRoutes.dashboard);
  }

  String _initialsFromEmail(String email) {
    final local = email.split('@').first.trim();
    if (local.isEmpty) {
      return 'MK';
    }

    final chunks = local
        .split(RegExp(r'[._\-\s]+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (chunks.length >= 2) {
      return '${chunks.first[0]}${chunks[1][0]}'.toUpperCase();
    }

    if (local.length == 1) {
      return local[0].toUpperCase();
    }

    return local.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authSessionProvider);
    final recentEmailsState = ref.watch(recentAuthEmailsProvider);
    final recentAccountsActions = ref.watch(recentAuthAccountsActionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Acceso')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido a MeteoKite',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Accede con email o con proveedores sociales (placeholder activable por flags).',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    recentEmailsState.when(
                      data: (emails) {
                        if (emails.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuentas recientes',
                              style: textTheme.labelLarge,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            ...emails
                                .take(3)
                                .map(
                                  (email) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.xs,
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      child: ListTile(
                                        dense: true,
                                        leading: CircleAvatar(
                                          child: Text(
                                            _initialsFromEmail(email),
                                          ),
                                        ),
                                        title: Text(email),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.chevron_right),
                                            IconButton(
                                              onPressed:
                                                  authState.isLoading ||
                                                      _isSubmitting
                                                  ? null
                                                  : () async {
                                                      await recentAccountsActions
                                                          .remove(email);
                                                    },
                                              icon: const Icon(
                                                Icons.close,
                                                size: 18,
                                              ),
                                              tooltip: 'Quitar de recientes',
                                            ),
                                          ],
                                        ),
                                        onTap:
                                            authState.isLoading || _isSubmitting
                                            ? null
                                            : () async {
                                                _emailController.text = email;
                                                await _runSignIn(
                                                  () => ref
                                                      .read(
                                                        authSessionProvider
                                                            .notifier,
                                                      )
                                                      .signInWithEmail(email),
                                                );
                                              },
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.isLoading || _isSubmitting
                            ? null
                            : () async {
                                final email = _emailController.text.trim();
                                await recentAccountsActions.add(email);
                                await _runSignIn(
                                  () => ref
                                      .read(authSessionProvider.notifier)
                                      .signInWithEmail(email),
                                );
                              },
                        child: const Text('Continuar con email'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: authState.isLoading || _isSubmitting
                            ? null
                            : () async {
                                await _runSignIn(
                                  () => ref
                                      .read(authSessionProvider.notifier)
                                      .signInWithGoogle(),
                                );
                              },
                        icon: const Icon(Icons.account_circle_outlined),
                        label: Text(
                          EnvConfig.googleAuthEnabled
                              ? 'Continuar con Google'
                              : 'Google (placeholder)',
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: authState.isLoading || _isSubmitting
                            ? null
                            : () async {
                                await _runSignIn(
                                  () => ref
                                      .read(authSessionProvider.notifier)
                                      .signInWithApple(),
                                );
                              },
                        icon: const Icon(Icons.apple),
                        label: Text(
                          EnvConfig.appleAuthEnabled
                              ? 'Continuar con Apple'
                              : 'Apple (placeholder)',
                        ),
                      ),
                    ),
                    if (EnvConfig.devBypassEnabled) ...[
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: authState.isLoading || _isSubmitting
                              ? null
                              : () async {
                                  await ref
                                      .read(authSessionProvider.notifier)
                                      .signInDev();
                                  if (!context.mounted) {
                                    return;
                                  }
                                  context.go(AppRoutes.dashboard);
                                },
                          child: const Text('Entrar con DEV BYPASS'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
