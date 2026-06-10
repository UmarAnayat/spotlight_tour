import 'package:flutter/material.dart';

import 'required_action.dart';
import 'spotlight_style.dart';
import 'tooltip_position.dart';

/// A single step in a spotlight tour.
class TourStep {
  /// Creates a [TourStep].
  const TourStep({
    required this.targetKey,
    this.title,
    this.description,
    this.customTooltip,
    this.requiredAction,
    this.validator,
    this.spotlightStyle,
    this.tooltipPosition = TooltipPosition.auto,
    this.onStepEnter,
    this.onStepExit,
    this.onValidated,
  });

  /// [GlobalKey] attached to the widget to highlight.
  final GlobalKey targetKey;

  /// Tooltip title text.
  final String? title;

  /// Tooltip description text.
  final String? description;

  /// Fully custom tooltip widget. Takes precedence over [title]/[description].
  final Widget? customTooltip;

  /// Gesture the user must perform on the target to advance automatically.
  ///
  /// When set, the Next button stays disabled until the action is performed.
  final RequiredAction? requiredAction;

  /// Custom async validation. Return `true` when the user may advance.
  ///
  /// When set (and [requiredAction] is null), Next stays disabled until
  /// this returns `true`. Called when the user taps Next.
  final Future<bool> Function()? validator;

  /// Per-step spotlight styling. Falls back to tour-level defaults.
  final SpotlightStyle? spotlightStyle;

  /// Preferred tooltip placement.
  final TooltipPosition tooltipPosition;

  /// Called when this step becomes active.
  final VoidCallback? onStepEnter;

  /// Called when leaving this step.
  final VoidCallback? onStepExit;

  /// Called when the required action or validator succeeds.
  final VoidCallback? onValidated;

  /// Whether this step requires user interaction before advancing.
  bool get requiresInteraction =>
      requiredAction != null || validator != null;
}
