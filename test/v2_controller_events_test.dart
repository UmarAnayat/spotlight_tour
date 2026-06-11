import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  group('V2 controller APIs', () {
    late GlobalKey key1;
    late GlobalKey key2;

    setUp(() {
      key1 = GlobalKey();
      key2 = GlobalKey();
    });

    test('pause and resume block navigation', () async {
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [
            TourStep(targetKey: key1),
            TourStep(targetKey: key2),
          ],
        ),
      );
      addTearDown(controller.dispose);

      controller.pause();
      expect(controller.isPaused, isTrue);
      expect(await controller.next(), isFalse);

      controller.resume();
      expect(controller.isPaused, isFalse);
      expect(await controller.next(), isTrue);
      expect(controller.currentIndex, 1);
    });

    test('previous and finish aliases work', () async {
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [
            TourStep(targetKey: key1),
            TourStep(targetKey: key2),
          ],
        ),
      );
      addTearDown(controller.dispose);

      await controller.next();
      controller.previous();
      expect(controller.currentIndex, 0);

      await controller.next();
      controller.finish();
      expect(controller.isDismissed, isTrue);
    });
  });

  group('SpotlightTour.events', () {
    testWidgets('emits tourStarted and stepChanged', (tester) async {
      final events = <TourEvent>[];
      final subscription = SpotlightTour.events.listen(events.add);
      addTearDown(subscription.cancel);

      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SpotlightTour.start(
                  context,
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

      expect(
        events.map((event) => event.type),
        contains(TourEventType.tourStarted),
      );
      expect(
        events.map((event) => event.type),
        contains(TourEventType.stepChanged),
      );

      SpotlightTour.stop();
      await tester.pump();
    });
  });
}
