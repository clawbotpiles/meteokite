import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_colors.dart';
import 'package:meteokite/core/theme/app_radius.dart';
import 'package:meteokite/core/theme/app_spacing.dart';

enum AlertLevel { info, warning, critical }

class AlertBadge extends StatelessWidget {
  const AlertBadge({
    required this.label,
    this.level = AlertLevel.info,
    super.key,
  });

  final String label;
  final AlertLevel level;

  @override
  Widget build(BuildContext context) {
    final colors = context.mkColors;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (bg, fg, icon) = switch (level) {
      AlertLevel.info => (
        colors.windLow.withValues(alpha: 0.18),
        colorScheme.onSurface,
        Icons.info_outline,
      ),
      AlertLevel.warning => (
        colors.accent.withValues(alpha: 0.22),
        colorScheme.onSurface,
        Icons.warning_amber_outlined,
      ),
      AlertLevel.critical => (
        colorScheme.error.withValues(alpha: 0.18),
        colorScheme.error,
        Icons.error_outline,
      ),
    };

    return Semantics(
      label: 'Alerta: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: textTheme.labelSmall?.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
