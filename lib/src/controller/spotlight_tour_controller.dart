import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../analytics/tour_analytics.dart';
import '../models/required_action.dart';
import '../models/tour_config.dart';
import '../models/tour_step.dart';

/// Manages tour state, navigation, and interactive validation.
class SpotlightTourController extends ChangeNotifier {
  /// Creates a controller for the given [config].
  SpotlightTourController({required TourConfig config}) : _config = config {
    _currentIndex = 0;
    _validated = !_config.steps.first.requiresInteraction;
    _analytics = config.resolvedAnalytics;
  }

  final TourConfig _config;
  late final TourAnalytics _analytics;

  late int _currentIndex;
  bool _validated = false;
  bool _isDisposed = false;
  bool _isPaused = false;

  /// Whether the tour has been dismissed.
  bool isDismissed = false;

  /// Total number of steps.
  int get totalSteps => _config.steps.length;

  /// Current step index (0-based).
  int get currentIndex => _currentIndex;

  /// Current active step.
  TourStep get currentStep => _config.steps[_currentIndex];

  /// Tour configuration.
  TourConfig get config => _config;

  /// Whether the tour is paused.
  bool get isPaused => _isPaused;

  /// Whether the user may advance (interaction satisfied or no requirement).
  bool get canAdvance => _validated && !_isPaused;

  /// Whether the user can go back.
  bool get canGoBack => _currentIndex > 0 && !_isPaused;

  /// Progress fraction from 0.0 to 1.0.
  double get progress => totalSteps <= 1
      ? 1.0
      : (_currentIndex + 1) / totalSteps;

  /// Human-readable step counter, e.g. "Step 2 of 5".
  String get stepCounter => 'Step ${_currentIndex + 1} of $totalSteps';

  /// Progress percentage string, e.g. "40%".
  String get progressPercent => '${(progress * 100).round()}%';

  /// Called once when the tour becomes visible.
  void notifyTourStarted() {
    _analytics.tourStarted();
    _analytics.stepChanged(_currentIndex, stepId: currentStep.id);
  }

  /// Called when the target interaction is detected.
  void onTargetInteraction(RequiredAction action) {
    if (isDismissed || _isDisposed || _isPaused) return;

    final step = currentStep;
    if (step.requiredAction != action) {
      _analytics.validationFailed(
        stepIndex: _currentIndex,
        stepId: step.id,
        message: 'Expected $action',
      );
      return;
    }

    _markValidated();
  }

  /// Re-check custom validator state.
  Future<void> refreshValidation() async {
    if (isDismissed || _isDisposed || _isPaused) return;

    final step = currentStep;
    if (step.validator == null) return;

    final result = await step.validator!();
    if (_isDisposed) return;

    if (result && !_validated) {
      _markValidated(emitValidationEvent: true);
    } else if (!result && _validated) {
      _validated = false;
      _analytics.validationFailed(
        stepIndex: _currentIndex,
        stepId: step.id,
      );
      notifyListeners();
    } else if (!result) {
      _analytics.validationFailed(
        stepIndex: _currentIndex,
        stepId: step.id,
      );
    }
  }

  /// Advance to the next step or complete the tour.
  Future<bool> next() async {
    if (isDismissed || _isDisposed || _isPaused) return false;

    final step = currentStep;

    if (step.validator != null) {
      final result = await step.validator!();
      if (!result) {
        _validated = false;
        _analytics.validationFailed(
          stepIndex: _currentIndex,
          stepId: step.id,
        );
        notifyListeners();
        return false;
      }
    } else if (!_validated) {
      _analytics.validationFailed(
        stepIndex: _currentIndex,
        stepId: step.id,
      );
      return false;
    }

    return _advance();
  }

  /// Go back to the previous step.
  void back() {
    if (isDismissed || _isDisposed || !canGoBack) return;
    previous();
  }

  /// Go back to the previous step.
  void previous() {
    if (isDismissed || _isDisposed || _currentIndex <= 0 || _isPaused) return;

    currentStep.onStepExit?.call();
    _currentIndex--;
    _resetStepState();
    _analytics.stepChanged(_currentIndex, stepId: currentStep.id);
    notifyListeners();
  }

  /// Skip the entire tour.
  void skip() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    _analytics.tourSkipped();
    _config.onSkip?.call();
    notifyListeners();
  }

  /// Complete and dismiss the tour.
  void complete() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    _analytics.tourCompleted();
    _config.onComplete?.call();
    notifyListeners();
  }

  /// Completes and dismisses the tour.
  void finish() => complete();

  /// Dismiss the tour without triggering completion callbacks.
  void dismiss() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    notifyListeners();
  }

  /// Pauses tour interaction and navigation.
  void pause() {
    if (isDismissed || _isDisposed || _isPaused) return;
    _isPaused = true;
    notifyListeners();
  }

  /// Resumes a paused tour.
  void resume() {
    if (isDismissed || _isDisposed || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
  }

  void _markValidated({bool emitValidationEvent = true}) {
    _validated = true;
    currentStep.onValidated?.call();
    if (emitValidationEvent) {
      _analytics.validationPassed(
        stepIndex: _currentIndex,
        stepId: currentStep.id,
      );
    }

    if (currentStep.requiredAction != null) {
      Future.microtask(() {
        if (!_isDisposed && !isDismissed && !_isPaused) {
          _advance();
        }
      });
    } else {
      notifyListeners();
    }
  }

  Future<bool> _advance() async {
    currentStep.onStepExit?.call();

    if (_currentIndex >= totalSteps - 1) {
      complete();
      return true;
    }

    _currentIndex++;
    _resetStepState();
    _analytics.stepChanged(_currentIndex, stepId: currentStep.id);
    notifyListeners();
    return true;
  }

  void _resetStepState() {
    final step = currentStep;
    _validated = !step.requiresInteraction;
    step.onStepEnter?.call();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
