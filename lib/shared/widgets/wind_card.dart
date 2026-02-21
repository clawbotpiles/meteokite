import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/shared/widgets/wind_compass_widget.dart';

class WindCard extends StatelessWidget {
  const WindCard({
    required this.title,
    required this.speedKn,
    required this.gustKn,
    required this.directionDeg,
    required this.timestamp,
    this.source,
    super.key,
  });

  final String title;
  final double speedKn;
  final double gustKn;
  final int directionDeg;
  final DateTime timestamp;
  final String? source;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localTime = DateFormat('dd/MM HH:mm').format(timestamp.toLocal());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${speedKn.toStringAsFixed(1)} kn',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Racha: ${gustKn.toStringAsFixed(1)} kn'),
                  Text('Direccion: $directionDeg°'),
                  Text('Actualizado: $localTime', style: textTheme.bodySmall),
                  if (source != null)
                    Text('Fuente: $source', style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            WindCompassWidget(directionDeg: directionDeg),
          ],
        ),
      ),
    );
  }
}
