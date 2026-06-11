import 'package:flutter/foundation.dart';

import '../events/tour_event_bus.dart';
import '../events/tour_event_type.dart';

/// Fires onboarding analytics callbacks exactly once per tour lifecycle.
class TourAnalytics {
  /// Creates [TourAnalytics] with optional callbacks.
  TourAnalytics({
    this.onTourStarted,
    this.onTourCompleted,
    this.onTourSkipped,
    this.onStepChanged,
    this.emitGlobalEvents = true,
  });

  /// Called once when the tour starts.
  final VoidCallback? onTourStarted;

  /// Called once when the tour completes on the last step.
  final VoidCallback? onTourCompleted;

  /// Called once when the user skips the tour.
  final VoidCallback? onTourSkipped;

  /// Called when the active step index changes.
  final ValueChanged<int>? onStepChanged;

  /// Whether to mirror callbacks to [TourEventBus].
  final bool emitGlobalEvents;

  bool _startedFired = false;
  bool _completedFired = false;
  bool _skippedFired = false;

  /// Resets one-shot flags for a new tour.
  void reset() {
    _startedFired = false;
    _completedFired = false;
    _skippedFired = false;
  }

  /// Fires [onTourStarted] and global event once.
  void tourStarted() {
    if (_startedFired) return;
    _startedFired = true;
    onTourStarted?.call();
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(TourEventType.tourStarted);
    }
  }

  /// Fires [onTourCompleted] and global event once.
  void tourCompleted() {
    if (_completedFired) return;
    _completedFired = true;
    onTourCompleted?.call();
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(TourEventType.tourCompleted);
    }
  }

  /// Fires [onTourSkipped] and global event once.
  void tourSkipped() {
    if (_skippedFired) return;
    _skippedFired = true;
    onTourSkipped?.call();
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(TourEventType.tourSkipped);
    }
  }

  /// Fires [onStepChanged] and global step event.
  void stepChanged(int index, {String? stepId}) {
    onStepChanged?.call(index);
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(
        TourEventType.stepChanged,
        stepIndex: index,
        stepId: stepId,
      );
    }
  }

  /// Fires validation passed event.
  void validationPassed({int? stepIndex, String? stepId}) {
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(
        TourEventType.validationPassed,
        stepIndex: stepIndex,
        stepId: stepId,
      );
    }
  }

  /// Fires validation failed event.
  void validationFailed({int? stepIndex, String? stepId, String? message}) {
    if (emitGlobalEvents) {
      TourEventBus.instance.emitTyped(
        TourEventType.validationFailed,
        stepIndex: stepIndex,
        stepId: stepId,
        message: message,
      );
    }
  }
}
