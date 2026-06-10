import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';
import 'package:spotlight_tour/src/utils/tooltip_position_calculator.dart';

void main() {
  group('TooltipPositionCalculator', () {
    const screenSize = Size(400, 800);
    const safePadding = EdgeInsets.only(top: 44, bottom: 34);

    test('auto picks bottom when most space below target', () {
      final targetRect = const Rect.fromLTWH(150, 200, 100, 50);
      const tooltipSize = Size(240, 120);

      final result = TooltipPositionCalculator.calculate(
        targetRect: targetRect,
        tooltipSize: tooltipSize,
        screenSize: screenSize,
        safePadding: safePadding,
        preferred: TooltipPosition.auto,
      );

      expect(result.position, TooltipPosition.bottom);
      expect(result.offset.dy, greaterThan(targetRect.bottom));
    });

    test('top position places tooltip above target', () {
      final targetRect = const Rect.fromLTWH(150, 400, 100, 50);
      const tooltipSize = Size(240, 120);

      final result = TooltipPositionCalculator.calculate(
        targetRect: targetRect,
        tooltipSize: tooltipSize,
        screenSize: screenSize,
        safePadding: safePadding,
        preferred: TooltipPosition.top,
      );

      expect(result.position, TooltipPosition.top);
      expect(
        result.offset.dy + tooltipSize.height,
        lessThan(targetRect.top),
      );
    });

    test('respects keyboard inset', () {
      final targetRect = const Rect.fromLTWH(150, 500, 100, 50);
      const tooltipSize = Size(240, 120);

      final withoutKeyboard = TooltipPositionCalculator.calculate(
        targetRect: targetRect,
        tooltipSize: tooltipSize,
        screenSize: screenSize,
        safePadding: safePadding,
        preferred: TooltipPosition.bottom,
      );

      final withKeyboard = TooltipPositionCalculator.calculate(
        targetRect: targetRect,
        tooltipSize: tooltipSize,
        screenSize: screenSize,
        safePadding: safePadding,
        preferred: TooltipPosition.bottom,
        keyboardInset: 300,
      );

      expect(withKeyboard.offset.dy, lessThanOrEqualTo(withoutKeyboard.offset.dy));
    });

    test('estimateSize returns reasonable dimensions', () {
      final size = TooltipPositionCalculator.estimateSize(
        title: 'Search Products',
        description: 'Tap here to find products in the store.',
        maxWidth: 300,
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        descriptionStyle: const TextStyle(fontSize: 15),
        padding: const EdgeInsets.all(16),
      );

      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
      expect(size.width, lessThanOrEqualTo(300));
    });
  });
}
