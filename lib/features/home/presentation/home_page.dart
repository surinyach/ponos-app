import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import 'widgets/today_summary.dart';
import 'widgets/todays_objectives.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _destinations = <_Destination>[
    _Destination('Overview', Icons.home_outlined, Icons.home),
    _Destination('Objectives', Icons.flag_outlined, Icons.flag),
    _Destination('Focus', Icons.timer_outlined, Icons.timer),
    _Destination(
      'Progress',
      Icons.calendar_month_outlined,
      Icons.calendar_month,
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useNavigationRail = constraints.maxWidth >= 700;
        final content = _selectedIndex == 0
            ? const _OverviewContent()
            : _FeaturePlaceholder(destination: _destinations[_selectedIndex]);

        return Scaffold(
          appBar: AppBar(title: const Text('Ponos')),
          body: useNavigationRail
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: _selectDestination,
                      labelType: NavigationRailLabelType.all,
                      destinations: _destinations
                          .map(
                            (item) => NavigationRailDestination(
                              icon: Icon(item.icon),
                              selectedIcon: Icon(item.selectedIcon),
                              label: Text(item.label),
                            ),
                          )
                          .toList(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: useNavigationRail
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _selectDestination,
                  destinations: _destinations
                      .map(
                        (item) => NavigationDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: item.label,
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }

  void _selectDestination(int index) {
    setState(() => _selectedIndex = index);
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const summary = TodaySummary(
                completedObjectives: 3,
                totalObjectives: 5,
                focusedDuration: Duration(hours: 2, minutes: 35),
              );
              const objectives = TodaysObjectives(
                objectives: [
                  TodayObjective(
                    title: 'Plan the week priorities',
                    isCompleted: true,
                  ),
                  TodayObjective(
                    title: 'Complete the project proposal',
                    isCompleted: false,
                  ),
                  TodayObjective(
                    title: 'Review focus session notes',
                    isCompleted: false,
                  ),
                ],
              );

              if (constraints.maxWidth >= 840) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: summary),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 6, child: objectives),
                  ],
                );
              }

              return const Column(
                children: [
                  summary,
                  SizedBox(height: AppSpacing.md),
                  objectives,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeaturePlaceholder extends StatelessWidget {
  const _FeaturePlaceholder({required this.destination});

  final _Destination destination;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(destination.selectedIcon, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              destination.label,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'This feature will be shaped in the next step.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
