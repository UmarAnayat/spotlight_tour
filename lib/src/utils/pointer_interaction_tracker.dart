import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';

import '../models/required_action.dart';

/// Tracks pointer gestures on a target rect for tour validation.
class PointerInteractionTracker {
  PointerInteractionTracker({
    required this.onInteraction,
  });

  final void Function(RequiredAction action) onInteraction;

  static const Duration _longPressDuration = Duration(milliseconds: 500);
  static const Duration _doubleTapWindow = Duration(milliseconds: 300);

  Offset? _pointerDownPosition;
  Timer? _longPressTimer;
  int _tapCount = 0;
  Timer? _doubleTapTimer;
  bool _longPressFired = false;

  void trackEvent(PointerEvent event, Rect targetRect) {
    if (!targetRect.contains(event.position)) return;

    if (event is PointerDownEvent) {
      _onPointerDown(event);
    } else if (event is PointerUpEvent) {
      _onPointerUp(event);
    } else if (event is PointerCancelEvent) {
      _onPointerCancel();
    } else if (event is PointerMoveEvent) {
      _onPointerMove(event);
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerDownPosition = event.position;
    _longPressFired = false;
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressDuration, () {
      _longPressFired = true;
      onInteraction(RequiredAction.longPress);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    _longPressTimer?.cancel();

    if (_longPressFired) {
      _resetTapState();
      return;
    }

    if (_pointerDownPosition == null) return;

    final distance = (event.position - _pointerDownPosition!).distance;
    if (distance > 20) {
      _resetTapState();
      return;
    }

    _tapCount++;
    _doubleTapTimer?.cancel();

    if (_tapCount == 1) {
      _doubleTapTimer = Timer(_doubleTapWindow, () {
        if (_tapCount == 1) {
          onInteraction(RequiredAction.tap);
        }
        _resetTapState();
      });
    } else if (_tapCount >= 2) {
      onInteraction(RequiredAction.doubleTap);
      _resetTapState();
    }

    _pointerDownPosition = null;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerDownPosition == null) return;
    final distance = (event.position - _pointerDownPosition!).distance;
    if (distance > 20) {
      _longPressTimer?.cancel();
    }
  }

  void _onPointerCancel() {
    _cancelTimers();
    _resetTapState();
  }

  void _cancelTimers() {
    _longPressTimer?.cancel();
    _doubleTapTimer?.cancel();
  }

  void _resetTapState() {
    _tapCount = 0;
    _pointerDownPosition = null;
    _longPressFired = false;
  }

  void dispose() {
    _cancelTimers();
  }
}

/// Filters global pointer events to one or more target rects.
class TargetPointerListener {
  TargetPointerListener({
    required List<Rect> targetRects,
    required this.tracker,
  }) : targetRects = List<Rect>.from(targetRects);

  List<Rect> targetRects;
  final PointerInteractionTracker tracker;

  void attach() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handleEvent);
  }

  void detach() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handleEvent);
  }

  void _handleEvent(PointerEvent event) {
    for (final rect in targetRects) {
      if (rect.contains(event.position)) {
        tracker.trackEvent(event, rect);
        return;
      }
    }
  }

  void dispose() {
    detach();
  }
}
