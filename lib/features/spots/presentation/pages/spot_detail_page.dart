import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/spots/presentation/pages/webcam_player_page.dart';
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
  static const Map<String, List<String>> _providerModels = {
    'Open-Meteo': ['GFS', 'ICON', 'ECMWF'],
    'AEMET': ['AROME', 'HARMONIE', 'ECMWF'],
    'Windguru': ['GFS', 'WRF', 'ICON'],
  };

  _SpotDetailSection _section = _SpotDetailSection.prevision;
  String _forecastProvider = 'Open-Meteo';
  String _forecastModel = 'GFS';
  String _selectedStation = 'AEMET Oliva';
  _WindSpeedUnit _windSpeedUnit = _WindSpeedUnit.knots;
  bool _showForecastOverlay = false;
  _HistoryRange _historyRange = _HistoryRange.h6;
  int _historyReloadVersion = 0;

  bool _alarmsEnabled = false;
  String _alarmStation = 'AEMET Oliva';
  RangeValues _alarmWindRange = const RangeValues(14, 26);
  _AlarmWindow _alarmWindow = _AlarmWindow.min10;
  final List<_SavedAlarm> _savedAlarms = [];
  int? _editingAlarmIndex;

  final TextEditingController _socialPostController = TextEditingController();
  final TextEditingController _socialReplyController = TextEditingController();
  _SocialMediaType _composerMediaType = _SocialMediaType.none;
  int? _replyingPostIndex;
  int? _replyingReplyId;
  int? _editingPostIndex;
  final Map<String, List<_SpotSocialPost>> _socialFeedBySpot = {};

  List<String> get _forecastProviders => _providerModels.keys.toList();

  List<String> _modelsForProvider(String provider) {
    return _providerModels[provider] ?? const [];
  }

  @override
  void dispose() {
    _socialPostController.dispose();
    _socialReplyController.dispose();
    super.dispose();
  }

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

  List<_SpotWebcam> _webcamsForSpot() {
    if (widget.isCustom) {
      return const [];
    }

    final lowerName = widget.name.toLowerCase();
    if (lowerName.contains('oliva')) {
      return const [
        _SpotWebcam(
          name: 'Oliva Norte',
          source: 'SurfCam CV',
          status: 'Online',
          resolution: '1080p',
        ),
        _SpotWebcam(
          name: 'Oliva Paseo',
          source: 'WindCam',
          status: 'Online',
          resolution: '720p',
        ),
      ];
    }

    return const [
      _SpotWebcam(
        name: 'Cam principal',
        source: 'MeteoKite Cams',
        status: 'Online',
        resolution: '720p',
      ),
    ];
  }

  void _openWebcam(_SpotWebcam webcam) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebcamPlayerPage(
          webcamName: webcam.name,
          source: webcam.source,
          status: webcam.status,
          resolution: webcam.resolution,
        ),
      ),
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
        return const [
          9,
          8,
          7,
          10,
          10,
          7,
          7,
          8,
          10,
          5,
          12,
          10,
          8,
          5,
          9,
          6,
          8,
          11,
          9,
          14,
          9,
          11,
          14,
          11,
          11,
          7,
          8,
          11,
          7,
          6,
          6,
          6,
          9,
          10,
          8,
          5,
          4,
          5,
          7,
          9,
          8,
          4,
          4,
          9,
          7,
          10,
          6,
          10,
          6,
          6,
          15,
          15,
          13,
          13,
          10,
          8,
          8,
          12,
          10,
          15,
          5,
        ];
      case 'Sensor Xeraco':
        return const [10, 9, 8, 10, 11, 8, 8, 9, 11, 6, 13, 11, 9, 6, 10, 7];
      case 'Boya Gandia':
        return const [11, 10, 9, 11, 12, 9, 9, 10, 12, 7, 14, 12, 10, 7, 11, 8];
      default:
        return const [8, 7, 7, 9, 10, 7, 7, 8, 10, 5, 12, 10, 8, 5, 9, 6];
    }
  }

  List<double> _movingAverage(List<double> points, {int window = 6}) {
    if (points.isEmpty) return const [];
    final avg = <double>[];
    for (var i = 0; i < points.length; i++) {
      final start = math.max(0, i - window + 1);
      final slice = points.sublist(start, i + 1);
      final sum = slice.fold<double>(0, (acc, v) => acc + v);
      avg.add(sum / slice.length);
    }
    return avg;
  }

  List<String> _timeLabels(
    int count, {
    int startHour = 4,
    int startMinute = 40,
  }) {
    final labels = <String>[];
    var totalMinutes = (startHour * 60) + startMinute;
    for (var i = 0; i < count; i++) {
      final h = (totalMinutes ~/ 60) % 24;
      final m = totalMinutes % 60;
      labels.add(
        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}',
      );
      totalMinutes += 5;
    }
    return labels;
  }

  double _modelFactor(String model) {
    switch (model) {
      case 'AROME':
        return 1.06;
      case 'HARMONIE':
        return 1.04;
      case 'WRF':
        return 1.08;
      case 'ICON':
        return 0.94;
      case 'ECMWF':
        return 1.02;
      default:
        return 1.0;
    }
  }

  double _providerBias(String provider) {
    switch (provider) {
      case 'AEMET':
        return 0.4;
      case 'Windguru':
        return 0.8;
      default:
        return 0.0;
    }
  }

  List<double> _forecastSeriesKnots(int count) {
    final anchors = _rowsForProvider(
      _forecastProvider,
    ).map((row) => row.windKnots.toDouble()).toList();
    if (anchors.isEmpty || count <= 0) return const [];
    if (anchors.length == 1) return List<double>.filled(count, anchors.first);

    final series = <double>[];
    final segments = anchors.length - 1;
    final factor = _modelFactor(_forecastModel);
    final bias = _providerBias(_forecastProvider);

    for (var i = 0; i < count; i++) {
      final progress = count == 1 ? 0.0 : i / (count - 1);
      final raw = progress * segments;
      final left = raw.floor().clamp(0, segments - 1);
      final right = (left + 1).clamp(0, anchors.length - 1);
      final t = raw - left;
      final interpolated = (anchors[left] * (1 - t)) + (anchors[right] * t);
      series.add(((interpolated * factor) + bias).clamp(0.0, 21.0).toDouble());
    }
    return _movingAverage(series, window: 5);
  }

  int _samplesForRange(_HistoryRange range) {
    switch (range) {
      case _HistoryRange.h1:
        return 12;
      case _HistoryRange.h3:
        return 36;
      case _HistoryRange.h6:
        return 72;
      case _HistoryRange.h12:
        return 144;
    }
  }

  List<T> _tail<T>(List<T> list, int count) {
    if (list.length <= count) return List<T>.from(list);
    return list.sublist(list.length - count);
  }

  List<double> _applyRefreshJitter(List<double> points) {
    if (_historyReloadVersion == 0) return points;
    final rnd = math.Random(_historyReloadVersion);
    return points
        .map(
          (value) => (value + ((rnd.nextDouble() * 1.6) - 0.8))
              .clamp(0.0, 21.0)
              .toDouble(),
        )
        .toList();
  }

  ({
    List<double> points,
    List<double> avg,
    List<String> labels,
    List<double>? forecast,
  })
  _historySeriesWindowed() {
    final allPoints = _applyRefreshJitter(
      _historicalWindKnots(_selectedStation),
    );
    final allLabels = _timeLabels(allPoints.length);
    final allForecast = _showForecastOverlay
        ? _forecastSeriesKnots(allPoints.length)
        : null;
    final window = _samplesForRange(_historyRange);
    final points = _tail(allPoints, window);
    final labels = _tail(allLabels, window);
    final forecast = allForecast == null ? null : _tail(allForecast, window);
    return (
      points: points,
      avg: _movingAverage(points),
      labels: labels,
      forecast: forecast,
    );
  }

  Widget _buildInteractiveHistoryChart({
    required List<double> points,
    required List<double> avgPoints,
    required List<String> labels,
    required List<double>? forecastPoints,
    required int markerDirectionDeg,
    double? fixedHeight,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = math.max(
          constraints.maxWidth,
          (points.length * 20.0) + 90,
        );
        final chartHeight = fixedHeight ?? constraints.maxHeight;

        return ClipRect(
          child: InteractiveViewer(
            constrained: false,
            minScale: 0.75,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(64),
            child: SizedBox(
              width: chartWidth,
              height: chartHeight,
              child: CustomPaint(
                painter: _LiveWindChartPainter(
                  points: points,
                  avgPoints: avgPoints,
                  timeLabels: labels,
                  forecastPoints: forecastPoints,
                  markerDirectionDeg: markerDirectionDeg,
                  realLineColor: const Color(0xFF1F1F8F),
                  avgLineColor: const Color(0xFF9E9E9E),
                  forecastLineColor: const Color(0xFFD84315),
                  gridMajorColor: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.35),
                  gridMinorColor: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.16),
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openHistoricalChartFullscreen() async {
    final series = _historySeriesWindowed();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text('Historico · $_selectedStation')),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildInteractiveHistoryChart(
              points: series.points,
              avgPoints: series.avg,
              labels: series.labels,
              forecastPoints: series.forecast,
              markerDirectionDeg: _selectedLiveData().windDeg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoricalChart() {
    final series = _historySeriesWindowed();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historico de viento real · $_selectedStation',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showForecastOverlay = !_showForecastOverlay;
                    });
                  },
                  icon: Icon(
                    _showForecastOverlay
                        ? Icons.show_chart
                        : Icons.add_chart_rounded,
                  ),
                  label: Text(
                    _showForecastOverlay
                        ? 'Ocultar comparativa'
                        : 'Comparar con forecast',
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _historyReloadVersion++;
                    });
                  },
                  child: const Icon(Icons.refresh_rounded),
                ),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    initialValue: _forecastProvider,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Fuente prevision',
                      border: OutlineInputBorder(),
                    ),
                    items: _forecastProviders
                        .map(
                          (provider) => DropdownMenuItem(
                            value: provider,
                            child: Text(provider),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _forecastProvider = value;
                        final models = _modelsForProvider(value);
                        if (!models.contains(_forecastModel) &&
                            models.isNotEmpty) {
                          _forecastModel = models.first;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
                    initialValue:
                        _modelsForProvider(
                          _forecastProvider,
                        ).contains(_forecastModel)
                        ? _forecastModel
                        : _modelsForProvider(_forecastProvider).first,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Modelo de calculo',
                      border: OutlineInputBorder(),
                    ),
                    items: _modelsForProvider(_forecastProvider)
                        .map(
                          (model) => DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _forecastModel = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<_HistoryRange>(
                segments: const [
                  ButtonSegment(value: _HistoryRange.h1, label: Text('1h')),
                  ButtonSegment(value: _HistoryRange.h3, label: Text('3h')),
                  ButtonSegment(value: _HistoryRange.h6, label: Text('6h')),
                  ButtonSegment(value: _HistoryRange.h12, label: Text('12h')),
                ],
                selected: {_historyRange},
                onSelectionChanged: (value) {
                  setState(() {
                    _historyRange = value.first;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 420,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildInteractiveHistoryChart(
                      points: series.points,
                      avgPoints: series.avg,
                      labels: series.labels,
                      forecastPoints: series.forecast,
                      markerDirectionDeg: _selectedLiveData().windDeg,
                      fixedHeight: 420,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      elevation: 2,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Pantalla completa',
                        onPressed: _openHistoricalChartFullscreen,
                        icon: const Icon(Icons.fullscreen_rounded),
                      ),
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

  Widget _buildCustomAlarmsSection() {
    final alarmStations = _nearbyStations().map((s) => s.name).toList();
    if (!alarmStations.contains(_alarmStation) && alarmStations.isNotEmpty) {
      _alarmStation = alarmStations.first;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Alarmas personalizadas',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Switch(
                  value: _alarmsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _alarmsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AbsorbPointer(
              absorbing: !_alarmsEnabled,
              child: Opacity(
                opacity: _alarmsEnabled ? 1 : 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _alarmStation,
                      decoration: const InputDecoration(
                        labelText: 'Estacion meteorologica',
                        border: OutlineInputBorder(),
                      ),
                      items: alarmStations
                          .map(
                            (station) => DropdownMenuItem(
                              value: station,
                              child: Text(station),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _alarmStation = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Rango de viento (kt): ${_alarmWindRange.start.round()} - ${_alarmWindRange.end.round()}',
                    ),
                    RangeSlider(
                      min: 4,
                      max: 40,
                      divisions: 36,
                      values: _alarmWindRange,
                      labels: RangeLabels(
                        '${_alarmWindRange.start.round()} kt',
                        '${_alarmWindRange.end.round()} kt',
                      ),
                      onChanged: (values) {
                        setState(() {
                          _alarmWindRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<_AlarmWindow>(
                      initialValue: _alarmWindow,
                      decoration: const InputDecoration(
                        labelText: 'Persistencia minima',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: _AlarmWindow.min5,
                          child: Text('5 min'),
                        ),
                        DropdownMenuItem(
                          value: _AlarmWindow.min10,
                          child: Text('10 min'),
                        ),
                        DropdownMenuItem(
                          value: _AlarmWindow.min15,
                          child: Text('15 min'),
                        ),
                        DropdownMenuItem(
                          value: _AlarmWindow.min30,
                          child: Text('30 min'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _alarmWindow = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          final alarm = _SavedAlarm(
                            stationName: _alarmStation,
                            windRange: _alarmWindRange,
                            window: _alarmWindow,
                          );
                          if (_editingAlarmIndex != null) {
                            _savedAlarms[_editingAlarmIndex!] = alarm;
                            _editingAlarmIndex = null;
                          } else {
                            _savedAlarms.add(alarm);
                          }
                        });
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: Text(
                        _editingAlarmIndex == null
                            ? 'Guardar alarma'
                            : 'Guardar cambios',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_savedAlarms.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Alarmas guardadas',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              ...List.generate(_savedAlarms.length, (index) {
                final alarm = _savedAlarms[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(alarm.stationName),
                  subtitle: Text(
                    'Viento ${alarm.windRange.start.round()}-${alarm.windRange.end.round()} kt · cada ${_alarmWindowLabel(alarm.window)}',
                  ),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        onPressed: () {
                          setState(() {
                            _editingAlarmIndex = index;
                            _alarmStation = alarm.stationName;
                            _alarmWindRange = alarm.windRange;
                            _alarmWindow = alarm.window;
                          });
                        },
                        icon: const Icon(Icons.edit_rounded),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        onPressed: () {
                          setState(() {
                            _savedAlarms.removeAt(index);
                            if (_editingAlarmIndex == index) {
                              _editingAlarmIndex = null;
                            }
                          });
                        },
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  String _alarmWindowLabel(_AlarmWindow window) {
    switch (window) {
      case _AlarmWindow.min5:
        return '5 min';
      case _AlarmWindow.min10:
        return '10 min';
      case _AlarmWindow.min15:
        return '15 min';
      case _AlarmWindow.min30:
        return '30 min';
    }
  }

  String _socialSpotKey() => '${widget.name}::${widget.area}';

  List<_SpotSocialPost> _socialFeedForSelectedSpot() {
    final key = _socialSpotKey();
    return _socialFeedBySpot.putIfAbsent(key, _seedSocialPostsForSelectedSpot);
  }

  List<_SpotSocialPost> _seedSocialPostsForSelectedSpot() {
    if (widget.isCustom) {
      return [];
    }
    return [
      _SpotSocialPost(
        authorName: 'Sergio M.',
        minutesAgo: 11,
        message:
            'Acabo de salir del agua. Viento side-on limpio y algo de chopi en la orilla.',
      ),
      _SpotSocialPost(
        authorName: 'Clara F.',
        minutesAgo: 29,
        message: 'Hay hueco para aparcar cerca del acceso norte ahora mismo.',
        mediaType: _SocialMediaType.photo,
        replies: [
          _SpotSocialReply(
            id: 1,
            authorName: 'Diego P.',
            minutesAgo: 21,
            message: 'Gracias por el aviso, voy para alla.',
          ),
        ],
      ),
    ];
  }

  void _publishSocialPost() {
    final text = _socialPostController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      final feed = _socialFeedForSelectedSpot();
      if (_editingPostIndex != null) {
        if (_editingPostIndex! < 0 || _editingPostIndex! >= feed.length) {
          _editingPostIndex = null;
          return;
        }
        final current = feed[_editingPostIndex!];
        feed[_editingPostIndex!] = current.copyWith(
          message: text,
          mediaType: _composerMediaType,
        );
      } else {
        feed.insert(
          0,
          _SpotSocialPost(
            authorName: 'Tu perfil',
            minutesAgo: 0,
            message: text,
            mediaType: _composerMediaType,
            isMine: true,
          ),
        );
      }
      _socialPostController.clear();
      _composerMediaType = _SocialMediaType.none;
      _replyingPostIndex = null;
      _replyingReplyId = null;
      _editingPostIndex = null;
      _socialReplyController.clear();
    });
  }

  void _startEditPost(int index) {
    final feed = _socialFeedForSelectedSpot();
    if (index < 0 || index >= feed.length) {
      return;
    }
    final post = feed[index];
    setState(() {
      _editingPostIndex = index;
      _socialPostController.text = post.message;
      _composerMediaType = post.mediaType;
    });
  }

  void _deletePost(int index) {
    setState(() {
      final feed = _socialFeedForSelectedSpot();
      if (index < 0 || index >= feed.length) {
        return;
      }
      feed.removeAt(index);
      if (_editingPostIndex == index) {
        _editingPostIndex = null;
        _socialPostController.clear();
        _composerMediaType = _SocialMediaType.none;
      } else if (_editingPostIndex != null && _editingPostIndex! > index) {
        _editingPostIndex = _editingPostIndex! - 1;
      }
      if (_replyingPostIndex == index) {
        _replyingPostIndex = null;
        _replyingReplyId = null;
        _socialReplyController.clear();
      } else if (_replyingPostIndex != null && _replyingPostIndex! > index) {
        _replyingPostIndex = _replyingPostIndex! - 1;
      }
    });
  }

  _SpotSocialReply? _findReplyById(List<_SpotSocialReply> replies, int id) {
    for (final reply in replies) {
      if (reply.id == id) {
        return reply;
      }
      final nested = _findReplyById(reply.replies, id);
      if (nested != null) {
        return nested;
      }
    }
    return null;
  }

  int _countRepliesCascade(List<_SpotSocialReply> replies) {
    var count = 0;
    for (final reply in replies) {
      count += 1;
      count += _countRepliesCascade(reply.replies);
    }
    return count;
  }

  void _openReplyComposerForPost(int postIndex) {
    setState(() {
      if (_replyingPostIndex == postIndex && _replyingReplyId == null) {
        _replyingPostIndex = null;
        _replyingReplyId = null;
        _socialReplyController.clear();
        return;
      }
      _replyingPostIndex = postIndex;
      _replyingReplyId = null;
      _socialReplyController.clear();
    });
  }

  void _openReplyComposerForReply(int postIndex, int replyId) {
    setState(() {
      if (_replyingPostIndex == postIndex && _replyingReplyId == replyId) {
        _replyingPostIndex = null;
        _replyingReplyId = null;
        _socialReplyController.clear();
        return;
      }
      _replyingPostIndex = postIndex;
      _replyingReplyId = replyId;
      _socialReplyController.clear();
    });
  }

  void _publishReply() {
    final text = _socialReplyController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      final feed = _socialFeedForSelectedSpot();
      final postIndex = _replyingPostIndex;
      if (postIndex == null || postIndex < 0 || postIndex >= feed.length) {
        _replyingPostIndex = null;
        _replyingReplyId = null;
        _socialReplyController.clear();
        return;
      }
      final reply = _SpotSocialReply(
        id: DateTime.now().microsecondsSinceEpoch,
        authorName: 'Tu perfil',
        minutesAgo: 0,
        message: text,
      );

      if (_replyingReplyId == null) {
        feed[postIndex].replies.insert(0, reply);
      } else {
        final target = _findReplyById(
          feed[postIndex].replies,
          _replyingReplyId!,
        );
        if (target == null) {
          feed[postIndex].replies.insert(0, reply);
        } else {
          target.replies.insert(0, reply);
        }
      }
      _socialReplyController.clear();
      _replyingPostIndex = null;
      _replyingReplyId = null;
    });
  }

  Widget _buildReplyComposer() {
    return Column(
      children: [
        TextField(
          controller: _socialReplyController,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escribe tu respuesta...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _replyingPostIndex = null;
                  _replyingReplyId = null;
                  _socialReplyController.clear();
                });
              },
              child: const Text('Cancelar'),
            ),
            const SizedBox(width: AppSpacing.xs),
            FilledButton(onPressed: _publishReply, child: const Text('Enviar')),
          ],
        ),
      ],
    );
  }

  Widget _buildReplyThread(
    _SpotSocialReply reply,
    TextTheme textTheme,
    int postIndex,
    int depth,
  ) {
    final left = AppSpacing.sm + (depth * 14.0);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left, top: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${reply.authorName} · hace ${reply.minutesAgo} min',
            style: textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(reply.message, style: textTheme.bodySmall),
          TextButton.icon(
            onPressed: () => _openReplyComposerForReply(postIndex, reply.id),
            icon: const Icon(Icons.reply_rounded, size: 18),
            label: Text('Responder (${_countRepliesCascade(reply.replies)})'),
          ),
          if (_replyingPostIndex == postIndex && _replyingReplyId == reply.id)
            _buildReplyComposer(),
          ...reply.replies.map(
            (nested) =>
                _buildReplyThread(nested, textTheme, postIndex, depth + 1),
          ),
        ],
      ),
    );
  }

  IconData _mediaIcon(_SocialMediaType type) {
    switch (type) {
      case _SocialMediaType.none:
        return Icons.notes_rounded;
      case _SocialMediaType.photo:
        return Icons.photo_rounded;
      case _SocialMediaType.video:
        return Icons.videocam_rounded;
    }
  }

  String _composerAttachmentText() {
    switch (_composerMediaType) {
      case _SocialMediaType.none:
        return 'Sin adjunto';
      case _SocialMediaType.photo:
        return 'Adjunto: Foto';
      case _SocialMediaType.video:
        return 'Adjunto: Video corto';
    }
  }

  Future<void> _pickComposerAttachment() async {
    final selected = await showModalBottomSheet<_SocialMediaType>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_rounded),
                title: const Text('Adjuntar foto'),
                onTap: () => Navigator.of(context).pop(_SocialMediaType.photo),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_rounded),
                title: const Text('Adjuntar video corto'),
                onTap: () => Navigator.of(context).pop(_SocialMediaType.video),
              ),
              ListTile(
                leading: const Icon(Icons.link_off_rounded),
                title: const Text('Quitar adjunto'),
                onTap: () => Navigator.of(context).pop(_SocialMediaType.none),
              ),
            ],
          ),
        );
      },
    );

    if (selected == null) {
      return;
    }
    setState(() {
      _composerMediaType = selected;
    });
  }

  Widget _buildSocialSection(TextTheme textTheme) {
    final feed = _socialFeedForSelectedSpot();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comunidad del spot', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('${widget.name} · ${widget.area}', style: textTheme.bodySmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Publicar actualizacion', style: textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: _socialPostController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Comparte estado del spot en tiempo real...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickComposerAttachment,
                          icon: const Icon(Icons.attach_file_rounded),
                          label: const Text('Adjuntar foto/video'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _composerAttachmentText(),
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_editingPostIndex != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _editingPostIndex = null;
                                  _socialPostController.clear();
                                  _composerMediaType = _SocialMediaType.none;
                                });
                              },
                              child: const Text('Cancelar edicion'),
                            ),
                          FilledButton.icon(
                            onPressed: _publishSocialPost,
                            icon: const Icon(Icons.send_rounded),
                            label: Text(
                              _editingPostIndex == null
                                  ? 'Publicar'
                                  : 'Guardar cambios',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (feed.isEmpty)
              Text(
                'Aun no hay publicaciones en este spot.',
                style: textTheme.bodyMedium,
              )
            else
              ...List.generate(feed.length, (index) {
                final post = feed[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${post.authorName} · hace ${post.minutesAgo} min',
                                style: textTheme.bodySmall,
                              ),
                            ),
                            if (post.isMine)
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _startEditPost(index);
                                  }
                                  if (value == 'delete') {
                                    _deletePost(index);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Editar'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Eliminar'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        if (post.mediaType != _SocialMediaType.none) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ),
                            child: Center(
                              child: Icon(_mediaIcon(post.mediaType), size: 42),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.xs),
                        Text(post.message, style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.xs),
                        TextButton.icon(
                          onPressed: () => _openReplyComposerForPost(index),
                          icon: const Icon(Icons.forum_rounded),
                          label: Text(
                            'Responder (${_countRepliesCascade(post.replies)})',
                          ),
                        ),
                        if (_replyingPostIndex == index &&
                            _replyingReplyId == null)
                          _buildReplyComposer(),
                        if (post.replies.isNotEmpty)
                          ...post.replies.map(
                            (reply) =>
                                _buildReplyThread(reply, textTheme, index, 0),
                          ),
                      ],
                    ),
                  ),
                );
              }),
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
                      const SizedBox(height: AppSpacing.sm),
                      _buildCustomAlarmsSection(),
                    ],
                  ),
                ),
              ),
              _SpotDetailSection.webcam => Builder(
                builder: (context) {
                  final webcams = _webcamsForSpot();
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Webcams disponibles',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${widget.name} · ${widget.area}',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (webcams.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'No hay webcams disponibles para este spot por ahora.',
                                style: textTheme.bodyMedium,
                              ),
                            )
                          else
                            ...webcams.map(
                              (webcam) => Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: ListTile(
                                  title: Text(webcam.name),
                                  subtitle: Text(
                                    '${webcam.source} · ${webcam.resolution} · ${webcam.status}',
                                  ),
                                  trailing: FilledButton.icon(
                                    onPressed: () => _openWebcam(webcam),
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    label: const Text('Abrir'),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _SpotDetailSection.social => _buildSocialSection(textTheme),
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

class _SpotWebcam {
  const _SpotWebcam({
    required this.name,
    required this.source,
    required this.status,
    required this.resolution,
  });

  final String name;
  final String source;
  final String status;
  final String resolution;
}

enum _HistoryRange { h1, h3, h6, h12 }

enum _AlarmWindow { min5, min10, min15, min30 }

class _SavedAlarm {
  const _SavedAlarm({
    required this.stationName,
    required this.windRange,
    required this.window,
  });

  final String stationName;
  final RangeValues windRange;
  final _AlarmWindow window;
}

enum _SocialMediaType { none, photo, video }

class _SpotSocialPost {
  _SpotSocialPost({
    required this.authorName,
    required this.minutesAgo,
    required this.message,
    this.mediaType = _SocialMediaType.none,
    this.isMine = false,
    List<_SpotSocialReply>? replies,
  }) : replies = List<_SpotSocialReply>.from(replies ?? const []);

  final String authorName;
  final int minutesAgo;
  final String message;
  final _SocialMediaType mediaType;
  final bool isMine;
  final List<_SpotSocialReply> replies;

  _SpotSocialPost copyWith({String? message, _SocialMediaType? mediaType}) {
    return _SpotSocialPost(
      authorName: authorName,
      minutesAgo: minutesAgo,
      message: message ?? this.message,
      mediaType: mediaType ?? this.mediaType,
      isMine: isMine,
      replies: List<_SpotSocialReply>.from(replies),
    );
  }
}

class _SpotSocialReply {
  _SpotSocialReply({
    required this.id,
    required this.authorName,
    required this.minutesAgo,
    required this.message,
    List<_SpotSocialReply>? replies,
  }) : replies = List<_SpotSocialReply>.from(replies ?? const []);

  final int id;
  final String authorName;
  final int minutesAgo;
  final String message;
  final List<_SpotSocialReply> replies;
}

class _LiveWindChartPainter extends CustomPainter {
  const _LiveWindChartPainter({
    required this.points,
    required this.avgPoints,
    required this.timeLabels,
    required this.forecastPoints,
    required this.markerDirectionDeg,
    required this.realLineColor,
    required this.avgLineColor,
    required this.forecastLineColor,
    required this.gridMajorColor,
    required this.gridMinorColor,
    required this.textColor,
  });

  final List<double> points;
  final List<double> avgPoints;
  final List<String> timeLabels;
  final List<double>? forecastPoints;
  final int markerDirectionDeg;
  final Color realLineColor;
  final Color avgLineColor;
  final Color forecastLineColor;
  final Color gridMajorColor;
  final Color gridMinorColor;
  final Color textColor;

  static const _yMin = 0.0;
  static const _yMax = 21.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || size.width <= 0 || size.height <= 0) return;

    final leftPad = 38.0;
    final rightPad = 12.0;
    final topPad = 12.0;
    final bottomPad = 32.0;
    final plot = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );
    if (plot.width <= 0 || plot.height <= 0) return;

    final majorGrid = Paint()
      ..color = gridMajorColor
      ..strokeWidth = 0.8;
    final minorGrid = Paint()
      ..color = gridMinorColor
      ..strokeWidth = 0.6;

    for (var k = _yMin.toInt(); k <= _yMax.toInt(); k++) {
      final t = (k - _yMin) / (_yMax - _yMin);
      final y = plot.bottom - (t * plot.height);
      final isMajor = k % 2 == 0;
      canvas.drawLine(
        Offset(plot.left, y),
        Offset(plot.right, y),
        isMajor ? majorGrid : minorGrid,
      );
      if (!isMajor) continue;
      final tp = TextPainter(
        text: TextSpan(
          text: '$k',
          style: TextStyle(
            fontSize: 10,
            color: textColor.withValues(alpha: 0.8),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(plot.left - tp.width - 4, y - (tp.height / 2)));
    }

    for (var i = 0; i < points.length; i++) {
      if (i % 6 != 0) continue;
      final x = points.length == 1
          ? plot.left
          : plot.left + (plot.width * i / (points.length - 1));
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), majorGrid);
      if (i < timeLabels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: timeLabels[i],
            style: TextStyle(
              fontSize: 10,
              color: textColor.withValues(alpha: 0.86),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - (tp.width / 2), plot.bottom + 6));
      }
    }

    Offset toOffset(int i, double v) {
      final x = points.length == 1
          ? plot.left
          : plot.left + (plot.width * i / (points.length - 1));
      final clamped = v.clamp(_yMin, _yMax);
      final y =
          plot.bottom - ((clamped - _yMin) / (_yMax - _yMin)) * plot.height;
      return Offset(x, y);
    }

    Path buildPath(List<double> values) {
      final path = Path();
      for (var i = 0; i < values.length; i++) {
        final p = toOffset(i, values[i]);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      return path;
    }

    _drawDashedPath(
      canvas,
      buildPath(avgPoints),
      Paint()
        ..color = avgLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawPath(
      buildPath(points),
      Paint()
        ..color = realLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );

    if (forecastPoints != null && forecastPoints!.isNotEmpty) {
      _drawDashedPath(
        canvas,
        buildPath(forecastPoints!),
        Paint()
          ..color = forecastLineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    Color semaforoColor(double knots) {
      if (knots >= 14 && knots <= 26) return const Color(0xFF2E7D32);
      if ((knots >= 10 && knots < 14) || (knots > 26 && knots <= 32)) {
        return const Color(0xFFF9A825);
      }
      return const Color(0xFFC62828);
    }

    final arrowBase = Path()
      ..moveTo(0, -8.5)
      ..lineTo(6.2, 7.0)
      ..lineTo(0, 3.0)
      ..lineTo(-6.2, 7.0)
      ..close();

    for (var i = 0; i < points.length; i++) {
      if (i % 2 != 0) continue;
      final p = toOffset(i, points[i]);
      final markerColor = semaforoColor(points[i]);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate((markerDirectionDeg * math.pi) / 180);
      canvas.drawPath(
        arrowBase,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
      canvas.drawPath(
        arrowBase,
        Paint()
          ..color = markerColor
          ..style = PaintingStyle.fill,
      );
      canvas.restore();
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 5.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = math.min(metric.length, dist + dash);
        canvas.drawPath(metric.extractPath(dist, next), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LiveWindChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.avgPoints != avgPoints ||
        oldDelegate.timeLabels != timeLabels ||
        oldDelegate.forecastPoints != forecastPoints ||
        oldDelegate.markerDirectionDeg != markerDirectionDeg ||
        oldDelegate.realLineColor != realLineColor ||
        oldDelegate.avgLineColor != avgLineColor ||
        oldDelegate.forecastLineColor != forecastLineColor ||
        oldDelegate.gridMajorColor != gridMajorColor ||
        oldDelegate.gridMinorColor != gridMinorColor ||
        oldDelegate.textColor != textColor;
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
