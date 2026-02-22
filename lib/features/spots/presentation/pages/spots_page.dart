import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/spots/presentation/pages/spot_detail_page.dart';

class SpotsPage extends StatefulWidget {
  const SpotsPage({super.key});

  @override
  State<SpotsPage> createState() => SpotsPageState();
}

class SpotsPageState extends State<SpotsPage> {
  final List<_SpotItem> _spots = <_SpotItem>[];
  final _searchController = TextEditingController();
  _SpotFilter _filter = _SpotFilter.all;
  _SpotSort _sort = _SpotSort.recent;
  _PendingCardAction _pendingCardAction = _PendingCardAction.none;
  final Set<String> _selectedSpotNames = <String>{};
  String _searchQuery = '';

  List<_SpotItem> get _filteredSpots {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = _spots.where((spot) {
      final matchesQuery = query.isEmpty
          ? true
          : spot.name.toLowerCase().contains(query) ||
                spot.area.toLowerCase().contains(query);
      if (!matchesQuery) {
        return false;
      }

      switch (_filter) {
        case _SpotFilter.all:
          return true;
        case _SpotFilter.official:
          return !spot.isCustom;
        case _SpotFilter.custom:
          return spot.isCustom;
      }
    }).toList();

    filtered.sort((a, b) {
      switch (_sort) {
        case _SpotSort.recent:
          return b.createdAt.compareTo(a.createdAt);
        case _SpotSort.az:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case _SpotSort.za:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      }
    });

    return filtered;
  }

