import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponos_app/app/app.dart';
import 'package:ponos_app/app/theme/app_colors.dart';
import 'package:ponos_app/app/theme/app_theme.dart';
import 'package:ponos_app/features/home/presentation/widgets/today_summary.dart';
import 'package:ponos_app/features/home/presentation/widgets/todays_objectives.dart';
import 'package:ponos_app/features/home/presentation/widgets/work_statistics.dart';
import 'package:ponos_app/features/home/presentation/widgets/streak_consistency.dart';

void main() {
  testWidgets('shows wide navigation in a wide viewport', (tester) async {
    await tester.pumpWidget(const PonosApp());

    expect(find.text('Ponos'), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);
    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('opens another feature from the navigation bar', (tester) async {
    await tester.pumpWidget(const PonosApp());

    await tester.tap(find.text('Focus'));
    await tester.pumpAndSettle();

    expect(
      find.text('This feature will be shaped in the next step.'),
      findsOneWidget,
    );
  });

  test('light and dark themes use the Ponos palette', () {
    expect(AppTheme.light.colorScheme.primary, AppColors.olive);
    expect(AppTheme.light.colorScheme.secondary, AppColors.bronze);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    expect(AppTheme.dark.useMaterial3, isTrue);
  });

  testWidgets('shows today summary mock values', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: TodaySummary(
            completedObjectives: 3,
            totalObjectives: 5,
            focusedDuration: Duration(hours: 2, minutes: 35),
          ),
        ),
      ),
    );

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.text('2h 35m'), findsOneWidget);
    expect(find.text('Objectives'), findsOneWidget);
    expect(find.text('Focused time'), findsOneWidget);
  });

  testWidgets('shows today objectives and their completion states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: TodaysObjectives(
            objectives: [
              TodayObjective(title: 'Completed objective', isCompleted: true),
              TodayObjective(title: 'Open objective', isCompleted: false),
            ],
          ),
        ),
      ),
    );

    expect(find.text("Today's objectives"), findsOneWidget);
    expect(find.text('Completed objective'), findsOneWidget);
    expect(find.text('Open objective'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
  });

  testWidgets('shows current streak and weekly consistency', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: StreakConsistency(
            dailyStreak: 6,
            weeklyStreak: 3,
            week: [
              ConsistencyDay(label: 'M', isCompleted: true),
              ConsistencyDay(label: 'T', isCompleted: true),
              ConsistencyDay(label: 'W', isCompleted: false, isToday: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Streak consistency'), findsOneWidget);
    expect(find.text('6 days'), findsOneWidget);
    expect(find.text('Daily streak'), findsOneWidget);
    expect(find.text('3 weeks'), findsOneWidget);
    expect(find.text('Weekly streak'), findsOneWidget);
    expect(find.text('2 of 3 days completed this week'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNWidgets(2));
  });

  testWidgets('shows lifetime work statistics', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: WorkStatistics(
            totalDaysWorked: 128,
            totalFocusedTime: Duration(hours: 342, minutes: 30),
            totalRestTime: Duration(hours: 86, minutes: 15),
            totalTrackedTime: Duration(hours: 428, minutes: 45),
          ),
        ),
      ),
    );

    expect(find.text('Work statistics'), findsOneWidget);
    expect(find.text('All time'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('342h 30m'), findsOneWidget);
    expect(find.text('86h 15m'), findsOneWidget);
    expect(find.text('428h 45m'), findsOneWidget);
    expect(find.text('Days worked'), findsOneWidget);
    expect(find.text('Focused time'), findsOneWidget);
    expect(find.text('Rest time'), findsOneWidget);
    expect(find.text('Tracked time'), findsOneWidget);
  });
}
