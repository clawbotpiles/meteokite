import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:meteokite/shared/constants/disciplines.dart';

class SetupProfilePage extends ConsumerStatefulWidget {
  const SetupProfilePage({super.key});

  @override
  ConsumerState<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends ConsumerState<SetupProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedDiscipline;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Completar perfil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configura tu perfil inicial',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Necesitamos un perfil basico para activar el flujo autenticado del MVP local.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nombre visible',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Introduce un nombre visible';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDiscipline,
                        decoration: const InputDecoration(
                          labelText: 'Disciplina principal',
                        ),
                        items: Disciplines.all
                            .map(
                              (discipline) => DropdownMenuItem<String>(
                                value: discipline,
                                child: Text(discipline),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDiscipline = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Selecciona una disciplina principal';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  final valid =
                                      _formKey.currentState?.validate() ??
                                      false;
                                  if (!valid) {
                                    return;
                                  }

                                  await ref
                                      .read(authSessionProvider.notifier)
                                      .completeProfile(
                                        displayName: _nameController.text
                                            .trim(),
                                        preferredDiscipline:
                                            _selectedDiscipline!,
                                      );

                                  if (!context.mounted) {
                                    return;
                                  }
                                  context.go(AppRoutes.dashboard);
                                },
                          child: const Text('Guardar perfil y continuar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
