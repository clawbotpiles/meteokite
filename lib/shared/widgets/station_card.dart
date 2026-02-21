import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_spacing.dart';
import 'package:meteokite/shared/widgets/alert_badge.dart';
import 'package:meteokite/shared/widgets/data_freshness_badge.dart';
import 'package:meteokite/shared/widgets/source_badge.dart';
import 'package:meteokite/shared/widgets/wind_condition.dart';
import 'package:meteokite/shared/widgets/wind_card.dart';
import 'package:meteokite/shared/widgets/wind_quality.dart';

class StationCard extends StatelessWidget {
  const StationCard({
    required this.stationName,
    required this.province,
    required this.speedKn,
    required this.gustKn,
    required this.directionDeg,
    required this.timestamp,
    this.source = 'station-local',
    super.key,
  });

  final String stationName;
  final String province;
  final double speedKn;
  final double gustKn;
  final int directionDeg;
  final DateTime timestamp;
  final String source;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final condition = WindCondition.fromSpeedKn(speedKn);
    final quality = WindQuality.fromSpeedAndGust(
      speedKn: speedKn,
      gustKn: gustKn,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$stationName ($province)', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            AlertBadge(label: condition.label, level: condition.level),
            AlertBadge(label: quality.label, level: quality.level),
            SourceBadge(source: source),
            DataFreshnessBadge(timestamp: timestamp),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${condition.guidance} ${quality.guidance}',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        WindCard(
          title: 'Lectura actual',
          speedKn: speedKn,
          gustKn: gustKn,
          directionDeg: directionDeg,
          timestamp: timestamp,
          source: source,
        ),
      ],
    );
  }
}
