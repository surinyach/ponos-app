import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/models/focus_area.dart';
import 'state/focus_areas_controller.dart';
import 'state/focus_areas_state.dart';

class FocusAreasPage extends ConsumerWidget {
  const FocusAreasPage({
    this.onCreate,
    this.onAreaSelected,
    this.today,
    super.key,
  });

  final VoidCallback? onCreate;
  final ValueChanged<FocusArea>? onAreaSelected;
  final DateTime? today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(focusAreasProvider);
    final currentDate = today ?? DateTime.now();
    final refresh = ref.read(focusAreasProvider.notifier).refresh;

    return switch (state.status) {
      FocusAreasStatus.loading => const Center(
        child: CircularProgressIndicator(key: Key('focus-areas-loading')),
      ),
      FocusAreasStatus.empty => _EmptyState(onCreate: onCreate),
      FocusAreasStatus.error when state.areas.isEmpty => _ErrorState(
        message: _errorMessage(state.error),
        onRetry: refresh,
      ),
      _ => _AreaList(
        state: state,
        today: currentDate,
        onCreate: onCreate,
        onAreaSelected: onAreaSelected,
        onRefresh: refresh,
      ),
    };
  }
}

class _AreaList extends StatelessWidget {
  const _AreaList({
    required this.state,
    required this.today,
    required this.onRefresh,
    this.onCreate,
    this.onAreaSelected,
  });

  final FocusAreasState state;
  final DateTime today;
  final Future<bool> Function() onRefresh;
  final VoidCallback? onCreate;
  final ValueChanged<FocusArea>? onAreaSelected;

  @override
  Widget build(BuildContext context) {
    final areas = [...state.areas]
      ..sort((a, b) {
        final priority = a.priority.compareTo(b.priority);
        return priority == 0 ? a.id.compareTo(b.id) : priority;
      });
    final scheduled = areas.where((area) => area.targetFor(today) != null);
    final totalMinutes = scheduled.fold(
      0,
      (total, area) => total + area.targetFor(today)!.targetMinutes,
    );
    final busy = {
      FocusAreasStatus.refreshing,
      FocusAreasStatus.saving,
    }.contains(state.status);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth >= 900;
        final padding = constraints.maxWidth < 600
            ? const EdgeInsets.all(AppSpacing.md)
            : AppSpacing.pagePadding;

        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: padding.copyWith(bottom: AppSpacing.sm),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(
                        onCreate: onCreate,
                        onRefresh: busy ? null : onRefresh,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DailySummary(
                        totalMinutes: totalMinutes,
                        scheduledAreas: scheduled.length,
                      ),
                      if (state.status == FocusAreasStatus.error) ...[
                        const SizedBox(height: AppSpacing.md),
                        _ErrorNotice(
                          message: _errorMessage(state.error),
                          onRetry: onRefresh,
                        ),
                      ],
                      if (busy) ...[
                        const SizedBox(height: AppSpacing.md),
                        const LinearProgressIndicator(
                          key: Key('focus-areas-busy'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: padding.copyWith(top: AppSpacing.sm),
                sliver: useGrid
                    ? SliverGrid(
                        key: const Key('focus-areas-grid'),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 128,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.md,
                            ),
                        delegate: _delegate(areas),
                      )
                    : SliverList(
                        key: const Key('focus-areas-list'),
                        delegate: _delegate(areas, addSpacing: true),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverChildBuilderDelegate _delegate(
    List<FocusArea> areas, {
    bool addSpacing = false,
  }) => SliverChildBuilderDelegate(
    (context, index) => Padding(
      padding: EdgeInsets.only(bottom: addSpacing ? AppSpacing.sm : 0),
      child: _AreaCard(
        area: areas[index],
        today: today,
        onPressed: onAreaSelected == null
            ? null
            : () => onAreaSelected!(areas[index]),
      ),
    ),
    childCount: areas.length,
  );
}

class _Header extends StatelessWidget {
  const _Header({this.onCreate, this.onRefresh});
  final VoidCallback? onCreate;
  final Future<bool> Function()? onRefresh;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Focus Areas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Your ongoing commitments, ordered by priority.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        tooltip: 'Refresh Focus Areas',
        onPressed: onRefresh == null ? null : () => onRefresh!(),
        icon: const Icon(Icons.refresh),
      ),
      const SizedBox(width: AppSpacing.xs),
      FilledButton.icon(
        onPressed: onCreate,
        icon: const Icon(Icons.add),
        label: const Text('New area'),
      ),
    ],
  );
}

class _DailySummary extends StatelessWidget {
  const _DailySummary({
    required this.totalMinutes,
    required this.scheduledAreas,
  });
  final int totalMinutes;
  final int scheduledAreas;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.today_outlined, color: colors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Today · ${_duration(totalMinutes)} across '
              '$scheduledAreas ${scheduledAreas == 1 ? 'area' : 'areas'}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({required this.area, required this.today, this.onPressed});
  final FocusArea area;
  final DateTime today;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final target = area.targetFor(today);
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.card,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.control,
                ),
                child: Text(
                  '${area.priority}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      target == null
                          ? 'No target today'
                          : '${_duration(target.targetMinutes)} target today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onPressed != null)
                Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onCreate});
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.track_changes_outlined, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Focus Areas yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text('Create one to define what deserves your time.'),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create Focus Area'),
          ),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Unable to load Focus Areas',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => onRetry(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    ),
  );
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.message, required this.onRetry});
  final String message;
  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.errorContainer,
    child: ListTile(
      leading: const Icon(Icons.error_outline),
      title: Text(message),
      trailing: TextButton(
        onPressed: () => onRetry(),
        child: const Text('Retry'),
      ),
    ),
  );
}

String _errorMessage(Object? error) => switch (error) {
  AppException exception => exception.message,
  _ => 'Focus Areas could not be loaded.',
};

String _duration(int minutes) {
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (hours == 0) return '${remainder}m';
  if (remainder == 0) return '${hours}h';
  return '${hours}h ${remainder}m';
}
