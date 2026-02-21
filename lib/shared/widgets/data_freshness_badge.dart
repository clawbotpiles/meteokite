import 'package:flutter/material.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';

class DataFreshnessBadge extends StatelessWidget {
  const DataFreshnessBadge({required this.timestamp, super.key});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final ts = timestamp.toUtc();
    final minutes = now.difference(ts).inMinutes;

    if (minutes <= 10) {
      return const AlertBadge(label: 'Dato reciente', level: AlertLevel.info);
    }

    if (minutes <= 60) {
      return AlertBadge(
        label: 'Actualizado hace $minutes min',
        level: AlertLevel.info,
      );
    }

    if (minutes <= 180) {
      return AlertBadge(
        label: 'Dato con retraso ($minutes min)',
        level: AlertLevel.warning,
      );
    }

    return AlertBadge(
      label: 'Dato antiguo ($minutes min)',
      level: AlertLevel.critical,
    );
  }
}
