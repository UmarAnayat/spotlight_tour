import 'package:flutter/material.dart';

import 'analytics/tour_analytics.dart';
import 'controller/spotlight_tour_controller.dart';
import 'events/tour_event.dart';
import 'events/tour_event_bus.dart';
import 'models/spotlight_style.dart';
import 'models/step_indicator_type.dart';
import 'models/tooltip_animation_type.dart';
import 'models/tour_config.dart';
import 'models/tour_step.dart';
import 'overlay/spotlight_tour_overlay.dart';
import 'theme/spotlight_tour_theme.dart';

/// Entry point for starting and managing spotlight tours.
abstract final class SpotlightTour {
  SpotlightTour._();

  static OverlayEntry? _overlayEntry;
  static SpotlightTourController? _activeController;

  /// Whether a tour is currently active.
  static bool get isActive => _overlayEntry != null;

  /// Global stream of tour lifecycle events.
  static Stream<TourEvent> get events => TourEventBus.instance.stream;

  /// Starts a spotlight tour with the given [steps].
  ///
  /// ```dart
  /// SpotlightTour.start(
  ///   context,
  ///   steps: [
  ///     TourStep(
  ///       targetKey: searchKey,
  ///       title: 'Search Products',
  ///       description: 'Tap here to search.',
  ///       requiredAction: RequiredAction.tap,
  ///     ),
  ///   ],
  /// );
  /// ```
  static void start(
    BuildContext context, {
    required List<TourStep> steps,
    SpotlightTourTheme? theme,
    SpotlightStyle defaultSpotlightStyle = const SpotlightStyle(),
    bool showProgress = true,
    StepIndicatorType indicatorType = StepIndicatorType.linear,
    TooltipAnimationType animationType = TooltipAnimationType.fade,
    bool showNextButton = true,
    bool showBackButton = true,
    bool showSkipButton = true,
    VoidCallback? onComplete,
    VoidCallback? onSkip,
    ValueChanged<int>? onStepChanged,
    VoidCallback? onTourStarted,
    VoidCallback? onTourCompleted,
    VoidCallback? onTourSkipped,
  }) {
    assert(steps.isNotEmpty, 'SpotlightTour requires at least one step.');

    if (isActive) {
      stop();
    }

    final resolvedTheme = theme ??
        (Theme.of(context).platform == TargetPlatform.iOS
            ? SpotlightTourTheme.cupertino()
            : SpotlightTourTheme.material3());

    final analytics = TourAnalytics(
      onTourStarted: onTourStarted,
      onTourCompleted: onTourCompleted ?? onComplete,
      onTourSkipped: onTourSkipped ?? onSkip,
      onStepChanged: onStepChanged,
    )..reset();

    final config = TourConfig(
      steps: steps,
      theme: resolvedTheme,
      defaultSpotlightStyle: defaultSpotlightStyle,
      showProgress: showProgress,
      indicatorType: indicatorType,
      animationType: animationType,
      showNextButton: showNextButton,
      showBackButton: showBackButton,
      showSkipButton: showSkipButton,
      onComplete: onComplete,
      onSkip: onSkip,
      onStepChanged: onStepChanged,
      onTourStarted: onTourStarted,
      onTourCompleted: onTourCompleted,
      onTourSkipped: onTourSkipped,
      analytics: analytics,
    );

    final controller = SpotlightTourController(config: config);
    _activeController = controller;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        return SpotlightTourOverlay(
          controller: controller,
          theme: resolvedTheme,
          onDismiss: () {
            entry.remove();
            if (_overlayEntry == entry) {
              _overlayEntry = null;
            }
            if (_activeController == controller) {
              _activeController = null;
            }
            Future.microtask(controller.dispose);
          },
        );
      },
    );

    _overlayEntry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  /// Stops the active tour immediately, if any.
  static void stop() {
    final controller = _activeController;
    final entry = _overlayEntry;
    _overlayEntry = null;
    _activeController = null;
    entry?.remove();
    if (controller != null) {
      Future.microtask(controller.dispose);
    }
  }

  /// Returns the active controller, or `null` if no tour is running.
  static SpotlightTourController? get controller => _activeController;
}
