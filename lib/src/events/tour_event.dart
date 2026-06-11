import 'tour_event_type.dart';

/// A global event emitted during a spotlight tour.
class TourEvent {
  /// Creates a [TourEvent].
  const TourEvent({
    required this.type,
    this.stepIndex,
    this.stepId,
    this.message,
  });

  /// The kind of event.
  final TourEventType type;

  /// Zero-based step index, when applicable.
  final int? stepIndex;

  /// Optional step identifier from [TourStep.id].
  final String? stepId;

  /// Optional detail message.
  final String? message;

  @override
  String toString() =>
      'TourEvent(type: $type, stepIndex: $stepIndex, stepId: $stepId)';
}
