import 'package:flutter/material.dart';

import '../analytics/tour_analytics.dart';
import '../theme/spotlight_tour_theme.dart';
import 'spotlight_style.dart';
import 'step_indicator_type.dart';
import 'tooltip_animation_type.dart';
import 'tour_step.dart';

/// Global configuration for a spotlight tour.
class TourConfig {
  /// Creates a [TourConfig].
  const TourConfig({
    required this.steps,
    this.theme,
    this.defaultSpotlightStyle = const SpotlightStyle(),
    this.showProgress = true,
    this.indicatorType = StepIndicatorType.linear,
    this.animationType = TooltipAnimationType.fade,
    this.showNextButton = true,
    this.showBackButton = true,
    this.showSkipButton = true,
    this.onComplete,
    this.onSkip,
    this.onStepChanged,
    this.onTourStarted,
    this.onTourCompleted,
    this.onTourSkipped,
    this.analytics,
  });

  /// Ordered list of tour steps.
  final List<TourStep> steps;

  /// Visual theme for tooltips and controls.
  final SpotlightTourTheme? theme;

  /// Default spotlight style applied to every step.
  final SpotlightStyle defaultSpotlightStyle;

  /// Whether to show the step indicator.
  final bool showProgress;

  /// Style of the step progress indicator.
  final StepIndicatorType indicatorType;

  /// Default tooltip entrance animation.
  final TooltipAnimationType animationType;

  /// Whether to show the Next button.
  final bool showNextButton;

  /// Whether to show the Back button.
  final bool showBackButton;

  /// Whether to show the Skip button.
  final bool showSkipButton;

  /// Called when the tour finishes on the last step.
  final VoidCallback? onComplete;

  /// Called when the user skips the tour.
  final VoidCallback? onSkip;

  /// Called with the new step index whenever the active step changes.
  final ValueChanged<int>? onStepChanged;

  /// Called once when the tour starts.
  final VoidCallback? onTourStarted;

  /// Called once when the tour completes.
  final VoidCallback? onTourCompleted;

  /// Called once when the tour is skipped.
  final VoidCallback? onTourSkipped;

  /// Optional analytics delegate. Built automatically when callbacks are set.
  final TourAnalytics? analytics;

  /// Resolved analytics handler for this tour.
  TourAnalytics get resolvedAnalytics => analytics ??
      TourAnalytics(
        onTourStarted: onTourStarted,
        onTourCompleted: onTourCompleted ?? onComplete,
        onTourSkipped: onTourSkipped ?? onSkip,
        onStepChanged: onStepChanged,
      );
}
