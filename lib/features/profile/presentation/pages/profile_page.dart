import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/profile/presentation/providers/wind_alerts_provider.dart';
import 'package:meteokite/shared/constants/disciplines.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedDiscipline;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isCreatingAlert = false;

  Future<void> _openEditWindAlertSheet({
    required WindAlertsActions alertActions,
    required int alertId,
    required double minSpeedKn,
    required double maxSpeedKn,
    required int directionMinDeg,
    required int directionMaxDeg,
    required int startHour,
    required int endHour,
  }) async {
    const windPresets = <({String label, double min, double max})>[
      (label: '12-20', min: 12, max: 20),
      (label: '15-25', min: 15, max: 25),
      (label: '18-30', min: 18, max: 30),
    ];

    var windRange = RangeValues(
      minSpeedKn.clamp(0, 60),
      maxSpeedKn.clamp(0, 60),
    );
    var directionRange = RangeValues(
      directionMinDeg.toDouble().clamp(0, 359),
      directionMaxDeg.toDouble().clamp(0, 359),
    );
    var hourRange = RangeValues(
      startHour.toDouble().clamp(0, 23),
      endHour.toDouble().clamp(0, 23),
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                bottom:
                    MediaQuery.of(sheetContext).viewInsets.bottom +
                    AppSpacing.md,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar alerta',
                      style: Theme.of(sheetContext).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Viento: ${windRange.start.round()}-${windRange.end.round()} kn',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: windPresets
                          .map(
                            (preset) => ActionChip(
                              label: Text('${preset.label} kn'),
                              onPressed: () {
                                setSheetState(() {
                                  windRange = RangeValues(
                                    preset.min,
                                    preset.max,
                                  );
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    RangeSlider(
                      values: windRange,
                      min: 0,
                      max: 60,
                      divisions: 60,
                      labels: RangeLabels(
                        '${windRange.start.round()} kn',
                        '${windRange.end.round()} kn',
                      ),
                      onChanged: (values) {
                        setSheetState(() {
                          windRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Direccion: ${directionRange.start.round()}°-${directionRange.end.round()}°',
                    ),
                    RangeSlider(
                      values: directionRange,
                      min: 0,
                      max: 359,
                      divisions: 359,
                      labels: RangeLabels(
                        '${directionRange.start.round()}°',
                        '${directionRange.end.round()}°',
                      ),
                      onChanged: (values) {
                        setSheetState(() {
                          directionRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Horario: ${hourRange.start.round()}:00-${hourRange.end.round()}:00',
                    ),
                    RangeSlider(
                      values: hourRange,
                      min: 0,
                      max: 23,
                      divisions: 23,
                      labels: RangeLabels(
                        '${hourRange.start.round()}:00',
                        '${hourRange.end.round()}:00',
                      ),
                      onChanged: (values) {
                        setSheetState(() {
                          hourRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final min = windRange.start.roundToDouble();
                          final max = windRange.end.roundToDouble();

                          if (max <= min) {
                            ScaffoldMessenger.of(sheetContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'El viento maximo debe ser mayor que el minimo',
                                ),
                              ),
                            );
                            return;
                          }

                          await alertActions.update(
                            alertId: alertId,
                            minSpeedKn: min,
                            maxSpeedKn: max,
                            directionMinDeg: directionRange.start.round(),
                            directionMaxDeg: directionRange.end.round(),
                            startHour: hourRange.start.round(),
                            endHour: hourRange.end.round(),
                          );

                          if (!sheetContext.mounted) {
                            return;
                          }
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Guardar alerta'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final db = ref.read(localDatabaseProvider);
    final profile = await db.readUserProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _nameController.text = profile?.displayName ?? '';
      _selectedDiscipline = profile?.preferredDiscipline;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final db = ref.read(localDatabaseProvider);
    await db.upsertUserProfile(
      displayName: _nameController.text.trim(),
      preferredDiscipline: _selectedDiscipline!,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final alertsState = ref.watch(windAlertsProvider);
    final alertActions = ref.watch(windAlertsActionsProvider);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
                      Text('Perfil del rider', style: textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Gestion de equipamiento y alertas de viento (base inicial).',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _nameController,
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
                          onPressed: _isSaving ? null : _saveProfile,
                          child: Text(
                            _isSaving ? 'Guardando...' : 'Guardar cambios',
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Alertas de viento',
                              style: textTheme.headlineSmall,
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _isCreatingAlert
                                ? null
                                : () async {
                                    setState(() {
                                      _isCreatingAlert = true;
                                    });

                                    await alertActions.addDefault();

                                    if (!mounted) {
                                      return;
                                    }
                                    setState(() {
                                      _isCreatingAlert = false;
                                    });
                                  },
                            icon: const Icon(Icons.add),
                            label: const Text('Nueva alerta base'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Rango en nudos, direccion valida y horario activo.',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      alertsState.when(
                        data: (alerts) {
                          if (alerts.isEmpty) {
                            return const Text(
                              'Aun no hay alertas. Crea una con el boton superior.',
                            );
                          }

                          return Column(
                            children: alerts.map((alert) {
                              final minSpeed = alert.minSpeedKn;
                              final maxSpeed = alert.maxSpeedKn;
                              final directionMin = alert.directionMinDeg;
                              final directionMax = alert.directionMaxDeg;
                              final startHour = alert.startHour;
                              final endHour = alert.endHour;
                              final enabled = alert.enabled;
                              final alertId = alert.id;

                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${minSpeed.toStringAsFixed(0)}-${maxSpeed.toStringAsFixed(0)} kn',
                                                style: textTheme.titleMedium,
                                              ),
                                            ),
                                            Switch(
                                              value: enabled,
                                              onChanged: (value) {
                                                if (alertId < 0) {
                                                  return;
                                                }
                                                alertActions.toggle(
                                                  alertId: alertId,
                                                  enabled: value,
                                                );
                                              },
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (alertId < 0) {
                                                  return;
                                                }

                                                _openEditWindAlertSheet(
                                                  alertActions: alertActions,
                                                  alertId: alertId,
                                                  minSpeedKn: minSpeed,
                                                  maxSpeedKn: maxSpeed,
                                                  directionMinDeg: directionMin,
                                                  directionMaxDeg: directionMax,
                                                  startHour: startHour,
                                                  endHour: endHour,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (alertId < 0) {
                                                  return;
                                                }
                                                alertActions.remove(alertId);
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Direccion $directionMin°-$directionMax° | Horario $startHour:00-$endHour:00',
                                          style: textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stackTrace) =>
                            Text('Error cargando alertas: $error'),
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
