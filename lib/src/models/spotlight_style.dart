import 'package:flutter/material.dart';

import 'spotlight_shape.dart';

/// Visual styling for the spotlight highlight effect.
class SpotlightStyle {
  /// Creates a [SpotlightStyle].
  const SpotlightStyle({
    this.shape = SpotlightShape.roundedRectangle,
    this.blurStrength = 0,
    this.borderWidth = 3,
    this.borderColor,
    this.showGlow = true,
    this.pulseAnimation = true,
    this.padding = 8,
    this.borderRadius = 12,
    this.overlayColor,
    this.overlayOpacity = 0.75,
    this.glowColor,
    this.glowSpread = 4,
  });

  /// Shape of the spotlight cutout.
  final SpotlightShape shape;

  /// Blur applied to the dimmed overlay (0 = no blur).
  final double blurStrength;

  /// Width of the spotlight border stroke.
  final double borderWidth;

  /// Border color. Falls back to theme primary when null.
  final Color? borderColor;

  /// Whether to render a glow around the spotlight border.
  final bool showGlow;

  /// Whether the spotlight border pulses.
  final bool pulseAnimation;

  /// Extra padding around the target widget bounds.
  final double padding;

  /// Corner radius when [shape] is [SpotlightShape.roundedRectangle].
  final double borderRadius;

  /// Color of the dimmed overlay. Falls back to black when null.
  final Color? overlayColor;

  /// Opacity of the dimmed overlay (0–1).
  final double overlayOpacity;

  /// Glow color. Falls back to [borderColor] or theme primary when null.
  final Color? glowColor;

  /// Spread radius of the glow effect.
  final double glowSpread;

  /// Returns a copy with the given fields replaced.
  SpotlightStyle copyWith({
    SpotlightShape? shape,
    double? blurStrength,
    double? borderWidth,
    Color? borderColor,
    bool? showGlow,
    bool? pulseAnimation,
    double? padding,
    double? borderRadius,
    Color? overlayColor,
    double? overlayOpacity,
    Color? glowColor,
    double? glowSpread,
  }) {
    return SpotlightStyle(
      shape: shape ?? this.shape,
      blurStrength: blurStrength ?? this.blurStrength,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      showGlow: showGlow ?? this.showGlow,
      pulseAnimation: pulseAnimation ?? this.pulseAnimation,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      glowColor: glowColor ?? this.glowColor,
      glowSpread: glowSpread ?? this.glowSpread,
    );
  }
}