  Future<void> _showAddSpotSheet() async {
    final existingNames = _spots
        .map((spot) => spot.name.trim().toLowerCase())
        .toSet();

    final result = await showModalBottomSheet<_SpotItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _AddSpotSheet(existingSpotNames: existingNames),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _spots.add(result);
    });
  }

  Future<void> _showEditSpotSheet(_SpotItem spot) async {
    if (!spot.isCustom) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo puedes editar spots custom')),
      );
      return;
    }

    final nameController = TextEditingController(text: spot.name);
    final areaController = TextEditingController(text: spot.area);

    final edited = await showModalBottomSheet<_SpotItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final inset = MediaQuery.viewInsetsOf(context).bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md + inset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar spot',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre del spot'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Zona / provincia',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final nextName = nameController.text.trim();
                    final nextArea = areaController.text.trim();
                    if (nextName.isEmpty) {
                      return;
                    }
                    Navigator.of(context).pop(
                      _SpotItem(
                        name: nextName,
                        area: nextArea.isEmpty ? 'Sin zona definida' : nextArea,
                        isCustom: true,
                        createdAt: spot.createdAt,
                      ),
                    );
                  },
                  child: const Text('Guardar cambios'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || edited == null) {
      return;
    }

    final duplicated = _spots.any(
      (entry) =>
          entry != spot &&
          entry.name.trim().toLowerCase() == edited.name.trim().toLowerCase(),
    );
    if (duplicated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ese spot ya esta agregado')),
      );
      return;
    }

    setState(() {
      final index = _spots.indexOf(spot);
      if (index != -1) {
        _spots[index] = edited;
      }
    });
  }

  void editSpotFromToolbar() {
    final customSpots = _spots.where((spot) => spot.isCustom).toList();
    if (customSpots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay spots custom para editar')),
      );
      return;
    }

    setState(() {
      _pendingCardAction = _PendingCardAction.edit;
      _selectedSpotNames.clear();
    });
  }

  void deleteMultipleSpotsFromToolbar() {
    if (_spots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay spots para eliminar')),
      );
      return;
    }

    setState(() {
      _pendingCardAction = _PendingCardAction.deleteMany;
      _selectedSpotNames.clear();
    });
  }

  bool get _isMultiMode => _pendingCardAction == _PendingCardAction.deleteMany;

  void _cancelPendingActionMode() {
    setState(() {
      _pendingCardAction = _PendingCardAction.none;
      _selectedSpotNames.clear();
    });
  }

  Future<void> _applyPendingBatchAction() async {
    if (_selectedSpotNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un spot')),
      );
      return;
    }

    if (_pendingCardAction == _PendingCardAction.deleteMany) {
      setState(() {
        _spots.removeWhere((spot) => _selectedSpotNames.contains(spot.name));
        _pendingCardAction = _PendingCardAction.none;
        _selectedSpotNames.clear();
      });
      return;
    }

    return;
  }

  Future<void> _handleCardTap(_SpotItem spot) async {
    if (_pendingCardAction == _PendingCardAction.none) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SpotDetailPage(
            name: spot.name,
            area: spot.area,
            isCustom: spot.isCustom,
          ),
        ),
      );
      return;
    }

    if (_pendingCardAction == _PendingCardAction.edit) {
      setState(() {
        _pendingCardAction = _PendingCardAction.none;
      });
      await _showEditSpotSheet(spot);
      return;
    }

    if (_pendingCardAction == _PendingCardAction.deleteMany) {
      setState(() {
        if (_selectedSpotNames.contains(spot.name)) {
          _selectedSpotNames.remove(spot.name);
        } else {
          _selectedSpotNames.add(spot.name);
        }
      });
      return;
    }

    return;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        ScrollConfiguration(
          behavior: const _VerticalBounceNoStretchBehavior(),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spots', style: textTheme.headlineSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Aqui mostraremos spots guardados y meteo activa.',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_spots.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Todavia no has agregado spots. Usa el boton + para anadir el primero.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              else ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        key: const Key('spots-filter-all'),
                        label: const Text('Todos'),
                        selected: _filter == _SpotFilter.all,
                        onSelected: (_) {
                          setState(() {
                            _filter = _SpotFilter.all;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ChoiceChip(
                        key: const Key('spots-filter-official'),
                        label: const Text('Oficiales'),
                        selected: _filter == _SpotFilter.official,
                        onSelected: (_) {
                          setState(() {
                            _filter = _SpotFilter.official;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ChoiceChip(
                        key: const Key('spots-filter-custom'),
                        label: const Text('Custom'),
                        selected: _filter == _SpotFilter.custom,
                        onSelected: (_) {
                          setState(() {
                            _filter = _SpotFilter.custom;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  key: const Key('spots-search-input'),
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Buscar spots',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            tooltip: 'Limpiar busqueda',
                            icon: const Icon(Icons.close),
                          ),
                  ),
                ),
                if (_pendingCardAction != _PendingCardAction.none) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(switch (_pendingCardAction) {
                            _PendingCardAction.edit =>
                              'Modo editar: toca un spot custom para editarlo',
                            _PendingCardAction.deleteMany =>
                              'Modo eliminar varios: selecciona spots y aplica',
                            _PendingCardAction.none => '',
                          }, style: textTheme.bodyMedium),
                          if (_isMultiMode) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              '${_selectedSpotNames.length} seleccionados',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _cancelPendingActionMode,
                                  child: const Text('Cancelar'),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                FilledButton(
                                  onPressed: _applyPendingBatchAction,
                                  child: const Text('Aplicar'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        key: const Key('spots-sort-recent'),
                        label: const Text('Recientes'),
                        selected: _sort == _SpotSort.recent,
                        onSelected: (_) {
                          setState(() {
                            _sort = _SpotSort.recent;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ChoiceChip(
                        key: const Key('spots-sort-az'),
                        label: const Text('A-Z'),
                        selected: _sort == _SpotSort.az,
                        onSelected: (_) {
                          setState(() {
                            _sort = _SpotSort.az;
                          });
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ChoiceChip(
                        key: const Key('spots-sort-za'),
                        label: const Text('Z-A'),
                        selected: _sort == _SpotSort.za,
                        onSelected: (_) {
                          setState(() {
                            _sort = _SpotSort.za;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_filteredSpots.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'No hay spots para este filtro.',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ..._filteredSpots.map(
                  (spot) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Card(
                      child: ListTile(
                        selected: _selectedSpotNames.contains(spot.name),
                        leading: const Icon(Icons.place_outlined),
                        title: Text(spot.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(spot.area),
                            const SizedBox(height: AppSpacing.xs),
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                Chip(
                                  label: Text(
                                    spot.isCustom ? 'Custom' : 'Oficial',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: _isMultiMode
                            ? Icon(
                                _selectedSpotNames.contains(spot.name)
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                              )
                            : null,
                        onTap: () => _handleCardTap(spot),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 96),
            ],
          ),
        ),
        Positioned(
          right: AppSpacing.md,
          bottom: AppSpacing.lg,
          child: FloatingActionButton(
            onPressed: _showAddSpotSheet,
            tooltip: 'Agregar spot',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _VerticalBounceNoStretchBehavior extends MaterialScrollBehavior {
  const _VerticalBounceNoStretchBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

enum _PendingCardAction { none, edit, deleteMany }

enum _SpotFilter { all, official, custom }

enum _SpotSort { recent, az, za }

class _SpotItem {
  const _SpotItem({
    required this.name,
    required this.area,
    required this.isCustom,
    required this.createdAt,
  });

  final String name;
  final String area;
  final bool isCustom;
  final DateTime createdAt;
}

class _AvailableSpot {
  const _AvailableSpot({required this.name, required this.area});

  final String name;
  final String area;
}

const _availableSpots = <_AvailableSpot>[
  _AvailableSpot(name: 'Oliva', area: 'Valencia'),
  _AvailableSpot(name: 'Piles', area: 'Valencia'),
  _AvailableSpot(name: 'Punta de los Molinos', area: 'Denia, Alicante'),
  _AvailableSpot(name: 'Calpe', area: 'Alicante'),
  _AvailableSpot(name: 'Altea', area: 'Alicante'),
  _AvailableSpot(name: 'Villajoyosa', area: 'Alicante'),
  _AvailableSpot(name: 'Santa Pola', area: 'Alicante'),
  _AvailableSpot(name: 'Cullera', area: 'Valencia'),
  _AvailableSpot(name: 'Xeraco', area: 'Valencia'),
  _AvailableSpot(name: 'El Perellonet', area: 'Valencia'),
  _AvailableSpot(name: 'Tarifa', area: 'Cadiz'),
];

class _AddSpotSheet extends StatefulWidget {
  const _AddSpotSheet({required this.existingSpotNames});

  final Set<String> existingSpotNames;

  @override
  State<_AddSpotSheet> createState() => _AddSpotSheetState();
}

class _AddSpotSheetState extends State<_AddSpotSheet> {
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  List<_AvailableSpot> _suggestedSpots = const <_AvailableSpot>[];
  _CustomSpotPoint? _customPoint;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final query = _nameController.text.trim().toLowerCase();
    if (query.isEmpty) {
      if (_suggestedSpots.isNotEmpty) {
        setState(() {
          _suggestedSpots = const <_AvailableSpot>[];
        });
      }
      return;
    }

    final next = _availableSpots
        .where(
          (spot) =>
              spot.name.toLowerCase().contains(query) &&
              !widget.existingSpotNames.contains(spot.name.toLowerCase()),
        )
        .take(5)
        .toList();

    setState(() {
      _suggestedSpots = next;
      _error = null;
    });
  }

  void _selectSuggestedSpot(_AvailableSpot spot) {
    _nameController.text = spot.name;
    _areaController.text = spot.area;
    _nameController.selection = TextSelection.collapsed(
      offset: _nameController.text.length,
    );

    setState(() {
      _suggestedSpots = const <_AvailableSpot>[];
      _error = null;
    });
  }

  Future<void> _pickCustomPoint() async {
    final picked = await showDialog<_CustomSpotPoint>(
      context: context,
      builder: (context) => _CustomMapPickerDialog(initialPoint: _customPoint),
    );

    if (!mounted || picked == null) {
      return;
    }

    final approx =
        '${picked.latitude.toStringAsFixed(4)}, ${picked.longitude.toStringAsFixed(4)}';

    setState(() {
      _customPoint = picked;
      _error = null;
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = 'Spot personalizado';
      }
      _areaController.text = 'Punto personalizado ($approx)';
      _suggestedSpots = const <_AvailableSpot>[];
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final area = _areaController.text.trim();
    final normalized = name.toLowerCase();

    if (name.isEmpty) {
      setState(() {
        _error = 'El nombre del spot es obligatorio';
      });
      return;
    }

    if (widget.existingSpotNames.contains(normalized)) {
      setState(() {
        _error = 'Ese spot ya esta agregado';
      });
      return;
    }

    Navigator.of(context).pop(
      _SpotItem(
        name: name,
        area: area.isEmpty ? 'Sin zona definida' : area,
        isCustom: _customPoint != null || !_isKnownAvailableSpot(name),
        createdAt: DateTime.now(),
      ),
    );
  }

  bool _isKnownAvailableSpot(String name) {
    final normalized = name.trim().toLowerCase();
    return _availableSpots.any((spot) => spot.name.toLowerCase() == normalized);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agregar spot', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: _pickCustomPoint,
            icon: const Icon(Icons.map_outlined),
            label: const Text('Personalizado'),
          ),
          if (_customPoint != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Punto del mapa seleccionado',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Nombre del spot'),
          ),
          if (_suggestedSpots.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestedSpots.length,
                  itemBuilder: (context, index) {
                    final spot = _suggestedSpots[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(spot.name),
                      subtitle: Text(spot.area),
                      onTap: () => _selectSuggestedSpot(spot),
                    );
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _areaController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: const InputDecoration(
              labelText: 'Zona / provincia (opcional)',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Guardar spot'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSpotPoint {
  const _CustomSpotPoint({
    required this.latitude,
    required this.longitude,
    required this.xFraction,
    required this.yFraction,
  });

  final double latitude;
  final double longitude;
  final double xFraction;
  final double yFraction;

  LatLng toLatLng() => LatLng(latitude, longitude);
}

class _CustomMapPickerDialog extends StatefulWidget {
  const _CustomMapPickerDialog({this.initialPoint});

  final _CustomSpotPoint? initialPoint;

  @override
  State<_CustomMapPickerDialog> createState() => _CustomMapPickerDialogState();
}

class _CustomMapPickerDialogState extends State<_CustomMapPickerDialog> {
  _CustomSpotPoint? _point;

  @override
  void initState() {
    super.initState();
    _point = widget.initialPoint;
  }

  @override
  Widget build(BuildContext context) {
    final center = _point?.toLatLng() ?? const LatLng(39.5, -0.5);
    final screenSize = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(screenSize.width * 0.94, 760.0);
    final mapHeight = math.min(screenSize.height * 0.62, 520.0);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: dialogWidth,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona punto en el mapa',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: mapHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: center,
                                initialZoom: 7,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName:
                                      'com.example.meteokitev2_0',
                                ),
                              ],
                            ),
                            if (_point != null)
                              Positioned(
                                left:
                                    (_point!.xFraction * constraints.maxWidth)
                                        .clamp(0.0, constraints.maxWidth) -
                                    14,
                                top:
                                    (_point!.yFraction * constraints.maxHeight)
                                        .clamp(0.0, constraints.maxHeight) -
                                    28,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              ),
                            Positioned.fill(
                              child: GestureDetector(
                                key: const Key('custom-map-area'),
                                behavior: HitTestBehavior.translucent,
                                onTapDown: (details) {
                                  final x =
                                      (details.localPosition.dx /
                                              constraints.maxWidth)
                                          .clamp(0.0, 1.0);
                                  final y =
                                      (details.localPosition.dy /
                                              constraints.maxHeight)
                                          .clamp(0.0, 1.0);
                                  final latitude = 44.0 - (y * 9.0);
                                  final longitude = -10.0 + (x * 14.0);

                                  setState(() {
                                    _point = _CustomSpotPoint(
                                      latitude: latitude,
                                      longitude: longitude,
                                      xFraction: x,
                                      yFraction: y,
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _point == null
                    ? 'Sin punto seleccionado'
                    : 'Punto listo para usar',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  FilledButton(
                    onPressed: _point == null
                        ? null
                        : () => Navigator.of(context).pop(_point),
                    child: const Text('Usar punto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
