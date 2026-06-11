/// Types of global tour events emitted on [SpotlightTour.events].
enum TourEventType {
  /// Tour has started.
  tourStarted,

  /// Tour completed on the last step.
  tourCompleted,

  /// User skipped the tour.
  tourSkipped,

  /// Active step index changed.
  stepChanged,

  /// Step validation succeeded.
  validationPassed,

  /// Step validation failed.
  validationFailed,
}
