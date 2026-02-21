import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/wind_condition.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';

class StationCard extends StatelessWidget {
  const StationCard({
    required this.stationName,
    required this.province,
    required this.speedKn,
    required this.gustKn,
    required this.directionDeg,
    required this.timestamp,
    super.key,
  });

  final String stationName;
  final String province;
  final double speedKn;
  final double gustKn;
  final int directionDeg;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final condition = WindCondition.fromSpeedKn(speedKn);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$stationName ($province)', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        AlertBadge(label: condition.label, level: condition.level),
        const SizedBox(height: AppSpacing.xs),
        Text(condition.guidance, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        WindCard(
          title: 'Lectura actual',
          speedKn: speedKn,
          gustKn: gustKn,
          directionDeg: directionDeg,
          timestamp: timestamp,
        ),
      ],
    );
  }
}
