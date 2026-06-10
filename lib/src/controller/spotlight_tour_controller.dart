import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/required_action.dart';
import '../models/tour_config.dart';
import '../models/tour_step.dart';

/// Manages tour state, navigation, and interactive validation.
class SpotlightTourController extends ChangeNotifier {
  SpotlightTourController({required TourConfig config}) : _config = config {
    _currentIndex = 0;
    _validated = !_config.steps.first.requiresInteraction;
  }

  final TourConfig _config;

  late int _currentIndex;
  bool _validated = false;
  bool _isDisposed = false;

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

  /// Whether the user may advance (interaction satisfied or no requirement).
  bool get canAdvance => _validated;

  /// Whether the user can go back.
  bool get canGoBack => _currentIndex > 0;

  /// Progress fraction from 0.0 to 1.0.
  double get progress => totalSteps <= 1
      ? 1.0
      : (_currentIndex + 1) / totalSteps;

  /// Human-readable step counter, e.g. "Step 2 of 5".
  String get stepCounter => 'Step ${_currentIndex + 1} of $totalSteps';

  /// Progress percentage string, e.g. "40%".
  String get progressPercent => '${(progress * 100).round()}%';

  /// Called when the target interaction is detected.
  void onTargetInteraction(RequiredAction action) {
    if (isDismissed || _isDisposed) return;

    final step = currentStep;
    if (step.requiredAction != action) return;

    _markValidated();
  }

  /// Re-check custom validator state.
  Future<void> refreshValidation() async {
    if (isDismissed || _isDisposed) return;

    final step = currentStep;
    if (step.validator == null) return;

    final result = await step.validator!();
    if (_isDisposed) return;

    if (result && !_validated) {
      _markValidated();
    } else if (!result && _validated) {
      _validated = false;
      notifyListeners();
    }
  }

  /// Advance to the next step or complete the tour.
  Future<bool> next() async {
    if (isDismissed || _isDisposed) return false;

    final step = currentStep;

    if (step.validator != null) {
      final result = await step.validator!();
      if (!result) {
        _validated = false;
        notifyListeners();
        return false;
      }
    } else if (!_validated) {
      return false;
    }

    return _advance();
  }

  /// Go back to the previous step.
  void back() {
    if (isDismissed || _isDisposed || !canGoBack) return;

    currentStep.onStepExit?.call();
    _currentIndex--;
    _resetStepState();
    _config.onStepChanged?.call(_currentIndex);
    notifyListeners();
  }

  /// Skip the entire tour.
  void skip() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    _config.onSkip?.call();
    notifyListeners();
  }

  /// Complete and dismiss the tour.
  void complete() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    _config.onComplete?.call();
    notifyListeners();
  }

  /// Dismiss the tour without triggering [TourConfig.onComplete].
  void dismiss() {
    if (isDismissed || _isDisposed) return;

    isDismissed = true;
    currentStep.onStepExit?.call();
    notifyListeners();
  }

  void _markValidated() {
    _validated = true;
    currentStep.onValidated?.call();

    if (currentStep.requiredAction != null) {
      Future.microtask(() {
        if (!_isDisposed && !isDismissed) {
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
    _config.onStepChanged?.call(_currentIndex);
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
