import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class FocusArea {
  const FocusArea({
    required this.title,
    required this.dailyTarget,
    required this.workedToday,
    required this.priority,
  });

  final String title;
  final Duration dailyTarget;
  final Duration workedToday;
  final int priority;

  bool get isCompleted => workedToday >= dailyTarget;

  double get progress {
    if (dailyTarget.inMinutes == 0) return 1;
    return (workedToday.inMinutes / dailyTarget.inMinutes).clamp(0, 1);
  }
}

class FocusAreas extends StatelessWidget {
  const FocusAreas({required this.areas, this.onAreaPressed, super.key});

  final List<FocusArea> areas;
  final ValueChanged<FocusArea>? onAreaPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final sortedAreas = [...areas]
      ..sort((first, second) => first.priority.compareTo(second.priority));
    final backgroundColor = Color.alphaBlend(
      colors.primary.withValues(alpha: 0.07),
      colors.surfaceContainerLow,
    );

    return Card(
      color: backgroundColor,
      elevation: 1,
      shadowColor: colors.shadow.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(color: colors.primary.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Focus areas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            if (sortedAreas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  'No focus areas configured.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...List.generate(sortedAreas.length, (index) {
                final area = sortedAreas[index];

                return Column(
                  children: [
                    _FocusAreaRow(
                      area: area,
                      onPressed: onAreaPressed == null
                          ? null
                          : () => onAreaPressed!(area),
                    ),
                    if (index < sortedAreas.length - 1)
                      Divider(color: colors.outlineVariant),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _FocusAreaRow extends StatelessWidget {
  const _FocusAreaRow({required this.area, this.onPressed});

  final FocusArea area;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completed = area.isCompleted;

    return Semantics(
      button: onPressed != null,
      label:
          '${area.title}: ${_formatDuration(area.workedToday)} of ${_formatDuration(area.dailyTarget)}',
      value: completed ? 'Daily target completed' : 'Daily target in progress',
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.control,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      area.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (completed)
                    Icon(Icons.check_circle, size: 20, color: colors.primary)
                  else
                    Text(
                      '${(area.progress * 100).round()}%',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${_formatDuration(area.workedToday)} today · ${_formatDuration(area.dailyTarget)}/day target',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              LinearProgressIndicator(
                value: area.progress,
                minHeight: 6,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.full),
                ),
              ),
            ],
          ),
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
