import 'package:flutter/material.dart';

import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class TodayObjective {
  const TodayObjective({required this.title, required this.isCompleted});

  final String title;
  final bool isCompleted;
}

class TodaysObjectives extends StatelessWidget {
  const TodaysObjectives({
    required this.objectives,
    this.onObjectivePressed,
    this.onCompletionPressed,
    super.key,
  });

  final List<TodayObjective> objectives;
  final ValueChanged<TodayObjective>? onObjectivePressed;
  final ValueChanged<TodayObjective>? onCompletionPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
            Text(
              "Today's objectives",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            if (objectives.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  'No objectives planned for today.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...List.generate(objectives.length, (index) {
                final objective = objectives[index];

                return Column(
                  children: [
                    _ObjectiveRow(
                      objective: objective,
                      onPressed: onObjectivePressed == null
                          ? null
                          : () => onObjectivePressed!(objective),
                      onCompletionPressed: onCompletionPressed == null
                          ? null
                          : () => onCompletionPressed!(objective),
                    ),
                    if (index < objectives.length - 1)
                      Divider(
                        indent: 40 + AppSpacing.sm,
                        color: colors.outlineVariant,
                      ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _ObjectiveRow extends StatelessWidget {
  const _ObjectiveRow({
    required this.objective,
    this.onPressed,
    this.onCompletionPressed,
  });

  final TodayObjective objective;
  final VoidCallback? onPressed;
  final VoidCallback? onCompletionPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final completed = objective.isCompleted;

    return Semantics(
      button: onPressed != null,
      checked: completed,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.control,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              IconButton(
                onPressed: onCompletionPressed,
                tooltip: completed ? 'Mark as incomplete' : 'Mark as complete',
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  completed ? Icons.check_circle : Icons.circle_outlined,
                  color: completed ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  objective.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: completed
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
