import 'package:flutter/material.dart';
import 'package:meteokite/core/theme/app_spacing.dart';

class SessionStatsCard extends StatelessWidget {
  const SessionStatsCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    this.trailing,
    super.key,
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: textTheme.headlineSmall),
                  Text(detail, style: textTheme.bodySmall),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
