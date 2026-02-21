import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/sessions/presentation/providers/sessions_providers.dart';
import 'package:meteokite/shared/constants/spots.dart';
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
  bool _isSaving = false;

  @override
  void dispose() {
    _durationController.dispose();
    _distanceController.dispose();
    _avgSpeedController.dispose();
    _maxSpeedController.dispose();
    super.dispose();
  }

  Future<void> _addSession() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final durationMinutes = int.parse(_durationController.text.trim());
    final distanceKm = double.parse(_distanceController.text.trim());
    final avgSpeedKn = double.parse(_avgSpeedController.text.trim());
    final maxSpeedKn = double.parse(_maxSpeedController.text.trim());

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
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sessionsState = ref.watch(rideSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
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
                        onPressed: _isSaving ? null : _addSession,
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
                              '${DateFormat('dd/MM HH:mm').format(session.startedAt)}  ${session.durationMinutes} min  ${session.distanceKm.toStringAsFixed(1)} km  media ${session.avgSpeedKn.toStringAsFixed(1)} kn',
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
        ],
      ),
    );
  }
}
