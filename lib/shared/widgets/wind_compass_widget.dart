import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_colors.dart';

class WindCompassWidget extends StatelessWidget {
  const WindCompassWidget({required this.directionDeg, super.key});

  final int directionDeg;

  @override
  Widget build(BuildContext context) {
    final colors = context.mkColors;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Direccion del viento $directionDeg grados',
      child: SizedBox(
        width: 92,
        height: 92,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceVariant.withValues(alpha: 0.45),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
            ),
            Transform.rotate(
              angle: directionDeg * math.pi / 180,
              child: Icon(Icons.navigation, size: 36, color: colors.windStrong),
            ),
            Positioned(top: 6, child: Text('N', style: textTheme.labelSmall)),
          ],
        ),
      ),
    );
  }
}
