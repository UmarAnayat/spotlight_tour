import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/spotlight_shape.dart';
import '../models/spotlight_style.dart';

/// Paints the dimmed overlay with spotlight cutout(s), border, and glow.
class SpotlightPainter extends CustomPainter {
  /// Creates a painter for a single [targetRect].
  SpotlightPainter({
    required Rect targetRect,
    required this.style,
    required this.primaryColor,
    this.pulseValue = 0,
  }) : targetRects = <Rect>[targetRect];

  /// Creates a painter for multiple spotlight cutouts.
  SpotlightPainter.multiple({
    required this.targetRects,
    required this.style,
    required this.primaryColor,
    this.pulseValue = 0,
  });

  /// Spotlight cutout rectangles in global coordinates.
  final List<Rect> targetRects;
  final SpotlightStyle style;
  final Color primaryColor;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayColor =
        (style.overlayColor ?? Colors.black).withValues(
          alpha: style.overlayOpacity,
        );
    final borderColor = style.borderColor ?? primaryColor;
    final glowColor = style.glowColor ?? borderColor;

    final holePath = _createCombinedHolePath();

    canvas.saveLayer(Offset.zero & size, Paint());

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = overlayColor,
    );

    canvas.drawPath(
      holePath,
      Paint()
        ..blendMode = BlendMode.clear
        ..style = PaintingStyle.fill,
    );

    canvas.restore();

    if (style.blurStrength > 0) {
      canvas.saveLayer(Offset.zero & size, Paint());
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = overlayColor
          ..maskFilter = ui.MaskFilter.blur(
            BlurStyle.normal,
            style.blurStrength,
          ),
      );
      canvas.drawPath(
        holePath,
        Paint()
          ..blendMode = BlendMode.clear
          ..style = PaintingStyle.fill,
      );
      canvas.restore();
    }

    final pulseBorderWidth =
        style.borderWidth + (style.pulseAnimation ? pulseValue * 2 : 0);
    final pulseGlowSpread =
        style.glowSpread + (style.pulseAnimation ? pulseValue * 4 : 0);

    for (final rect in targetRects) {
      final singleHole = _createHolePath(rect, style);
      if (style.showGlow) {
        canvas.drawPath(
          singleHole,
          Paint()
            ..color = glowColor.withValues(alpha: 0.35 + pulseValue * 0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = pulseBorderWidth
            ..maskFilter =
                ui.MaskFilter.blur(BlurStyle.normal, pulseGlowSpread),
        );
      }

      canvas.drawPath(
        singleHole,
        Paint()
          ..color = borderColor.withValues(alpha: 0.85 + pulseValue * 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = pulseBorderWidth,
      );
    }
  }

  Path _createCombinedHolePath() {
    final path = Path();
    for (final rect in targetRects) {
      path.addPath(_createHolePath(rect, style), Offset.zero);
    }
    return path;
  }

  Path _createHolePath(Rect rect, SpotlightStyle style) {
    switch (style.shape) {
      case SpotlightShape.circle:
        final radius = rect.shortestSide / 2;
        return Path()
          ..addOval(
            Rect.fromCircle(center: rect.center, radius: radius),
          );
      case SpotlightShape.rectangle:
        return Path()..addRect(rect);
      case SpotlightShape.roundedRectangle:
        return Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              rect,
              Radius.circular(style.borderRadius),
            ),
          );
    }
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.targetRects != targetRects ||
        oldDelegate.style != style ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.primaryColor != primaryColor;
  }
}
