import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponos_app/app/app.dart';
import 'package:ponos_app/app/theme/app_colors.dart';
import 'package:ponos_app/app/theme/app_theme.dart';
import 'package:ponos_app/features/home/presentation/widgets/today_summary.dart';
import 'package:ponos_app/features/home/presentation/widgets/todays_objectives.dart';

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
}
