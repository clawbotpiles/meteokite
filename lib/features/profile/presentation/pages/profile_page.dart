import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:meteokite/features/profile/presentation/providers/gear_items_provider.dart';
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
  final _gearNameController = TextEditingController();
  final _gearTypeController = TextEditingController();
  final _gearSizeController = TextEditingController();
  final _gearNotesController = TextEditingController();

  String? _selectedDiscipline;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isAddingGear = false;
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
    _gearNameController.dispose();
    _gearTypeController.dispose();
    _gearSizeController.dispose();
    _gearNotesController.dispose();
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

  Future<void> _addGearItem(GearItemsActions actions) async {
    final name = _gearNameController.text.trim();
    final type = _gearTypeController.text.trim();
    if (name.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nombre y tipo de equipo son obligatorios'),
        ),
      );
      return;
    }

    setState(() {
      _isAddingGear = true;
    });

    await actions.add(
      name: name,
      type: type,
      size: _gearSizeController.text.trim().isEmpty
          ? null
          : _gearSizeController.text.trim(),
      notes: _gearNotesController.text.trim().isEmpty
          ? null
          : _gearNotesController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    _gearNameController.clear();
    _gearTypeController.clear();
    _gearSizeController.clear();
    _gearNotesController.clear();

    setState(() {
      _isAddingGear = false;
    });
  }

  Future<void> _confirmAndClearHistory({
    required WindAlertsActions alertActions,
    required int? alertIdFilter,
    required String? spotFilter,
    required int daysFilter,
  }) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Limpiar historial'),
          content: const Text(
            'Puedes borrar todo el historial o solo los eventos visibles con los filtros actuales.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('cancel');
              },
              child: const Text('Cancelar'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('filtered');
              },
              child: const Text('Solo filtrado'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop('all');
              },
              child: const Text('Todo'),
            ),
          ],
        );
      },
    );

    if (choice == null || choice == 'cancel') {
      return;
    }

    if (choice == 'all') {
      await alertActions.clearHistory();
    } else {
      final threshold = DateTime.now().toUtc().subtract(
        Duration(days: daysFilter),
      );
      await alertActions.clearHistoryFiltered(
        alertId: alertIdFilter,
        spotName: spotFilter,
        activatedAfter: threshold,
      );
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          choice == 'all'
              ? 'Historial completo eliminado'
              : 'Historial filtrado eliminado',
        ),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesion'),
          content: const Text(
            'Vas a cerrar la sesion actual en este dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Cerrar sesion'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(authSessionProvider.notifier).signOut();
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.authLogin);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final alertsState = ref.watch(windAlertsProvider);
    final gearItemsState = ref.watch(gearItemsProvider);
    final alertHistoryState = ref.watch(
      filteredAlertNotificationHistoryProvider,
    );
    final alertHistorySpots = ref.watch(alertHistorySpotOptionsProvider);
    final alertHistoryAlertIds = ref.watch(alertHistoryAlertIdOptionsProvider);
    final selectedHistorySpot = ref.watch(alertHistorySpotFilterProvider);
    final selectedHistoryAlertId = ref.watch(alertHistoryAlertIdFilterProvider);
    final selectedHistoryDays = ref.watch(alertHistoryDaysFilterProvider);
    final alertActions = ref.watch(windAlertsActionsProvider);
    final gearActions = ref.watch(gearItemsActionsProvider);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _confirmSignOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesion',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl + kBottomNavigationBarHeight,
          ),
          child: Center(
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
                          'Perfil del rider',
                          style: textTheme.headlineSmall,
                        ),
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
                        Text('Equipamiento', style: textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _gearNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre (ej. Duotone Evo)',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _gearTypeController,
                                decoration: const InputDecoration(
                                  labelText: 'Tipo (kite, tabla, foil)',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextFormField(
                                controller: _gearSizeController,
                                decoration: const InputDecoration(
                                  labelText: 'Talla/Medida',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _gearNotesController,
                          decoration: const InputDecoration(
                            labelText: 'Notas (opcional)',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: _isAddingGear
                                ? null
                                : () {
                                    _addGearItem(gearActions);
                                  },
                            icon: const Icon(Icons.add),
                            label: Text(
                              _isAddingGear ? 'Guardando...' : 'Agregar equipo',
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        gearItemsState.when(
                          data: (items) {
                            if (items.isEmpty) {
                              return const Text(
                                'Todavia no hay equipo registrado.',
                              );
                            }

                            return Column(
                              children: items
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.xs,
                                      ),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                            '${item.name} (${item.type})',
                                          ),
                                          subtitle: Text(
                                            '${item.size ?? '-'} ${item.notes != null && item.notes!.isNotEmpty ? '| ${item.notes}' : ''}',
                                          ),
                                          trailing: Wrap(
                                            spacing: AppSpacing.xs,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  gearActions.setPrimary(
                                                    item.id,
                                                  );
                                                },
                                                icon: Icon(
                                                  item.isPrimary
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  gearActions.remove(item.id);
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) =>
                              Text('Error cargando equipo: $error'),
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
                                                    directionMinDeg:
                                                        directionMin,
                                                    directionMaxDeg:
                                                        directionMax,
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
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Historial de activaciones',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int?>(
                                initialValue: selectedHistoryAlertId,
                                decoration: const InputDecoration(
                                  labelText: 'Filtro alerta',
                                ),
                                items: [
                                  const DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text('Todas'),
                                  ),
                                  ...alertHistoryAlertIds.map(
                                    (id) => DropdownMenuItem<int?>(
                                      value: id,
                                      child: Text('Alerta #$id'),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  ref
                                          .read(
                                            alertHistoryAlertIdFilterProvider
                                                .notifier,
                                          )
                                          .state =
                                      value;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                initialValue: selectedHistorySpot,
                                decoration: const InputDecoration(
                                  labelText: 'Filtro spot',
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Todos'),
                                  ),
                                  ...alertHistorySpots.map(
                                    (spot) => DropdownMenuItem<String?>(
                                      value: spot,
                                      child: Text(spot),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  ref
                                          .read(
                                            alertHistorySpotFilterProvider
                                                .notifier,
                                          )
                                          .state =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: SegmentedButton<int>(
                                segments: const [
                                  ButtonSegment<int>(
                                    value: 1,
                                    label: Text('1d'),
                                  ),
                                  ButtonSegment<int>(
                                    value: 7,
                                    label: Text('7d'),
                                  ),
                                  ButtonSegment<int>(
                                    value: 30,
                                    label: Text('30d'),
                                  ),
                                ],
                                selected: {selectedHistoryDays},
                                onSelectionChanged: (selection) {
                                  ref
                                      .read(
                                        alertHistoryDaysFilterProvider.notifier,
                                      )
                                      .state = selection
                                      .first;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await _confirmAndClearHistory(
                                  alertActions: alertActions,
                                  alertIdFilter: selectedHistoryAlertId,
                                  spotFilter: selectedHistorySpot,
                                  daysFilter: selectedHistoryDays,
                                );
                              },
                              icon: const Icon(Icons.delete_sweep_outlined),
                              label: const Text('Limpiar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        alertHistoryState.when(
                          data: (events) {
                            if (events.isEmpty) {
                              return const Text(
                                'Todavia no hay activaciones notificadas.',
                              );
                            }

                            return Column(
                              children: events
                                  .take(8)
                                  .map(
                                    (event) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.sm,
                                      ),
                                      child: Card(
                                        child: ListTile(
                                          dense: true,
                                          title: Text(
                                            'Alerta #${event.alertId} - ${event.spotName}',
                                          ),
                                          subtitle: Text(
                                            '${DateFormat('dd/MM HH:mm').format(event.activatedAt.toLocal())} | ${event.speedKn.toStringAsFixed(1)} kn | ${event.directionDeg}° | ${event.source}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stackTrace) =>
                              Text('Error cargando historial: $error'),
                        ),
                      ],
                    ),
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
