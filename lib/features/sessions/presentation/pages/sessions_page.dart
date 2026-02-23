import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/sessions/presentation/pages/session_detail_page.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key, this.onStartTabChanged});

  final ValueChanged<bool>? onStartTabChanged;

  @override
  State<SessionsPage> createState() => SessionsPageState();
}

class SessionsPageState extends State<SessionsPage> {
  static const String _phoneDeviceId = 'phone-1';

  final List<_LinkedDevice> _devices = [
    const _LinkedDevice(
      id: 'woo-1',
      name: 'Woo Sports 3',
      kind: 'Woo Sports',
      status: 'Conectado',
      lastSync: 'hace 8 min',
    ),
    const _LinkedDevice(
      id: 'watch-1',
      name: 'Apple Watch Ultra',
      kind: 'Apple Watch',
      status: 'Listo',
      lastSync: 'hace 22 min',
    ),
    const _LinkedDevice(
      id: _phoneDeviceId,
      name: 'Telefono del usuario',
      kind: 'Dispositivo Android',
      status: 'Listo',
      lastSync: 'hace 2 min',
    ),
  ];

  String? _selectedDeviceId = 'woo-1';
  _SessionTab _sessionTab = _SessionTab.start;
  String? _lastImportHint;
  final TextEditingController _sessionSearchController =
      TextEditingController();
  String _sessionFilterDevice = 'Todos';
  String _sessionSort = 'Mas recientes';
  final List<_RecordedSession> _sessionFeed = [];
  _SessionCaptureState _captureState = _SessionCaptureState.ready;
  DateTime? _recordingStartedAt;
  Timer? _recordingTicker;

  @override
  void initState() {
    super.initState();
    _ensurePhoneDeviceAvailable();
    _ensureSelectedDevice();
  }

  @override
  void dispose() {
    _recordingTicker?.cancel();
    _sessionSearchController.dispose();
    super.dispose();
  }

  String _autoDetectedDeviceStatus(_LinkedDevice device) {
    if (device.status == 'Pendiente' || device.status == 'Desconectado') {
      return device.status;
    }

    final isSelected = _selectedDeviceId == device.id;
    if (!isSelected) {
      return 'Conectado';
    }

    switch (_captureState) {
      case _SessionCaptureState.ready:
        return 'Listo';
      case _SessionCaptureState.recording:
        return 'Grabando';
      case _SessionCaptureState.finished:
        return 'Sesion finalizada';
      case _SessionCaptureState.syncing:
        return 'Sincronizando';
      case _SessionCaptureState.synced:
        return 'Sincronizado';
    }
  }

  Color _statusChipColor(String status) {
    switch (status) {
      case 'Listo':
      case 'Conectado':
      case 'Sincronizado':
        return const Color(0xFF2E7D32);
      case 'Grabando':
      case 'Sincronizando':
      case 'Sesion finalizada':
        return const Color(0xFF1565C0);
      case 'Pendiente':
        return const Color(0xFFF9A825);
      case 'Desconectado':
      default:
        return const Color(0xFFC62828);
    }
  }

