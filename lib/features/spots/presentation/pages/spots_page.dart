import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/features/spots/weather/presentation/providers/weather_providers.dart';
import 'package:meteokite/shared/constants/spots.dart';

class SpotsPage extends ConsumerStatefulWidget {
  const SpotsPage({super.key});

  @override
  ConsumerState<SpotsPage> createState() => _SpotsPageState();
}

class _SpotsPageState extends ConsumerState<SpotsPage> {
  late final List<SpotSeed> _mySpots;

  @override
  void initState() {
    super.initState();
    _mySpots = [];
  }

  Future<void> _openAddSpotPicker() async {
    final selected = await showModalBottomSheet<SpotSeed>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final queryController = TextEditingController();
        var query = '';

        List<SpotSeed> filterSpots() {
          final lower = query.trim().toLowerCase();
          return SpainInitialSpots.all.where((spot) {
            final alreadyAdded = _mySpots.any(
              (s) =>
                  s.name == spot.name &&
                  s.province == spot.province &&
                  s.latitude == spot.latitude &&
                  s.longitude == spot.longitude,
            );
            if (alreadyAdded) {
              return false;
            }
            if (lower.isEmpty) {
              return true;
            }
            final searchable = '${spot.name} ${spot.province}'.toLowerCase();
            return searchable.contains(lower);
          }).toList();
        }

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = filterSpots();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anadir spot',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: queryController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Busca por nombre o provincia',
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            query = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay spots disponibles con ese filtro.',
                                ),
                              )
                            : ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final spot = filtered[index];
                                  return ListTile(
                                    leading: const Icon(Icons.place_outlined),
                                    title: Text(spot.name),
                                    subtitle: Text(spot.province),
                                    onTap: () =>
                                        Navigator.of(context).pop(spot),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _mySpots.add(selected);
    });
    ref.read(selectedWeatherSpotProvider.notifier).state = selected;

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Spot anadido: ${selected.name} (${selected.province})'),
      ),
    );
  }

  void _openWeatherForSpot(SpotSeed spot) {
    ref.read(selectedWeatherSpotProvider.notifier).state = spot;
    context.push(AppRoutes.spotsWeather);
  }

  void _openStationsForSpot(SpotSeed spot) {
    ref.read(selectedWeatherSpotProvider.notifier).state = spot;
    context.push(AppRoutes.spotsStations);
  }

  @override
  Widget build(BuildContext context) {
    final selectedSpot = ref.watch(selectedWeatherSpotProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Spots')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSpotPicker,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text('Mis spots', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Anade spots con el boton + y abre meteo o estaciones desde cada tarjeta.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_mySpots.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const Icon(Icons.place_outlined, size: 36),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Todavia no tienes spots anadidos',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Pulsa el boton + para anadir tu primer spot desde la lista disponible.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.tonalIcon(
                      onPressed: _openAddSpotPicker,
                      icon: const Icon(Icons.add),
                      label: const Text('Anadir spot'),
                    ),
                  ],
                ),
              ),
            )
          else
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey<int>(_mySpots.length),
                children: _mySpots.map((spot) {
                  final isSelected =
                      spot.name == selectedSpot.name &&
                      spot.province == selectedSpot.province;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.place),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    '${spot.name} (${spot.province})',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                if (isSelected)
                                  const Chip(
                                    label: Text('Activo'),
                                    visualDensity: VisualDensity.compact,
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.xs,
                              runSpacing: AppSpacing.xs,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: () => _openWeatherForSpot(spot),
                                  icon: const Icon(Icons.air),
                                  label: const Text('Meteo'),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => _openStationsForSpot(spot),
                                  icon: const Icon(Icons.sensors),
                                  label: const Text('Estaciones'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
