import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/spots/presentation/pages/wind_map_page.dart';

class SpotDetailPage extends StatefulWidget {
  const SpotDetailPage({
    super.key,
    required this.name,
    required this.area,
    required this.isCustom,
  });

  final String name;
  final String area;
  final bool isCustom;

  @override
  State<SpotDetailPage> createState() => _SpotDetailPageState();
}

class _SpotDetailPageState extends State<SpotDetailPage> {
  _SpotDetailSection _section = _SpotDetailSection.prevision;
  String _forecastProvider = 'Open-Meteo';
  String _forecastModel = 'GFS';
  String _selectedStation = 'AEMET Oliva';
  _WindSpeedUnit _windSpeedUnit = _WindSpeedUnit.knots;

  List<_ForecastRow> _rowsForProvider(String provider) {
    switch (provider) {
      case 'AEMET':
        return const [
          _ForecastRow(
            hour: '08:00',
            windKnots: 13,
            gustKnots: 18,
            windDeg: 72,
            tempC: 22,
            pressureHpa: 1016,
            cloudCoverPct: 18,
            waveM: 0.9,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '11:00',
            windKnots: 16,
            gustKnots: 22,
            windDeg: 75,
            tempC: 23,
            pressureHpa: 1015,
            cloudCoverPct: 26,
            waveM: 1.1,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '14:00',
            windKnots: 18,
            gustKnots: 25,
            windDeg: 82,
            tempC: 25,
            pressureHpa: 1013,
            cloudCoverPct: 42,
            waveM: 1.3,
            rainMm: 0.2,
          ),
          _ForecastRow(
            hour: '17:00',
            windKnots: 15,
            gustKnots: 20,
            windDeg: 68,
            tempC: 24,
            pressureHpa: 1012,
            cloudCoverPct: 35,
            waveM: 1.0,
            rainMm: 0.0,
          ),
        ];
      case 'Windguru':
        return const [
          _ForecastRow(
            hour: '08:00',
            windKnots: 14,
            gustKnots: 19,
            windDeg: 90,
            tempC: 22,
            pressureHpa: 1016,
            cloudCoverPct: 12,
            waveM: 1.0,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '11:00',
            windKnots: 17,
            gustKnots: 24,
            windDeg: 95,
            tempC: 24,
            pressureHpa: 1014,
            cloudCoverPct: 20,
            waveM: 1.2,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '14:00',
            windKnots: 20,
            gustKnots: 28,
            windDeg: 102,
            tempC: 26,
            pressureHpa: 1012,
            cloudCoverPct: 38,
            waveM: 1.4,
            rainMm: 0.1,
          ),
          _ForecastRow(
            hour: '17:00',
            windKnots: 16,
            gustKnots: 21,
            windDeg: 88,
            tempC: 24,
            pressureHpa: 1011,
            cloudCoverPct: 30,
            waveM: 1.1,
            rainMm: 0.0,
          ),
        ];
      default:
        return const [
          _ForecastRow(
            hour: '08:00',
            windKnots: 12,
            gustKnots: 17,
            windDeg: 70,
            tempC: 21,
            pressureHpa: 1017,
            cloudCoverPct: 22,
            waveM: 0.8,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '11:00',
            windKnots: 15,
            gustKnots: 21,
            windDeg: 76,
            tempC: 23,
            pressureHpa: 1015,
            cloudCoverPct: 33,
            waveM: 1.0,
            rainMm: 0.0,
          ),
          _ForecastRow(
            hour: '14:00',
            windKnots: 19,
            gustKnots: 26,
            windDeg: 84,
            tempC: 25,
            pressureHpa: 1013,
            cloudCoverPct: 47,
            waveM: 1.3,
            rainMm: 0.3,
          ),
          _ForecastRow(
            hour: '17:00',
            windKnots: 14,
            gustKnots: 19,
            windDeg: 72,
            tempC: 23,
            pressureHpa: 1012,
            cloudCoverPct: 36,
            waveM: 1.0,
            rainMm: 0.0,
          ),
        ];
    }
  }

  List<_NearbyStation> _nearbyStations() {
    return const [
      _NearbyStation(name: 'AEMET Oliva', distanceKm: 4.2, provider: 'AEMET'),
      _NearbyStation(
        name: 'Meteo Piles',
        distanceKm: 6.8,
        provider: 'Open-Meteo',
      ),
      _NearbyStation(
        name: 'Sensor Xeraco',
        distanceKm: 11.3,
        provider: 'Windguru',
      ),
      _NearbyStation(
        name: 'Boya Gandia',
        distanceKm: 15.1,
        provider: 'Puertos del Estado',
      ),
    ];
  }

