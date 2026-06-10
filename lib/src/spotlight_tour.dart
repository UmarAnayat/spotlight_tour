import 'package:flutter/material.dart';

import 'controller/spotlight_tour_controller.dart';
import 'models/spotlight_style.dart';
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
    bool showNextButton = true,
    bool showBackButton = true,
    bool showSkipButton = true,
    VoidCallback? onComplete,
    VoidCallback? onSkip,
    ValueChanged<int>? onStepChanged,
  }) {
    assert(steps.isNotEmpty, 'SpotlightTour requires at least one step.');

    if (isActive) {
      stop();
    }

    final resolvedTheme = theme ??
        (Theme.of(context).platform == TargetPlatform.iOS
            ? SpotlightTourTheme.cupertino()
            : SpotlightTourTheme.material3());

    final config = TourConfig(
      steps: steps,
      theme: resolvedTheme,
      defaultSpotlightStyle: defaultSpotlightStyle,
      showProgress: showProgress,
      showNextButton: showNextButton,
      showBackButton: showBackButton,
      showSkipButton: showSkipButton,
      onComplete: onComplete,
      onSkip: onSkip,
      onStepChanged: onStepChanged,
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
