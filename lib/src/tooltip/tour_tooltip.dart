import 'package:flutter/material.dart';

import '../models/tooltip_position.dart';
import '../theme/spotlight_tour_theme.dart';
import '../utils/tooltip_position_calculator.dart';

/// Default tooltip with title, description, and directional arrow.
class TourTooltip extends StatelessWidget {
  const TourTooltip({
    super.key,
    required this.title,
    required this.description,
    required this.theme,
    required this.position,
    required this.arrowOffset,
    this.child,
  });

  final String? title;
  final String? description;
  final SpotlightTourTheme theme;
  final TooltipPosition position;
  final double arrowOffset;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = theme.resolveBackgroundColor(context);
    final borderRadius = BorderRadius.circular(theme.borderRadius);

    return Material(
      color: Colors.transparent,
      child: CustomPaint(
        painter: _TooltipArrowPainter(
          color: backgroundColor,
          position: position,
          arrowOffset: arrowOffset,
          borderRadius: theme.borderRadius,
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: theme.tooltipPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: theme.tooltipShadow,
          ),
          child: child ??
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title!.isNotEmpty)
                    Text(
                      title!,
                      style: theme.resolveTitleStyle(context),
                    ),
                  if (title != null &&
                      title!.isNotEmpty &&
                      description != null &&
                      description!.isNotEmpty)
                    const SizedBox(height: 8),
                  if (description != null && description!.isNotEmpty)
                    Text(
                      description!,
                      style: theme.resolveDescriptionStyle(context),
                    ),
                ],
              ),
        ),
      ),
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  _TooltipArrowPainter({
    required this.color,
    required this.position,
    required this.arrowOffset,
    required this.borderRadius,
  });

  final Color color;
  final TooltipPosition position;
  final double arrowOffset;
  final double borderRadius;

  static const double _arrowSize = 8;

  @override
  void paint(Canvas canvas, Size size) {
    if (position == TooltipPosition.auto) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (position) {
      case TooltipPosition.top:
        final x = size.width * arrowOffset;
        path
          ..moveTo(x - _arrowSize, size.height)
          ..lineTo(x, size.height + _arrowSize)
          ..lineTo(x + _arrowSize, size.height);
      case TooltipPosition.bottom:
        final x = size.width * arrowOffset;
        path
          ..moveTo(x - _arrowSize, 0)
          ..lineTo(x, -_arrowSize)
          ..lineTo(x + _arrowSize, 0);
      case TooltipPosition.left:
        final y = size.height * arrowOffset;
        path
          ..moveTo(size.width, y - _arrowSize)
          ..lineTo(size.width + _arrowSize, y)
          ..lineTo(size.width, y + _arrowSize);
      case TooltipPosition.right:
        final y = size.height * arrowOffset;
        path
          ..moveTo(0, y - _arrowSize)
          ..lineTo(-_arrowSize, y)
          ..lineTo(0, y + _arrowSize);
      case TooltipPosition.auto:
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TooltipArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.position != position ||
        oldDelegate.arrowOffset != arrowOffset;
  }
}

/// Lays out and positions a tooltip relative to a spotlight target.
class PositionedTourTooltip extends StatefulWidget {
  const PositionedTourTooltip({
    super.key,
    required this.targetRect,
    required this.preferredPosition,
    required this.theme,
    required this.title,
    required this.description,
    this.customTooltip,
    this.keyboardInset = 0,
  });

  final Rect targetRect;
  final TooltipPosition preferredPosition;
  final SpotlightTourTheme theme;
  final String? title;
  final String? description;
  final Widget? customTooltip;
  final double keyboardInset;

  @override
  State<PositionedTourTooltip> createState() => _PositionedTourTooltipState();
}

class _PositionedTourTooltipState extends State<PositionedTourTooltip> {
  final GlobalKey _tooltipKey = GlobalKey();
  TooltipLayoutResult? _layout;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLayout());
  }

  @override
  void didUpdateWidget(covariant PositionedTourTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLayout());
  }

  void _updateLayout() {
    if (!mounted) return;

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final safePadding = mediaQuery.padding;

    Size tooltipSize;
    final renderBox =
        _tooltipKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null && renderBox.hasSize) {
      tooltipSize = renderBox.size;
    } else {
      tooltipSize = TooltipPositionCalculator.estimateSize(
        title: widget.title,
        description: widget.description,
        maxWidth: screenSize.width * 0.75,
        titleStyle: widget.theme.resolveTitleStyle(context),
        descriptionStyle: widget.theme.resolveDescriptionStyle(context),
        padding: widget.theme.tooltipPadding,
      );
    }

    final layout = TooltipPositionCalculator.calculate(
      targetRect: widget.targetRect,
      tooltipSize: tooltipSize,
      screenSize: screenSize,
      safePadding: safePadding,
      preferred: widget.preferredPosition,
      keyboardInset: widget.keyboardInset,
    );

    if (_layout?.offset != layout.offset ||
        _layout?.position != layout.position) {
      setState(() => _layout = layout);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tooltip = widget.customTooltip ??
        TourTooltip(
          title: widget.title,
          description: widget.description,
          theme: widget.theme,
          position: _layout?.position ?? widget.preferredPosition,
          arrowOffset: _layout?.arrowOffset ?? 0.5,
        );

    return Stack(
      children: [
        Positioned(
          left: _layout?.offset.dx ?? 0,
          top: _layout?.offset.dy ?? 0,
          child: KeyedSubtree(
            key: _tooltipKey,
            child: tooltip,
          ),
        ),
      ],
    );
  }
}