  Future<void> _removeDevice(_LinkedDevice device) async {
    if (device.id == _phoneDeviceId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El telefono del usuario siempre debe estar disponible.',
          ),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar dispositivo'),
          content: Text('¿Quieres eliminar ${device.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _devices.removeWhere((d) => d.id == device.id);
      if (_selectedDeviceId == device.id) {
        _selectedDeviceId = _devices.any((d) => d.id == _phoneDeviceId)
            ? _phoneDeviceId
            : (_devices.isEmpty ? null : _devices.first.id);
      }
      if (_sessionFilterDevice == device.name) {
        _sessionFilterDevice = 'Todos';
      }
    });
  }

  void _ensurePhoneDeviceAvailable() {
    final exists = _devices.any((device) => device.id == _phoneDeviceId);
    if (exists) {
      return;
    }
    _devices.add(
      const _LinkedDevice(
        id: _phoneDeviceId,
        name: 'Telefono del usuario',
        kind: 'Dispositivo Android',
        status: 'Listo',
        lastSync: 'hace 2 min',
      ),
    );
  }

  void _ensureSelectedDevice() {
    final exists = _devices.any((device) => device.id == _selectedDeviceId);
    if (exists) {
      return;
    }
    _selectedDeviceId = _devices.any((d) => d.id == _phoneDeviceId)
        ? _phoneDeviceId
        : (_devices.isEmpty ? null : _devices.first.id);
  }

  List<_LinkedDevice> _devicesForDisplay() {
    final devices = List<_LinkedDevice>.from(_devices);
    devices.sort((a, b) {
      if (a.id == _phoneDeviceId) return -1;
      if (b.id == _phoneDeviceId) return 1;
      return 0;
    });
    return devices;
  }

  Future<void> deleteSelectedDeviceFromToolbar() async {
    final selected = _selectedDevice;
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay dispositivo seleccionado.')),
      );
      return;
    }
    await _removeDevice(selected);
  }

  void addDeviceFromToolbar() {
    _showAddDeviceSheet();
  }

  void _showAddDeviceSheet() {
    final nameController = TextEditingController();
    String kind = 'Woo Sports';

    showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Configurar dispositivo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: kind,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de dispositivo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Woo Sports',
                        child: Text('Woo Sports'),
                      ),
                      DropdownMenuItem(
                        value: 'Apple Watch',
                        child: Text('Apple Watch'),
                      ),
                      DropdownMenuItem(
                        value: 'Smartwatch',
                        child: Text('Smartwatch'),
                      ),
                      DropdownMenuItem(
                        value: 'Dispositivo Android',
                        child: Text('Dispositivo Android'),
                      ),
                      DropdownMenuItem(value: 'SurfR', child: Text('SurfR')),
                      DropdownMenuItem(
                        value: 'Personalizado',
                        child: Text('Personalizado'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setDialogState(() {
                        kind = value;
                        if (nameController.text.trim().isEmpty) {
                          nameController.text = value;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del dispositivo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Vincular'),
                ),
              ],
            );
          },
        );
      },
    ).then((accepted) {
      if (accepted != true) {
        nameController.dispose();
        return;
      }

      final deviceName = nameController.text.trim().isEmpty
          ? kind
          : nameController.text.trim();
      final id =
          '${kind.toLowerCase().replaceAll(' ', '-')}-${DateTime.now().millisecondsSinceEpoch}';
      setState(() {
        _devices.insert(
          0,
          _LinkedDevice(
            id: id,
            name: deviceName,
            kind: kind,
            status: 'Pendiente',
            lastSync: 'recién vinculado',
          ),
        );
        _selectedDeviceId = id;
      });
      nameController.dispose();
    });
  }

  void _importSessionFile() {
    final device = _selectedDevice ?? _devices.first;
    final imported = _mockParseImportedSession(device);
    final baseInsights = SessionInsightData.fromSession(
      title: imported.title,
      deviceName: device.name,
      deviceKind: device.kind,
      endedAt: imported.endedAt,
      durationLabel: _formatDuration(imported.duration),
    );
    final highestJump = imported.jumpHistory
        .map((jump) => jump.heightMeters)
        .fold<double?>(null, (prev, h) => prev == null ? h : math.max(prev, h));
    final highestHangtime = imported.jumpHistory
        .map((jump) => jump.hangtimeSeconds)
        .fold<double?>(null, (prev, t) => prev == null ? t : math.max(prev, t));

    final importedInsights = baseInsights.copyWith(
      jumpsCount: imported.jumpHistory.length,
      maxJumpHeightMeters: highestJump,
      maxHangtimeSeconds: highestHangtime,
      jumpHistory: imported.jumpHistory,
      events: [
        ...baseInsights.events,
        'Sesion importada desde archivo ${imported.fileExtension}',
      ],
    );

    setState(() {
      _lastImportHint =
          'Sesion importada desde ${imported.fileName} (${imported.fileExtension}).';
      _captureState = _SessionCaptureState.ready;
      _recordingStartedAt = null;
      _recordingTicker?.cancel();
      _sessionFeed.insert(
        0,
        _RecordedSession(
          title: imported.title,
          deviceName: device.name,
          endedAt: imported.endedAt,
          duration: imported.duration,
          summary: imported.summary,
          insights: importedInsights,
        ),
      );
      _sessionTab = _SessionTab.mySessions;
    });

    if (Scaffold.maybeOf(context) != null) {
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            'Sesion importada con ${imported.jumpHistory.length} saltos detectados.',
          ),
        ),
      );
    }
  }

  _ImportedSessionResult _mockParseImportedSession(_LinkedDevice device) {
    final endedAt = DateTime.now().subtract(const Duration(minutes: 9));
    final duration = const Duration(minutes: 73, seconds: 18);
    const jumpMoments = [
      182,
      268,
      377,
      491,
      614,
      743,
      877,
      1023,
      1162,
      1299,
      1448,
      1611,
    ];

    final jumpHistory = List<SessionJumpRecord>.generate(jumpMoments.length, (
      index,
    ) {
      final second = jumpMoments[index];
      final minuteLabel =
          '${(second ~/ 60).toString().padLeft(2, '0')}:${(second % 60).toString().padLeft(2, '0')}';
      final height = 4.1 + (index * 0.52) + ((index % 3) * 0.35);
      final hangtime = 2.4 + (index * 0.16) + ((index % 2) * 0.14);
      final fall = 5.4 + (index * 0.19);

      return SessionJumpRecord(
        jumpNumber: index + 1,
        heightMeters: height,
        hangtimeSeconds: hangtime,
        fallSpeedMetersPerSecond: fall,
        timeLabel: minuteLabel,
      );
    });

    return _ImportedSessionResult(
      title: 'Sesion importada en Oliva Norte',
      fileName: 'olive-bigair-track.fit',
      fileExtension: '.fit',
      endedAt: endedAt,
      duration: duration,
      summary:
          'Importada desde archivo del dispositivo ${device.name}. Datos de saltos y telemetria sincronizados.',
      jumpHistory: jumpHistory,
    );
  }

  _LinkedDevice? get _selectedDevice {
    for (final device in _devices) {
      if (device.id == _selectedDeviceId) {
        return device;
      }
    }
    return null;
  }

  Set<String> _selectedDeviceCapabilities() {
    final selected = _selectedDevice;
    if (selected == null) {
      return const <String>{};
    }
    return SessionInsightData.capabilitiesForDeviceKind(selected.kind);
  }

  String _captureButtonLabel() {
    switch (_captureState) {
      case _SessionCaptureState.ready:
        return 'Iniciar sesion';
      case _SessionCaptureState.recording:
        return 'Detener sesion';
      case _SessionCaptureState.finished:
        return 'Subir sesion';
      case _SessionCaptureState.syncing:
        return 'Subiendo...';
      case _SessionCaptureState.synced:
        return 'Nueva sesion';
    }
  }

  IconData _captureButtonIcon() {
    switch (_captureState) {
      case _SessionCaptureState.ready:
        return Icons.play_circle_fill_rounded;
      case _SessionCaptureState.recording:
        return Icons.stop_circle_rounded;
      case _SessionCaptureState.finished:
        return Icons.sync_rounded;
      case _SessionCaptureState.syncing:
        return Icons.sync;
      case _SessionCaptureState.synced:
        return Icons.replay_rounded;
    }
  }

  String _captureStatusText() {
    switch (_captureState) {
      case _SessionCaptureState.ready:
        return _selectedDevice == null
            ? 'Selecciona un dispositivo para grabar en agua.'
            : 'Listo para iniciar con ${_selectedDevice!.name}.';
      case _SessionCaptureState.recording:
        return 'Sesion en curso. Datos de sensores llegando en tiempo real.';
      case _SessionCaptureState.finished:
        return 'Sesion finalizada. Pendiente por subir.';
      case _SessionCaptureState.syncing:
        return 'Subiendo track, eventos y sensores...';
      case _SessionCaptureState.synced:
        return 'Sesion sincronizada correctamente.';
    }
  }

  String _recordingElapsedText() {
    if (_recordingStartedAt == null) {
      return '--:--';
    }
    final elapsed = DateTime.now().difference(_recordingStartedAt!);
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _onSessionControlPressed() async {
    if (_captureState == _SessionCaptureState.ready) {
      if (_selectedDevice == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona un dispositivo primero.')),
        );
        return;
      }
      setState(() {
        _captureState = _SessionCaptureState.recording;
        _recordingStartedAt = DateTime.now();
        _lastImportHint = null;
      });
      _recordingTicker?.cancel();
      _recordingTicker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _captureState != _SessionCaptureState.recording) {
          return;
        }
        setState(() {});
      });
      return;
    }

    if (_captureState == _SessionCaptureState.recording) {
      _recordingTicker?.cancel();
      setState(() {
        _captureState = _SessionCaptureState.finished;
      });
      return;
    }

    if (_captureState == _SessionCaptureState.finished) {
      final config = await _showUploadSessionDialog();
      if (!mounted) {
        return;
      }
      if (config == null) {
        return;
      }

      setState(() {
        _captureState = _SessionCaptureState.syncing;
      });
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        final endedAt = DateTime.now();
        final duration = _recordingStartedAt == null
            ? const Duration()
            : endedAt.difference(_recordingStartedAt!);
        _sessionFeed.insert(
          0,
          _buildRecordedSession(
            config: config,
            endedAt: endedAt,
            duration: duration,
          ),
        );
        _captureState = _SessionCaptureState.synced;
      });
      return;
    }

    if (_captureState == _SessionCaptureState.synced) {
      setState(() {
        _captureState = _SessionCaptureState.ready;
        _recordingStartedAt = null;
      });
    }
  }

  _RecordedSession _buildRecordedSession({
    required ({String spot, String notes}) config,
    required DateTime endedAt,
    required Duration duration,
  }) {
    final title = 'Sesion en ${config.spot}';
    final selectedDevice = _selectedDevice;
    final deviceName = selectedDevice?.name ?? 'Desconocido';
    final deviceKind = selectedDevice?.kind ?? 'Personalizado';

    return _RecordedSession(
      title: title,
      deviceName: deviceName,
      endedAt: endedAt,
      duration: duration,
      summary: config.notes.isEmpty
          ? 'Track sincronizado con sensores de velocidad, GPS y eventos.'
          : config.notes,
      insights: SessionInsightData.fromSession(
        title: title,
        deviceName: deviceName,
        deviceKind: deviceKind,
        endedAt: endedAt,
        durationLabel: _formatDuration(duration),
      ),
    );
  }

  List<_RecordedSession> _filteredSessions() {
    final query = _sessionSearchController.text.trim().toLowerCase();
    var items = _sessionFeed.where((session) {
      final byDevice =
          _sessionFilterDevice == 'Todos' ||
          session.deviceName == _sessionFilterDevice;
      final byQuery =
          query.isEmpty ||
          session.title.toLowerCase().contains(query) ||
          session.summary.toLowerCase().contains(query) ||
          session.deviceName.toLowerCase().contains(query);
      return byDevice && byQuery;
    }).toList();

    if (_sessionSort == 'Mas antiguas') {
      items = items.reversed.toList();
    }
    return items;
  }

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h > 0) {
      return '$h:$m:$s';
    }
    return '$m:$s';
  }

  Future<({String spot, String notes})?> _showUploadSessionDialog() async {
    String spot = 'Oliva Norte';
    String notes = '';

    if (!mounted) {
      return null;
    }

    final result = await showDialog<({String spot, String notes})>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Configurar sesion'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: spot,
                    decoration: const InputDecoration(
                      labelText: 'Spot',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Oliva Norte',
                        child: Text('Oliva Norte'),
                      ),
                      DropdownMenuItem(
                        value: 'Gandia Harbor',
                        child: Text('Gandia Harbor'),
                      ),
                      DropdownMenuItem(
                        value: 'Cullera Beach',
                        child: Text('Cullera Beach'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        spot = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Resumen de sesion (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      notes = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop((spot: spot, notes: notes.trim()));
                  },
                  child: const Text('Subir sesion'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) {
      return null;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ScrollConfiguration(
      behavior: const _NoStretchScrollBehavior(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SegmentedButton<_SessionTab>(
            segments: const [
              ButtonSegment<_SessionTab>(
                value: _SessionTab.start,
                label: Text('Start Session'),
              ),
              ButtonSegment<_SessionTab>(
                value: _SessionTab.mySessions,
                label: Text('My Sessions'),
              ),
            ],
            selected: {_sessionTab},
            onSelectionChanged: (value) {
              setState(() {
                _sessionTab = value.first;
              });
              widget.onStartTabChanged?.call(_sessionTab == _SessionTab.start);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Session', style: textTheme.headlineSmall),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (_sessionTab == _SessionTab.start) ...[
                    Text(
                      'Selecciona el dispositivo vinculado para grabar sesion o importa desde archivo.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Dispositivos vinculados',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (_devices.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'No hay dispositivos vinculados todavia.',
                        ),
                      )
                    else
                      ..._devicesForDisplay().map(
                        (device) => Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      _selectedDeviceId = device.id;
                                      _lastImportHint = null;
                                    });
                                  },
                                  title: Text(device.name),
                                  subtitle: Text(
                                    '${device.kind} · ${device.lastSync}',
                                  ),
                                  trailing: Icon(
                                    _selectedDeviceId == device.id
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                  ),
                                  child: Text(
                                    'Estado del dispositivo',
                                    style: textTheme.labelMedium,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Chip(
                                      avatar: const Icon(
                                        Icons.memory_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        _autoDetectedDeviceStatus(device),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: _statusChipColor(
                                        _autoDetectedDeviceStatus(device),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Builder(
                          builder: (context) {
                            final capabilities = _selectedDeviceCapabilities();
                            final total =
                                SessionInsightData.capabilityOrder.length;
                            final available = capabilities.length;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Capacidades del dispositivo',
                                  style: textTheme.titleMedium,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '$available/$total sensores disponibles',
                                  style: textTheme.bodySmall,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Los KPI se habilitan automaticamente segun los sensores disponibles.',
                                  style: textTheme.bodySmall,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Wrap(
                                  spacing: AppSpacing.xs,
                                  runSpacing: AppSpacing.xs,
                                  children: SessionInsightData.capabilityOrder
                                      .map((key) {
                                        final isAvailable = capabilities
                                            .contains(key);
                                        final label =
                                            SessionInsightData
                                                .capabilityLabels[key] ??
                                            key;
                                        return Chip(
                                          avatar: Icon(
                                            isAvailable
                                                ? Icons.check_circle_rounded
                                                : Icons.cancel_outlined,
                                            size: 16,
                                            color: isAvailable
                                                ? const Color(0xFF2E7D32)
                                                : null,
                                          ),
                                          label: Text(label),
                                          backgroundColor: isAvailable
                                              ? const Color(0x1F2E7D32)
                                              : null,
                                        );
                                      })
                                      .toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Control de sesion',
                              style: textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _captureStatusText(),
                              style: textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                Chip(
                                  avatar: const Icon(
                                    Icons.timer_outlined,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Tiempo: ${_recordingElapsedText()}',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                const Chip(
                                  avatar: Icon(
                                    Icons.gps_fixed_rounded,
                                    size: 18,
                                  ),
                                  label: Text('GPS OK'),
                                ),
                                const Chip(
                                  avatar: Icon(Icons.speed_rounded, size: 18),
                                  label: Text('Sensores OK'),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(64),
                                  textStyle: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                onPressed:
                                    _captureState ==
                                        _SessionCaptureState.syncing
                                    ? null
                                    : _onSessionControlPressed,
                                icon: Icon(_captureButtonIcon(), size: 28),
                                label: Text(_captureButtonLabel()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'O importar sesion de archivo',
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            OutlinedButton.icon(
                              onPressed: _importSessionFile,
                              icon: const Icon(Icons.file_upload_rounded),
                              label: const Text('Importar sesion'),
                            ),
                            if (_lastImportHint != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _lastImportHint!,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _sessionSearchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Buscar sesiones...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 700;

                        final deviceFilter = DropdownButtonFormField<String>(
                          initialValue: _sessionFilterDevice,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Dispositivo',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'Todos',
                              child: Text(
                                'Todos',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ..._devices.map(
                              (d) => DropdownMenuItem(
                                value: d.name,
                                child: Text(
                                  d.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _sessionFilterDevice = value;
                            });
                          },
                        );

                        final sortFilter = DropdownButtonFormField<String>(
                          initialValue: _sessionSort,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Orden',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Mas recientes',
                              child: Text(
                                'Mas recientes',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Mas antiguas',
                              child: Text(
                                'Mas antiguas',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _sessionSort = value;
                            });
                          },
                        );

                        if (narrow) {
                          return Column(
                            children: [
                              deviceFilter,
                              const SizedBox(height: AppSpacing.xs),
                              sortFilter,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: deviceFilter),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(child: sortFilter),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_filteredSessions().isEmpty)
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            'Todavia no hay sesiones finalizadas. Al sincronizar una sesion en Start Session aparecera aqui.',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      )
                    else
                      ..._filteredSessions().map(
                        (session) => Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SessionDetailPage(
                                    title: session.title,
                                    deviceName: session.deviceName,
                                    endedAt: session.endedAt,
                                    durationLabel: _formatDuration(
                                      session.duration,
                                    ),
                                    summary: session.summary,
                                    insights: session.insights,
                                  ),
                                ),
                              );
                            },
                            title: Text(session.title),
                            subtitle: Text(
                              '${session.deviceName} · ${session.endedAt.day.toString().padLeft(2, '0')}/${session.endedAt.month.toString().padLeft(2, '0')} ${session.endedAt.hour.toString().padLeft(2, '0')}:${session.endedAt.minute.toString().padLeft(2, '0')}\n${session.summary}',
                            ),
                            isThreeLine: true,
                            trailing: Chip(
                              label: Text(_formatDuration(session.duration)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportedSessionResult {
  const _ImportedSessionResult({
    required this.title,
    required this.fileName,
    required this.fileExtension,
    required this.endedAt,
    required this.duration,
    required this.summary,
    required this.jumpHistory,
  });

  final String title;
  final String fileName;
  final String fileExtension;
  final DateTime endedAt;
  final Duration duration;
  final String summary;
  final List<SessionJumpRecord> jumpHistory;
}

class _RecordedSession {
  const _RecordedSession({
    required this.title,
    required this.deviceName,
    required this.endedAt,
    required this.duration,
    required this.summary,
    required this.insights,
  });

  final String title;
  final String deviceName;
  final DateTime endedAt;
  final Duration duration;
  final String summary;
  final SessionInsightData insights;
}

class _LinkedDevice {
  const _LinkedDevice({
    required this.id,
    required this.name,
    required this.kind,
    required this.status,
    required this.lastSync,
  });

  final String id;
  final String name;
  final String kind;
  final String status;
  final String lastSync;

  _LinkedDevice copyWith({String? name, String? status}) {
    return _LinkedDevice(
      id: id,
      name: name ?? this.name,
      kind: kind,
      status: status ?? this.status,
      lastSync: lastSync,
    );
  }
}

enum _SessionCaptureState { ready, recording, finished, syncing, synced }

enum _SessionTab { start, mySessions }

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
