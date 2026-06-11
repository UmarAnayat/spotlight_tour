import 'dart:async';

import 'tour_event.dart';
import 'tour_event_type.dart';

/// Broadcast bus for global tour events.
class TourEventBus {
  TourEventBus._();

  static final TourEventBus instance = TourEventBus._();

  final StreamController<TourEvent> _controller =
      StreamController<TourEvent>.broadcast();

  /// Stream of tour events.
  Stream<TourEvent> get stream => _controller.stream;

  /// Emits [event] to all listeners.
  void emit(TourEvent event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  /// Emits a typed event with optional metadata.
  void emitTyped(
    TourEventType type, {
    int? stepIndex,
    String? stepId,
    String? message,
  }) {
    emit(
      TourEvent(
        type: type,
        stepIndex: stepIndex,
        stepId: stepId,
        message: message,
      ),
    );
  }

  /// Closes the underlying stream controller.
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
