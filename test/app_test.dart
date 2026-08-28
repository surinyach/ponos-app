import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponos_app/app/app.dart';

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
}
