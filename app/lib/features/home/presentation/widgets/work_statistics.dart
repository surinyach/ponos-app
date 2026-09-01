import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class WorkStatistics extends StatelessWidget {
  const WorkStatistics({
    required this.totalDaysWorked,
    required this.totalFocusedTime,
    required this.totalRestTime,
    required this.totalTrackedTime,
    super.key,
  });

  final int totalDaysWorked;
  final Duration totalFocusedTime;
  final Duration totalRestTime;
  final Duration totalTrackedTime;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = Color.alphaBlend(
      colors.secondary.withValues(alpha: 0.07),
      colors.surfaceContainerLow,
    );

    return Card(
      color: backgroundColor,
      elevation: 1,
      shadowColor: colors.shadow.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(color: colors.secondary.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Work statistics',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.full),
                    ),
                  ),
                  child: Text(
                    'All time',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _Statistic(
                    icon: Icons.calendar_today_outlined,
                    value: '$totalDaysWorked',
                    label: 'Days worked',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _Statistic(
                    icon: Icons.timer_outlined,
                    value: _formatDuration(totalFocusedTime),
                    label: 'Focused time',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _Statistic(
                    icon: Icons.self_improvement_outlined,
                    value: _formatDuration(totalRestTime),
                    label: 'Rest time',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _Statistic(
                    icon: Icons.schedule_outlined,
                    value: _formatDuration(totalTrackedTime),
                    label: 'Tracked time',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.secondary.withValues(alpha: 0.08),
          borderRadius: AppRadius.control,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.secondary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
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
}
