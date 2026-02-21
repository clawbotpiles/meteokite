import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:meteokite/core/storage/local_database.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/profile/presentation/providers/gear_items_provider.dart';
import 'package:meteokite/features/sessions/presentation/providers/external_session_import_provider.dart';
import 'package:meteokite/features/sessions/presentation/providers/live_session_provider.dart';
import 'package:meteokite/features/sessions/presentation/providers/sessions_providers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:meteokite/shared/constants/spots.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/session_stats_card.dart';

class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController(text: '90');
  final _distanceController = TextEditingController(text: '18.5');
  final _avgSpeedController = TextEditingController(text: '16.2');
  final _maxSpeedController = TextEditingController(text: '24.8');

  String _selectedSpotName = SpainInitialSpots.all.first.name;
  int? _selectedGearItemId;
  bool _isSaving = false;
  bool _isExporting = false;
  bool _isImporting = false;

  GearItem? _resolveSelectedGear(List<GearItem> gearItems) {
    final preferredId = _selectedGearItemId;
    if (preferredId != null) {
      for (final item in gearItems) {
        if (item.id == preferredId) {
          return item;
        }
      }
    }
    for (final item in gearItems) {
      if (item.isPrimary) {
        return item;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _durationController.dispose();
    _distanceController.dispose();
    _avgSpeedController.dispose();
    _maxSpeedController.dispose();
    super.dispose();
  }

  Future<void> _shareSummary() async {
    final sessions = ref.read(rideSessionsProvider).valueOrNull;
    final summaries = ref.read(gearPerformanceSummariesProvider).valueOrNull;

    if (sessions == null || summaries == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carga datos antes de compartir.')),
      );
      return;
    }
    setState(() {
      _isExporting = true;
    });

    try {
      if (sessions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay sesiones para compartir.')),
        );
        return;
      }

      final totalDistance = sessions.fold<double>(
        0,
        (sum, session) => sum + session.distanceKm,
      );
      final bestSpeed = sessions.fold<double>(
        0,
        (best, session) =>
            session.maxSpeedKn > best ? session.maxSpeedKn : best,
      );
      final topGear = summaries.isEmpty ? null : summaries.first;

      final text = StringBuffer()
        ..writeln('Resumen MeteoKite')
        ..writeln('Sesiones: ${sessions.length}')
        ..writeln('Distancia total: ${totalDistance.toStringAsFixed(1)} km')
        ..writeln('Mejor velocidad: ${bestSpeed.toStringAsFixed(1)} kn');

      if (topGear != null) {
        text.writeln(
          'Equipo destacado: ${topGear.gearLabel} (${topGear.sessionsCount} sesiones)',
        );
      }

      await Share.share(text.toString(), subject: 'Resumen MeteoKite');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error compartiendo resumen: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _addSession(List<GearItem> gearItems) async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final durationMinutes = int.parse(_durationController.text.trim());
    final distanceKm = double.parse(_distanceController.text.trim());
    final avgSpeedKn = double.parse(_avgSpeedController.text.trim());
    final maxSpeedKn = double.parse(_maxSpeedController.text.trim());
    final selectedGear = _resolveSelectedGear(gearItems);

    final gearLabel = selectedGear == null
        ? null
        : '${selectedGear.name}${selectedGear.size == null || selectedGear.size!.isEmpty ? '' : ' (${selectedGear.size})'}';

    if (maxSpeedKn < avgSpeedKn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La velocidad maxima debe ser >= velocidad media'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await ref
        .read(sessionsActionsProvider)
        .addSession(
          spotName: _selectedSpotName,
          durationMinutes: durationMinutes,
          distanceKm: distanceKm,
          avgSpeedKn: avgSpeedKn,
          maxSpeedKn: maxSpeedKn,
          gearItemId: selectedGear?.id,
          gearLabel: gearLabel,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> _stopLiveAndSave(List<GearItem> gearItems) async {
    final snapshot = await ref.read(liveSessionProvider.notifier).stop();
    if (snapshot == null) {
      return;
    }

    final selectedGear = _resolveSelectedGear(gearItems);
    final gearLabel = selectedGear == null
        ? null
        : '${selectedGear.name}${selectedGear.size == null || selectedGear.size!.isEmpty ? '' : ' (${selectedGear.size})'}';

    await ref
        .read(sessionsActionsProvider)
        .addSession(
          spotName: _selectedSpotName,
          durationMinutes: snapshot.durationMinutes,
          distanceKm: snapshot.distanceKm,
          avgSpeedKn: snapshot.avgSpeedKn,
          maxSpeedKn: snapshot.maxSpeedKn,
          gearItemId: selectedGear?.id,
          gearLabel: gearLabel,
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sesion en vivo guardada.')));
  }

  Future<void> _importExternalSession(List<GearItem> gearItems) async {
    final source = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.waves),
                title: const Text('WOO'),
                subtitle: const Text('Importar sesion de WOO (demo)'),
                onTap: () => Navigator.of(context).pop('WOO'),
              ),
              ListTile(
                leading: const Icon(Icons.watch_outlined),
                title: const Text('Garmin/Watch'),
                subtitle: const Text('Importar desde reloj (demo)'),
                onTap: () => Navigator.of(context).pop('Garmin/Watch'),
              ),
              ListTile(
                leading: const Icon(Icons.upload_file_outlined),
                title: const Text('Archivo GPX'),
                subtitle: const Text('Importar track real desde .gpx'),
                onTap: () => Navigator.of(context).pop('GPX_FILE'),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      final importService = ref.read(externalSessionImportServiceProvider);
      final imported = source == 'GPX_FILE'
          ? await importService.importFromGpxFile().timeout(
              const Duration(seconds: 12),
            )
          : await importService.importDemo(source: source);

      if (imported == null) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Importacion cancelada.')));
        return;
      }

      final selectedGear = _resolveSelectedGear(gearItems);
      final gearLabel = selectedGear == null
          ? null
          : '${selectedGear.name}${selectedGear.size == null || selectedGear.size!.isEmpty ? '' : ' (${selectedGear.size})'}';

      await ref
          .read(sessionsActionsProvider)
          .addSession(
            spotName: _selectedSpotName,
            durationMinutes: imported.durationMinutes,
            distanceKm: imported.distanceKm,
            avgSpeedKn: imported.avgSpeedKn,
            maxSpeedKn: imported.maxSpeedKn,
            gearItemId: selectedGear?.id,
            gearLabel: gearLabel,
          );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sesion importada desde ${imported.source}.')),
      );
    } on TimeoutException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Importacion tardando demasiado. Intenta otro archivo.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importando sesion externa: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sessionsState = ref.watch(rideSessionsProvider);
    final gearPerformanceState = ref.watch(gearPerformanceSummariesProvider);
    final gearItemsState = ref.watch(gearItemsProvider);
    final liveState = ref.watch(liveSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sesion en vivo (GPS)', style: textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  SessionStatsCard(
                    title: liveState.isTracking
                        ? 'Grabando en curso'
                        : 'Sin grabacion activa',
                    value:
                        '${liveState.distanceKm.toStringAsFixed(2)} km | ${liveState.currentSpeedKn.toStringAsFixed(1)} kn',
                    detail:
                        '${liveState.elapsed.inMinutes} min | max ${liveState.maxSpeedKn.toStringAsFixed(1)} kn',
                    icon: Icons.gps_fixed,
                    trailing: AlertBadge(
                      label: liveState.hasSignal ? 'GPS OK' : 'Sin señal',
                      level: liveState.hasSignal
                          ? AlertLevel.info
                          : AlertLevel.warning,
                    ),
                  ),
                  if (liveState.isTracking && !liveState.hasSignal) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Sin senal GPS reciente. Busca cielo abierto y verifica ubicacion activa.',
                      style: textTheme.bodySmall,
                    ),
                  ],
                  if (liveState.error != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(liveState.error!, style: textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (liveState.error!.contains('Permiso'))
                          OutlinedButton.icon(
                            onPressed: () {
                              Geolocator.openAppSettings();
                            },
                            icon: const Icon(Icons.settings),
                            label: const Text('Abrir ajustes'),
                          ),
                        if (liveState.error!.contains('Activa ubicacion'))
                          OutlinedButton.icon(
                            onPressed: () {
                              Geolocator.openLocationSettings();
                            },
                            icon: const Icon(Icons.location_on_outlined),
                            label: const Text('Activar ubicacion'),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: liveState.isTracking
                              ? null
                              : () {
                                  ref
                                      .read(liveSessionProvider.notifier)
                                      .start();
                                },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Iniciar GPS'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: !liveState.isTracking
                              ? null
                              : () {
                                  _stopLiveAndSave(
                                    gearItemsState.valueOrNull ?? const [],
                                  );
                                },
                          icon: const Icon(Icons.stop),
                          label: const Text('Detener y guardar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: !liveState.isTracking
                          ? null
                          : () {
                              ref.read(liveSessionProvider.notifier).cancel();
                            },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar sesion en vivo'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Conector real WOO/Watch llega en fase 2.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.link),
                          label: const Text('Conectar dispositivo'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isImporting
                              ? null
                              : () {
                                  _importExternalSession(
                                    gearItemsState.valueOrNull ?? const [],
                                  );
                                },
                          icon: const Icon(Icons.download_for_offline_outlined),
                          label: Text(
                            _isImporting ? 'Importando...' : 'Importar externa',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar sesion local',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSpotName,
                      decoration: const InputDecoration(labelText: 'Spot'),
                      items: SpainInitialSpots.all
                          .map(
                            (spot) => DropdownMenuItem<String>(
                              value: spot.name,
                              child: Text('${spot.name} (${spot.province})'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSpotName = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    gearItemsState.when(
                      data: (items) {
                        final selectedId = _selectedGearItemId;
                        final hasSelected =
                            selectedId != null &&
                            items.any((item) => item.id == selectedId);

                        return DropdownButtonFormField<int?>(
                          initialValue: hasSelected ? selectedId : null,
                          decoration: const InputDecoration(
                            labelText: 'Equipo usado (opcional)',
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text('Sin equipo'),
                            ),
                            ...items.map(
                              (item) => DropdownMenuItem<int?>(
                                value: item.id,
                                child: Text(
                                  '${item.name} (${item.type})${item.isPrimary ? ' ⭐' : ''}',
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGearItemId = value;
                            });
                          },
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        child: LinearProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Text(
                        'Equipo no disponible: $error',
                        style: textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duracion (min)',
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Introduce una duracion valida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _distanceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Distancia (km)',
                            ),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Valor invalido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: TextFormField(
                            controller: _avgSpeedController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Media (kn)',
                            ),
                            validator: (value) {
                              final parsed = double.tryParse(value ?? '');
                              if (parsed == null || parsed <= 0) {
                                return 'Valor invalido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _maxSpeedController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Maxima (kn)',
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Introduce una velocidad maxima valida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () {
                                _addSession(
                                  gearItemsState.valueOrNull ?? const [],
                                );
                              },
                        icon: const Icon(Icons.add),
                        label: Text(
                          _isSaving ? 'Guardando...' : 'Guardar sesion',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Sesiones recientes', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          sessionsState.when(
            data: (sessions) {
              if (sessions.isEmpty) {
                return const Text('Todavia no hay sesiones guardadas.');
              }

              return Column(
                children: sessions
                    .map(
                      (session) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SessionStatsCard(
                          title: session.spotName,
                          value:
                              '${session.maxSpeedKn.toStringAsFixed(1)} kn max',
                          detail:
                              '${DateFormat('dd/MM HH:mm').format(session.startedAt)}  ${session.durationMinutes} min  ${session.distanceKm.toStringAsFixed(1)} km  media ${session.avgSpeedKn.toStringAsFixed(1)} kn${session.gearLabel == null || session.gearLabel!.isEmpty ? '' : '  equipo ${session.gearLabel}'}',
                          icon: Icons.route,
                          trailing: IconButton(
                            onPressed: () {
                              ref
                                  .read(sessionsActionsProvider)
                                  .deleteSession(session.id);
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Text('Error cargando sesiones: $error'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rendimiento por equipo',
                  style: textTheme.titleLarge,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: _isExporting
                    ? null
                    : () {
                        _shareSummary();
                      },
                icon: const Icon(Icons.ios_share_outlined),
                label: Text(
                  _isExporting ? 'Compartiendo...' : 'Compartir resumen',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          gearPerformanceState.when(
            data: (summaries) {
              if (summaries.isEmpty) {
                return const Text('Sin datos de rendimiento por equipo.');
              }

              return Column(
                children: summaries
                    .take(6)
                    .map(
                      (summary) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SessionStatsCard(
                          title: summary.gearLabel,
                          value:
                              '${summary.bestSpeedKn.toStringAsFixed(1)} kn mejor',
                          detail:
                              '${summary.sessionsCount} ses.  ${summary.totalDistanceKm.toStringAsFixed(1)} km',
                          icon: Icons.sailing,
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
                Text('Error de rendimiento por equipo: $error'),
          ),
        ],
      ),
    );
  }
}