  Map<String, _StationLiveData> _liveDataByStation() {
    return const {
      'AEMET Oliva': _StationLiveData(
        windKnots: 17,
        windDeg: 96,
        gustKnots: 23,
        tempC: 24.2,
        pressureHpa: 1013,
        humidityPct: 61,
        rainMm: 0.0,
      ),
      'Meteo Piles': _StationLiveData(
        windKnots: 15,
        windDeg: 88,
        gustKnots: 20,
        tempC: 23.7,
        pressureHpa: 1012,
        humidityPct: 64,
        rainMm: 0.0,
      ),
      'Sensor Xeraco': _StationLiveData(
        windKnots: 19,
        windDeg: 102,
        gustKnots: 27,
        tempC: 25.1,
        pressureHpa: 1011,
        humidityPct: 58,
        rainMm: 0.2,
      ),
      'Boya Gandia': _StationLiveData(
        windKnots: 21,
        windDeg: 110,
        gustKnots: 29,
        tempC: 24.6,
        pressureHpa: 1011,
        humidityPct: 66,
        rainMm: 0.1,
      ),
    };
  }

  _StationLiveData _selectedLiveData() {
    return _liveDataByStation()[_selectedStation] ??
        const _StationLiveData(
          windKnots: 0,
          windDeg: 0,
          gustKnots: 0,
          tempC: 0,
          pressureHpa: 0,
          humidityPct: 0,
          rainMm: 0,
        );
  }

  int _toBeaufort(int knots) {
    if (knots < 1) return 0;
    if (knots < 4) return 1;
    if (knots < 7) return 2;
    if (knots < 11) return 3;
    if (knots < 17) return 4;
    if (knots < 22) return 5;
    if (knots < 28) return 6;
    if (knots < 34) return 7;
    if (knots < 41) return 8;
    if (knots < 48) return 9;
    if (knots < 56) return 10;
    if (knots < 64) return 11;
    return 12;
  }

  String _formatWind(int knots) {
    switch (_windSpeedUnit) {
      case _WindSpeedUnit.knots:
        return '$knots kt';
      case _WindSpeedUnit.kmh:
        return '${(knots * 1.852).toStringAsFixed(1)} km/h';
      case _WindSpeedUnit.mph:
        return '${(knots * 1.15078).toStringAsFixed(1)} mph';
      case _WindSpeedUnit.beaufort:
        return '${_toBeaufort(knots)} Bft';
    }
  }

