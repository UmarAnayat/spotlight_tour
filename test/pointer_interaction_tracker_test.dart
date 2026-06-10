import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';
import 'package:spotlight_tour/src/utils/pointer_interaction_tracker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PointerInteractionTracker', () {
    test('detects tap gesture in target rect', () async {
      RequiredAction? detected;
      final tracker = PointerInteractionTracker(
        onInteraction: (action) => detected = action,
      );
      addTearDown(tracker.dispose);

      const rect = Rect.fromLTWH(50, 50, 100, 100);
      const position = Offset(100, 100);

      tracker.trackEvent(
        const PointerDownEvent(position: position),
        rect,
      );
      tracker.trackEvent(
        const PointerUpEvent(position: position),
        rect,
      );

      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(detected, RequiredAction.tap);
    });

    test('ignores events outside target rect', () {
      RequiredAction? detected;
      final tracker = PointerInteractionTracker(
        onInteraction: (action) => detected = action,
      );
      addTearDown(tracker.dispose);

      const rect = Rect.fromLTWH(50, 50, 100, 100);
      const position = Offset(10, 10);

      tracker.trackEvent(
        const PointerDownEvent(position: position),
        rect,
      );
      tracker.trackEvent(
        const PointerUpEvent(position: position),
        rect,
      );

      expect(detected, isNull);
    });
  });
}
