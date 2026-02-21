import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/config/env/env_config.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/auth/presentation/providers/auth_session_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Acceso')),
      body: Center(
        child: Padding(
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
                      'Acceso base para fase 1 local-first. El flujo real de email/social se completa en siguientes incrementos.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.isLoading
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
                        child: Text(
                          EnvConfig.devBypassEnabled
                              ? 'Entrar (DEV BYPASS activo)'
                              : 'Entrar (modo local)',
                        ),
                      ),
                    ),
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
