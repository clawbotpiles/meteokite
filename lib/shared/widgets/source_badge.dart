import 'package:flutter/material.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';

class SourceBadge extends StatelessWidget {
  const SourceBadge({required this.source, super.key});

  final String source;

  @override
  Widget build(BuildContext context) {
    final normalized = source.toLowerCase();

    if (normalized.contains('station') || normalized.contains('estacion')) {
      return const AlertBadge(
        label: 'Fuente estacion local',
        level: AlertLevel.info,
      );
    }

    if (normalized.startsWith('cache:')) {
      final cachedSource = source.substring('cache:'.length).toUpperCase();
      return AlertBadge(
        label: 'Fuente cache ($cachedSource)',
        level: AlertLevel.warning,
      );
    }

    if (normalized == 'aemet') {
      return const AlertBadge(label: 'Fuente AEMET', level: AlertLevel.info);
    }

    return const AlertBadge(label: 'Fuente Open-Meteo', level: AlertLevel.info);
  }
}
