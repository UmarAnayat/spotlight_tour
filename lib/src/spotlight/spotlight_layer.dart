import 'package:flutter/material.dart';

import '../models/spotlight_style.dart';
import 'spotlight_painter.dart';

/// Animated spotlight visual layer.
class SpotlightLayer extends StatefulWidget {
  const SpotlightLayer({
    super.key,
    required this.targetRect,
    required this.style,
    required this.primaryColor,
  });

  final Rect targetRect;
  final SpotlightStyle style;
  final Color primaryColor;

  @override
  State<SpotlightLayer> createState() => _SpotlightLayerState();
}

class _SpotlightLayerState extends State<SpotlightLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.style.pulseAnimation) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SpotlightLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style.pulseAnimation && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.style.pulseAnimation && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: SpotlightPainter(
              targetRect: widget.targetRect,
              style: widget.style,
              primaryColor: widget.primaryColor,
              pulseValue: widget.style.pulseAnimation
                  ? _pulseAnimation.value
                  : 0,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}
