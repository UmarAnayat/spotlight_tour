import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  testWidgets('overlay exposes semantics and handles escape', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SpotlightTour.start(
                context,
                steps: [
                  TourStep(
                    targetKey: key,
                    title: 'Search',
                    description: 'Tap search',
                  ),
                ],
              );
            });
            return Scaffold(body: SizedBox(key: key, width: 50, height: 50));
          },
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.bySemanticsLabel(
        RegExp('Onboarding tour step 1 of 1'),
      ),
      findsWidgets,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump();

    expect(SpotlightTour.isActive, isFalse);
  });
}
