import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';
import 'package:spotlight_tour/src/spotlight/spotlight_painter.dart';

void main() {
  group('SpotlightPainter', () {
    test('paints without error for all shapes', () {
      for (final shape in SpotlightShape.values) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        const size = Size(400, 800);
        const targetRect = Rect.fromLTWH(100, 200, 120, 60);

        final painter = SpotlightPainter(
          targetRect: targetRect,
          style: SpotlightStyle(
            shape: shape,
            showGlow: true,
            pulseAnimation: true,
            blurStrength: 4,
          ),
          primaryColor: Colors.blue,
          pulseValue: 0.5,
        );

        painter.paint(canvas, size);
        expect(recorder.endRecording(), isNotNull);
      }
    });

    test('shouldRepaint returns true when target changes', () {
      const style = SpotlightStyle();
      final painterA = SpotlightPainter(
        targetRect: const Rect.fromLTWH(0, 0, 100, 100),
        style: style,
        primaryColor: Colors.blue,
      );
      final painterB = SpotlightPainter(
        targetRect: const Rect.fromLTWH(10, 10, 100, 100),
        style: style,
        primaryColor: Colors.blue,
      );

      expect(painterA.shouldRepaint(painterB), isTrue);
    });
  });
}
