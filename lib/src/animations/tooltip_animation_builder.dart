import 'package:flutter/material.dart';

import '../models/tooltip_animation_type.dart';

/// Builds entrance animations for tooltips.
class TooltipAnimationBuilder extends StatelessWidget {
  /// Creates a [TooltipAnimationBuilder].
  const TooltipAnimationBuilder({
    super.key,
    required this.animationType,
    required this.child,
    this.duration = const Duration(milliseconds: 320),
    this.curve = Curves.easeOutCubic,
  });

  /// Animation to apply.
  final TooltipAnimationType animationType;

  /// Animated child.
  final Widget child;

  /// Animation duration.
  final Duration duration;

  /// Animation curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(animationType),
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: curve,
        builder: (context, value, child) {
          switch (animationType) {
            case TooltipAnimationType.fade:
              return Opacity(opacity: value, child: child);
            case TooltipAnimationType.slide:
              return Transform.translate(
                offset: Offset(0, (1 - value) * 24),
                child: Opacity(opacity: value, child: child),
              );
            case TooltipAnimationType.scale:
              return Transform.scale(
                scale: 0.85 + (value * 0.15),
                child: Opacity(opacity: value, child: child),
              );
            case TooltipAnimationType.bounce:
              final bounce = Curves.elasticOut.transform(value);
              return Transform.scale(
                scale: bounce,
                child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
              );
          }
        },
        child: child,
      ),
    );
  }
}
