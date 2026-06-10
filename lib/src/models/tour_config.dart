import 'package:flutter/material.dart';

import '../theme/spotlight_tour_theme.dart';
import 'spotlight_style.dart';
import 'tour_step.dart';

/// Global configuration for a spotlight tour.
class TourConfig {
  /// Creates a [TourConfig].
  const TourConfig({
    required this.steps,
    this.theme,
    this.defaultSpotlightStyle = const SpotlightStyle(),
    this.showProgress = true,
    this.showNextButton = true,
    this.showBackButton = true,
    this.showSkipButton = true,
    this.onComplete,
    this.onSkip,
    this.onStepChanged,
  });

  /// Ordered list of tour steps.
  final List<TourStep> steps;

  /// Visual theme for tooltips and controls.
  final SpotlightTourTheme? theme;

  /// Default spotlight style applied to every step.
  final SpotlightStyle defaultSpotlightStyle;

  /// Whether to show step counter / linear progress.
  final bool showProgress;

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
}
