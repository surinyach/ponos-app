import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class ConsistencyDay {
  const ConsistencyDay({
    required this.label,
    required this.isCompleted,
    this.isToday = false,
  });

  final String label;
  final bool isCompleted;
  final bool isToday;
}

class StreakConsistency extends StatelessWidget {
  const StreakConsistency({
    required this.dailyStreak,
    required this.weeklyStreak,
    required this.week,
    super.key,
  });

  final int dailyStreak;
  final int weeklyStreak;
  final List<ConsistencyDay> week;

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
            Text(
              'Streak consistency',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final streaks = Row(
                  children: [
                    Expanded(
                      child: _StreakMetric(
                        icon: Icons.local_fire_department_outlined,
                        value:
                            '$dailyStreak ${dailyStreak == 1 ? 'day' : 'days'}',
                        label: 'Daily streak',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _StreakMetric(
                        icon: Icons.date_range_outlined,
                        value:
                            '$weeklyStreak ${weeklyStreak == 1 ? 'week' : 'weeks'}',
                        label: 'Weekly streak',
                      ),
                    ),
                  ],
                );
                final weekPreview = _WeekPreview(week: week);

                if (constraints.maxWidth >= 700) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: streaks),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(child: weekPreview),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    streaks,
                    const SizedBox(height: AppSpacing.md),
                    weekPreview,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakMetric extends StatelessWidget {
  const _StreakMetric({
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.09),
        borderRadius: AppRadius.control,
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: colors.secondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.secondary,
                  ),
                ),
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekPreview extends StatelessWidget {
  const _WeekPreview({required this.week});

  final List<ConsistencyDay> week;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completedDays = week.where((day) => day.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$completedDays of ${week.length} days completed this week',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: week
              .map((day) => _DayIndicator(day: day))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _DayIndicator extends StatelessWidget {
  const _DayIndicator({required this.day});

  final ConsistencyDay day;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fillColor = day.isCompleted
        ? colors.primary
        : colors.surfaceContainerHighest;

    return Semantics(
      label: '${day.label}: ${day.isCompleted ? 'completed' : 'not completed'}',
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: fillColor,
              shape: BoxShape.circle,
              border: day.isToday
                  ? Border.all(color: colors.secondary, width: 2)
                  : null,
            ),
            child: day.isCompleted
                ? Icon(Icons.check, size: 16, color: colors.onPrimary)
                : null,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            day.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: day.isToday ? colors.secondary : colors.onSurfaceVariant,
              fontWeight: day.isToday ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}
