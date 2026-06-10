import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  group('SpotlightTourController', () {
    late GlobalKey key1;
    late GlobalKey key2;

    setUp(() {
      key1 = GlobalKey();
      key2 = GlobalKey();
    });

    TourConfig buildConfig({
      List<TourStep>? steps,
      VoidCallback? onComplete,
    }) {
      return TourConfig(
        steps: steps ??
            [
              TourStep(targetKey: key1, title: 'Step 1'),
              TourStep(targetKey: key2, title: 'Step 2'),
            ],
        onComplete: onComplete,
      );
    }

    test('starts at step 0 with next enabled when no interaction required', () {
      final controller = SpotlightTourController(config: buildConfig());
      addTearDown(controller.dispose);

      expect(controller.currentIndex, 0);
      expect(controller.canAdvance, isTrue);
      expect(controller.stepCounter, 'Step 1 of 2');
      expect(controller.progressPercent, '50%');
    });

    test('next advances to following step', () async {
      final controller = SpotlightTourController(config: buildConfig());
      addTearDown(controller.dispose);

      await controller.next();
      expect(controller.currentIndex, 1);
    });

    test('back returns to previous step', () async {
      final controller = SpotlightTourController(config: buildConfig());
      addTearDown(controller.dispose);

      await controller.next();
      controller.back();
      expect(controller.currentIndex, 0);
    });

    test('completes on last step', () async {
      var completed = false;
      final controller = SpotlightTourController(
        config: buildConfig(onComplete: () => completed = true),
      );
      addTearDown(controller.dispose);

      await controller.next();
      await controller.next();
      expect(completed, isTrue);
      expect(controller.isDismissed, isTrue);
    });

    test('skip dismisses tour', () {
      var skipped = false;
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [TourStep(targetKey: key1)],
          onSkip: () => skipped = true,
        ),
      );
      addTearDown(controller.dispose);

      controller.skip();
      expect(skipped, isTrue);
      expect(controller.isDismissed, isTrue);
    });

    test('required tap interaction blocks advance until validated', () async {
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [
            TourStep(
              targetKey: key1,
              requiredAction: RequiredAction.tap,
            ),
          ],
        ),
      );
      addTearDown(controller.dispose);

      expect(controller.canAdvance, isFalse);
      controller.onTargetInteraction(RequiredAction.tap);
      await Future<void>.delayed(Duration.zero);
      expect(controller.isDismissed, isTrue);
    });

    test('wrong gesture does not validate', () {
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [
            TourStep(
              targetKey: key1,
              requiredAction: RequiredAction.tap,
            ),
            TourStep(targetKey: key2),
          ],
        ),
      );
      addTearDown(controller.dispose);

      controller.onTargetInteraction(RequiredAction.longPress);
      expect(controller.canAdvance, isFalse);
      expect(controller.currentIndex, 0);
    });

    test('custom validator blocks next until true', () async {
      var actionDone = false;
      final controller = SpotlightTourController(
        config: TourConfig(
          steps: [
            TourStep(
              targetKey: key1,
              validator: () async => actionDone,
            ),
            TourStep(targetKey: key2),
          ],
        ),
      );
      addTearDown(controller.dispose);

      expect(controller.canAdvance, isFalse);
      expect(await controller.next(), isFalse);

      actionDone = true;
      expect(await controller.next(), isTrue);
      expect(controller.currentIndex, 1);
    });
  });
}