  Widget _liveMetric(String label, String value) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildWindRose(_StationLiveData data) {
    final navigability = switch (data.windKnots) {
      >= 14 && <= 26 => (
        label: 'Navegable',
        color: const Color(0xFF2E7D32),
        icon: Icons.check_circle,
      ),
      >= 10 && < 14 || > 26 && <= 32 => (
        label: 'Condicional',
        color: const Color(0xFFF9A825),
        icon: Icons.warning_amber_rounded,
      ),
      _ => (
        label: 'No navegable',
        color: const Color(0xFFC62828),
        icon: Icons.block,
      ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Chip(
              avatar: Icon(navigability.icon, color: Colors.white, size: 18),
              label: Text(
                navigability.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: navigability.color,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1.2,
                      ),
                    ),
                  ),
                  const Positioned(top: 8, child: Text('N')),
                  const Positioned(bottom: 8, child: Text('S')),
                  const Positioned(left: 10, child: Text('W')),
                  const Positioned(right: 10, child: Text('E')),
                  Transform.rotate(
                    angle: (data.windDeg * math.pi) / 180,
                    child: const Icon(Icons.near_me_rounded, size: 44),
                  ),
                  Positioned(
                    bottom: 24,
                    child: Text(
                      _formatWind(data.windKnots),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _historicalWindKnots(String stationName) {
    switch (stationName) {
      case 'Meteo Piles':
        return const [9, 10, 11, 12, 14, 13, 15, 16, 14, 13, 12, 11];
      case 'Sensor Xeraco':
        return const [11, 12, 14, 16, 18, 20, 19, 18, 17, 16, 14, 13];
      case 'Boya Gandia':
        return const [12, 14, 15, 16, 19, 21, 22, 20, 18, 17, 16, 15];
      default:
        return const [8, 9, 10, 11, 13, 15, 17, 16, 14, 13, 12, 10];
    }
  }

  Widget _buildHistoricalChart() {
    final points = _historicalWindKnots(_selectedStation);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historico de lecturas reales',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ultimas 12 lecturas de viento (${_formatWind(points.last.round().toInt())})',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: CustomPaint(painter: _HistoryChartPainter(points: points)),
            ),
          ],
        ),
      ),
    );
  }

  Color _windColor(int knots) {
    if (knots < 10) {
      return const Color(0xFF90CAF9);
    }
    if (knots < 15) {
      return const Color(0xFF64B5F6);
    }
    if (knots < 20) {
      return const Color(0xFF4FC3F7);
    }
    if (knots < 25) {
      return const Color(0xFFFFD54F);
    }
    return const Color(0xFFFF8A65);
  }

  Color _rainColor(double mm) {
    if (mm <= 0) {
      return const Color(0xFFE0E0E0);
    }
    if (mm < 0.5) {
      return const Color(0xFFB3E5FC);
    }
    if (mm < 1.5) {
      return const Color(0xFF81D4FA);
    }
    return const Color(0xFF4FC3F7);
  }

  Widget _labelCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _valueCell(String text, {Color? color, bool bold = false}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: color,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _directionCell(int degrees) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Transform.rotate(
        angle: (degrees * math.pi) / 180,
        child: const Icon(Icons.near_me_rounded, size: 24),
      ),
    );
  }

  Widget _buildWindguruStyleTable() {
    final rows = _rowsForProvider(_forecastProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(98),
        border: TableBorder.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.6,
        ),
        children: [
          TableRow(
            children: [
              _labelCell('Hora'),
              ...rows.map((row) => _valueCell(row.hour, bold: true)),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Viento (kt)'),
              ...rows.map(
                (row) => _valueCell(
                  '${row.windKnots}',
                  color: _windColor(row.windKnots),
                  bold: true,
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Racha (kt)'),
              ...rows.map(
                (row) => _valueCell(
                  '${row.gustKnots}',
                  color: _windColor(row.gustKnots),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Direccion'),
              ...rows.map((row) => _directionCell(row.windDeg)),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Temp (C)'),
              ...rows.map((row) => _valueCell('${row.tempC}')),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Presion (hPa)'),
              ...rows.map((row) => _valueCell('${row.pressureHpa}')),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Cloud cover (%)'),
              ...rows.map((row) => _valueCell('${row.cloudCoverPct}%')),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Oleaje (m)'),
              ...rows.map((row) => _valueCell(row.waveM.toStringAsFixed(1))),
            ],
          ),
          TableRow(
            children: [
              _labelCell('Lluvia'),
              ...rows.map(
                (row) => _valueCell(
                  row.rainMm > 0 ? '${row.rainMm.toStringAsFixed(1)} mm' : '-',
                  color: _rainColor(row.rainMm),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Spot seleccionado')),
      body: ScrollConfiguration(
        behavior: const _NoStretchScrollBehavior(),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(widget.area, style: textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Chip(label: Text(widget.isCustom ? 'Custom' : 'Oficial')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<_SpotDetailSection>(
              segments: const [
                ButtonSegment(
                  value: _SpotDetailSection.prevision,
                  label: Text('Forecast'),
                ),
                ButtonSegment(
                  value: _SpotDetailSection.live,
                  label: Text('Live'),
                ),
                ButtonSegment(
                  value: _SpotDetailSection.webcam,
                  label: Text('Webcam'),
                ),
                ButtonSegment(
                  value: _SpotDetailSection.social,
                  label: Text('Social'),
                ),
              ],
              selected: {_section},
              onSelectionChanged: (value) {
                setState(() {
                  _section = value.first;
                });
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            switch (_section) {
              _SpotDetailSection.prevision => Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _forecastProvider,
                      decoration: const InputDecoration(
                        labelText: 'Proveedor meteo',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Open-Meteo',
                          child: Text('Open-Meteo'),
                        ),
                        DropdownMenuItem(value: 'AEMET', child: Text('AEMET')),
                        DropdownMenuItem(
                          value: 'Windguru',
                          child: Text('Windguru'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _forecastProvider = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String>(
                      initialValue: _forecastModel,
                      decoration: const InputDecoration(
                        labelText: 'Modelo de prevision',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'GFS', child: Text('GFS')),
                        DropdownMenuItem(value: 'AROME', child: Text('AROME')),
                        DropdownMenuItem(value: 'ICON', child: Text('ICON')),
                        DropdownMenuItem(value: 'ECMWF', child: Text('ECMWF')),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _forecastModel = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WindMapPage(spotName: widget.name),
                            ),
                          );
                        },
                        icon: const Icon(Icons.air_outlined),
                        label: const Text('Mapa de viento'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tabla Forecast ($_forecastModel)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _buildWindguruStyleTable(),
                  ],
                ),
              ),
              _SpotDetailSection.live => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStation,
                        decoration: const InputDecoration(
                          labelText: 'Estacion meteorologica cercana',
                          border: OutlineInputBorder(),
                        ),
                        items: _nearbyStations().map((station) {
                          return DropdownMenuItem<String>(
                            value: station.name,
                            child: Text(
                              '${station.name} · ${station.distanceKm.toStringAsFixed(1)} km',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedStation = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _nearbyStations()
                            .firstWhere((s) => s.name == _selectedStation)
                            .provider,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SegmentedButton<_WindSpeedUnit>(
                        segments: const [
                          ButtonSegment(
                            value: _WindSpeedUnit.knots,
                            label: Text('kt'),
                          ),
                          ButtonSegment(
                            value: _WindSpeedUnit.kmh,
                            label: Text('km/h'),
                          ),
                          ButtonSegment(
                            value: _WindSpeedUnit.mph,
                            label: Text('mph'),
                          ),
                          ButtonSegment(
                            value: _WindSpeedUnit.beaufort,
                            label: Text('Bft'),
                          ),
                        ],
                        selected: {_windSpeedUnit},
                        onSelectionChanged: (value) {
                          setState(() {
                            _windSpeedUnit = value.first;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildWindRose(_selectedLiveData()),
                      const SizedBox(height: AppSpacing.sm),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: AppSpacing.sm,
                        crossAxisSpacing: AppSpacing.sm,
                        childAspectRatio: 2.2,
                        children: [
                          _liveMetric(
                            'Viento',
                            _formatWind(_selectedLiveData().windKnots),
                          ),
                          _liveMetric(
                            'Racha',
                            _formatWind(_selectedLiveData().gustKnots),
                          ),
                          _liveMetric(
                            'Temperatura',
                            '${_selectedLiveData().tempC.toStringAsFixed(1)} C',
                          ),
                          _liveMetric(
                            'Presion',
                            '${_selectedLiveData().pressureHpa} hPa',
                          ),
                          _liveMetric(
                            'Humedad',
                            '${_selectedLiveData().humidityPct}%',
                          ),
                          _liveMetric(
                            'Lluvia',
                            '${_selectedLiveData().rainMm.toStringAsFixed(1)} mm',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildHistoricalChart(),
                    ],
                  ),
                ),
              ),
              _SpotDetailSection.webcam => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Webcam: aqui mostraremos camaras disponibles del spot.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
              _SpotDetailSection.social => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'Social: aqui mostraremos actividad social del spot.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _ForecastRow {
  const _ForecastRow({
    required this.hour,
    required this.windKnots,
    required this.gustKnots,
    required this.windDeg,
    required this.tempC,
    required this.pressureHpa,
    required this.cloudCoverPct,
    required this.waveM,
    required this.rainMm,
  });

  final String hour;
  final int windKnots;
  final int gustKnots;
  final int windDeg;
  final int tempC;
  final int pressureHpa;
  final int cloudCoverPct;
  final double waveM;
  final double rainMm;
}

class _NearbyStation {
  const _NearbyStation({
    required this.name,
    required this.distanceKm,
    required this.provider,
  });

  final String name;
  final double distanceKm;
  final String provider;
}

class _StationLiveData {
  const _StationLiveData({
    required this.windKnots,
    required this.windDeg,
    required this.gustKnots,
    required this.tempC,
    required this.pressureHpa,
    required this.humidityPct,
    required this.rainMm,
  });

  final int windKnots;
  final int windDeg;
  final int gustKnots;
  final double tempC;
  final int pressureHpa;
  final int humidityPct;
  final double rainMm;
}

class _HistoryChartPainter extends CustomPainter {
  const _HistoryChartPainter({required this.points});

  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }

    final minV = points.reduce(math.min);
    final maxV = points.reduce(math.max);
    final span = (maxV - minV).abs() < 0.01 ? 1.0 : (maxV - minV);

    final gridPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final y = size.height - ((points[i] - minV) / span) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final stroke = Paint()
      ..color = const Color(0xFF1E88E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawPath(path, stroke);

    final fill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x661E88E5), Color(0x001E88E5)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fill);
  }

  @override
  bool shouldRepaint(covariant _HistoryChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

enum _WindSpeedUnit { knots, kmh, mph, beaufort }

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

enum _SpotDetailSection { prevision, live, webcam, social }
