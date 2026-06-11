import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';
import 'package:spotlight_tour/src/animations/tooltip_animation_builder.dart';
import 'package:spotlight_tour/src/indicators/step_indicator.dart';

void main() {
  group('StepIndicator', () {
    testWidgets('renders dots indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepIndicator(
              type: StepIndicatorType.dots,
              currentIndex: 1,
              totalSteps: 4,
              stepCounter: 'Step 2 of 4',
              progress: 0.5,
              progressPercent: '50%',
              theme: SpotlightTourTheme.material3(),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(4));
    });

    testWidgets('renders text indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepIndicator(
              type: StepIndicatorType.text,
              currentIndex: 0,
              totalSteps: 3,
              stepCounter: 'Step 1 of 3',
              progress: 0.33,
              progressPercent: '33%',
              theme: SpotlightTourTheme.material3(),
            ),
          ),
        ),
      );

      expect(find.text('Step 1 of 3'), findsOneWidget);
    });
  });

  group('TooltipAnimationBuilder', () {
    testWidgets('renders child for each animation type', (tester) async {
      for (final type in TooltipAnimationType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: TooltipAnimationBuilder(
              animationType: type,
              child: const Text('Animated'),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Animated'), findsOneWidget);
      }
    });
  });
}
