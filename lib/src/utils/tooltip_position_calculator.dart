import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/tooltip_position.dart';

/// Result of tooltip layout calculation.
class TooltipLayoutResult {
  const TooltipLayoutResult({
    required this.position,
    required this.offset,
    required this.arrowOffset,
  });

  /// Resolved placement side.
  final TooltipPosition position;

  /// Top-left offset for the tooltip widget.
  final Offset offset;

  /// Arrow anchor along the tooltip edge (0–1).
  final double arrowOffset;
}

/// Calculates tooltip position avoiding overflow and safe areas.
class TooltipPositionCalculator {
  TooltipPositionCalculator._();

  static const double _margin = 12;
  static const double _arrowSize = 8;
  static const double _gap = 12;

  /// Computes tooltip placement for [targetRect] within [screenSize].
  static TooltipLayoutResult calculate({
    required Rect targetRect,
    required Size tooltipSize,
    required Size screenSize,
    required EdgeInsets safePadding,
    required TooltipPosition preferred,
    double keyboardInset = 0,
  }) {
    final available = Rect.fromLTWH(
      safePadding.left,
      safePadding.top,
      screenSize.width - safePadding.left - safePadding.right,
      screenSize.height -
          safePadding.top -
          safePadding.bottom -
          keyboardInset,
    );

    final position = preferred == TooltipPosition.auto
        ? _bestPosition(targetRect, tooltipSize, available)
        : preferred;

    return _layoutForPosition(
      position: position,
      targetRect: targetRect,
      tooltipSize: tooltipSize,
      available: available,
    );
  }

  static TooltipPosition _bestPosition(
    Rect target,
    Size tooltip,
    Rect available,
  ) {
    final scores = <TooltipPosition, double>{
      TooltipPosition.top: _spaceAbove(target, available) - tooltip.height,
      TooltipPosition.bottom: _spaceBelow(target, available) - tooltip.height,
      TooltipPosition.left: _spaceLeft(target, available) - tooltip.width,
      TooltipPosition.right: _spaceRight(target, available) - tooltip.width,
    };

    return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  static double _spaceAbove(Rect target, Rect available) =>
      target.top - available.top;

  static double _spaceBelow(Rect target, Rect available) =>
      available.bottom - target.bottom;

  static double _spaceLeft(Rect target, Rect available) =>
      target.left - available.left;

  static double _spaceRight(Rect target, Rect available) =>
      available.right - target.right;

  static TooltipLayoutResult _layoutForPosition({
    required TooltipPosition position,
    required Rect targetRect,
    required Size tooltipSize,
    required Rect available,
  }) {
    double left;
    double top;
    double arrowOffset;

    switch (position) {
      case TooltipPosition.top:
        left = _centerOnAxis(
          targetRect.center.dx,
          tooltipSize.width,
          available.left,
          available.right,
        );
        top = targetRect.top - tooltipSize.height - _gap - _arrowSize;
        arrowOffset = ((targetRect.center.dx - left) / tooltipSize.width)
            .clamp(0.15, 0.85);
      case TooltipPosition.bottom:
        left = _centerOnAxis(
          targetRect.center.dx,
          tooltipSize.width,
          available.left,
          available.right,
        );
        top = targetRect.bottom + _gap + _arrowSize;
        arrowOffset = ((targetRect.center.dx - left) / tooltipSize.width)
            .clamp(0.15, 0.85);
      case TooltipPosition.left:
        top = _centerOnAxis(
          targetRect.center.dy,
          tooltipSize.height,
          available.top,
          available.bottom,
        );
        left = targetRect.left - tooltipSize.width - _gap - _arrowSize;
        arrowOffset = ((targetRect.center.dy - top) / tooltipSize.height)
            .clamp(0.15, 0.85);
      case TooltipPosition.right:
        top = _centerOnAxis(
          targetRect.center.dy,
          tooltipSize.height,
          available.top,
          available.bottom,
        );
        left = targetRect.right + _gap + _arrowSize;
        arrowOffset = ((targetRect.center.dy - top) / tooltipSize.height)
            .clamp(0.15, 0.85);
      case TooltipPosition.auto:
        return _layoutForPosition(
          position: TooltipPosition.bottom,
          targetRect: targetRect,
          tooltipSize: tooltipSize,
          available: available,
        );
    }

    left = left.clamp(
      available.left + _margin,
      available.right - tooltipSize.width - _margin,
    );
    top = top.clamp(
      available.top + _margin,
      available.bottom - tooltipSize.height - _margin,
    );

    return TooltipLayoutResult(
      position: position,
      offset: Offset(left, top),
      arrowOffset: arrowOffset,
    );
  }

  static double _centerOnAxis(
    double center,
    double size,
    double min,
    double max,
  ) {
    final half = size / 2;
    return (center - half).clamp(min + _margin, max - size - _margin);
  }

  /// Estimates tooltip size for layout before first paint.
  static Size estimateSize({
    required String? title,
    required String? description,
    required double maxWidth,
    required TextStyle titleStyle,
    required TextStyle descriptionStyle,
    required EdgeInsets padding,
  }) {
    double width = 0;
    double height = padding.vertical;

    if (title != null && title.isNotEmpty) {
      final painter = TextPainter(
        text: TextSpan(text: title, style: titleStyle),
        textDirection: TextDirection.ltr,
        maxLines: 3,
      )..layout(maxWidth: maxWidth - padding.horizontal);
      width = math.max(width, painter.width);
      height += painter.height + (description != null ? 8 : 0);
    }

    if (description != null && description.isNotEmpty) {
      final painter = TextPainter(
        text: TextSpan(text: description, style: descriptionStyle),
        textDirection: TextDirection.ltr,
        maxLines: 5,
      )..layout(maxWidth: maxWidth - padding.horizontal);
      width = math.max(width, painter.width);
      height += painter.height;
    }

    return Size(
      (width + padding.horizontal).clamp(200, maxWidth),
      height.clamp(80, 300),
    );
  }
}
