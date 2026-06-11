import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/step_indicator_type.dart';
import '../theme/spotlight_tour_theme.dart';
import '../widgets/tour_progress.dart';

/// Built-in step indicator with text, dots, or linear styles.
class StepIndicator extends StatelessWidget {
  /// Creates a [StepIndicator].
  const StepIndicator({
    super.key,
    required this.type,
    required this.currentIndex,
    required this.totalSteps,
    required this.stepCounter,
    required this.progress,
    required this.progressPercent,
    required this.theme,
  });

  /// Indicator visual style.
  final StepIndicatorType type;

  /// Current zero-based step index.
  final int currentIndex;

  /// Total number of steps.
  final int totalSteps;

  /// Text counter label.
  final String stepCounter;

  /// Progress from 0.0 to 1.0.
  final double progress;

  /// Percentage label.
  final String progressPercent;

  /// Visual theme.
  final SpotlightTourTheme theme;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StepIndicatorType.text:
        return Semantics(
          label: stepCounter,
          child: Text(
            stepCounter,
            style: theme.resolveDescriptionStyle(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        );
      case StepIndicatorType.dots:
        return _DotsIndicator(
          currentIndex: currentIndex,
          totalSteps: totalSteps,
          theme: theme,
        );
      case StepIndicatorType.linear:
        return TourProgress(
          stepCounter: stepCounter,
          progress: progress,
          progressPercent: progressPercent,
          theme: theme,
        );
    }
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.currentIndex,
    required this.totalSteps,
    required this.theme,
  });

  final int currentIndex;
  final int totalSteps;
  final SpotlightTourTheme theme;

  @override
  Widget build(BuildContext context) {
    final primary = theme.resolveIndicatorColor(context);
    final inactive = theme.resolveIndicatorInactiveColor(context);

    return Semantics(
      label: 'Step ${currentIndex + 1} of $totalSteps',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? primary : inactive,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }
}
