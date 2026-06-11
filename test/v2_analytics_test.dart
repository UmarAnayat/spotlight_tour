import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  group('TourAnalytics', () {
    test('fires lifecycle callbacks exactly once', () {
      var started = 0;
      var completed = 0;
      var skipped = 0;
      var stepChanges = 0;

      final analytics = TourAnalytics(
        onTourStarted: () => started++,
        onTourCompleted: () => completed++,
        onTourSkipped: () => skipped++,
        onStepChanged: (_) => stepChanges++,
        emitGlobalEvents: false,
      );

      analytics.tourStarted();
      analytics.tourStarted();
      analytics.stepChanged(0);
      analytics.stepChanged(1);
      analytics.tourCompleted();
      analytics.tourCompleted();
      analytics.tourSkipped();
      analytics.tourSkipped();

      expect(started, 1);
      expect(stepChanges, 2);
      expect(completed, 1);
      expect(skipped, 1);
    });

    testWidgets('SpotlightTour.start fires onTourStarted once', (tester) async {
      var started = 0;
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SpotlightTour.start(
                  context,
                  onTourStarted: () => started++,
                  steps: [TourStep(targetKey: key, title: 'Hello')],
                );
              });
              return Scaffold(body: SizedBox(key: key, width: 40, height: 40));
            },
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(started, 1);
    });
  });
}
