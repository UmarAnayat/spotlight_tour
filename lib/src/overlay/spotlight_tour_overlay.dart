import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/spotlight_tour_controller.dart';
import '../indicators/step_indicator.dart';
import '../models/spotlight_style.dart';
import '../models/tour_step.dart';
import '../spotlight/spotlight_hit_test.dart';
import '../spotlight/spotlight_layer.dart';
import '../theme/spotlight_tour_theme.dart';
import '../tooltip/tour_tooltip.dart';
import '../utils/pointer_interaction_tracker.dart';
import '../utils/target_resolver.dart';
import '../widgets/tour_navigation_bar.dart';

/// Full-screen overlay that renders the active tour step.
class SpotlightTourOverlay extends StatefulWidget {
  const SpotlightTourOverlay({
    super.key,
    required this.controller,
    required this.theme,
    required this.onDismiss,
  });

  final SpotlightTourController controller;
  final SpotlightTourTheme theme;
  final VoidCallback onDismiss;

  @override
  State<SpotlightTourOverlay> createState() => _SpotlightTourOverlayState();
}

class _SpotlightTourOverlayState extends State<SpotlightTourOverlay>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  List<Rect> _targetRects = [];
  Rect? _tooltipRect;
  TargetPointerListener? _pointerListener;
  late final PointerInteractionTracker _tracker;

  @override
  void initState() {
    super.initState();
    _tracker = PointerInteractionTracker(
      onInteraction: widget.controller.onTargetInteraction,
    );
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_onControllerChanged);
    currentStep.onStepEnter?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTarget();
      widget.controller.notifyTourStarted();
      _focusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(covariant SpotlightTourOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTarget());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_onControllerChanged);
    _pointerListener?.dispose();
    _tracker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTarget());
  }

  TourStep get currentStep => widget.controller.currentStep;

  SpotlightStyle get spotlightStyle =>
      currentStep.spotlightStyle ??
      widget.controller.config.defaultSpotlightStyle;

  void _onControllerChanged() {
    if (widget.controller.isDismissed) {
      widget.onDismiss();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateTarget());
    setState(() {});
  }

  void _updateTarget() {
    if (!mounted || widget.controller.isDismissed) return;

    final rects = TargetResolver.resolveAll(
      currentStep.resolvedTargetKeys,
      spotlightStyle,
    );

    if (rects.isEmpty ||
        rects.length != currentStep.resolvedTargetKeys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateTarget());
      return;
    }

    final bounds = TargetResolver.boundingRect(rects);
    if (bounds == null) return;

    if (_targetRects != rects || _tooltipRect != bounds) {
      setState(() {
        _targetRects = rects;
        _tooltipRect = bounds;
      });
    }

    _setupPointerListener(rects);
  }

  void _setupPointerListener(List<Rect> rects) {
    if (widget.controller.isPaused ||
        !currentStep.requiresInteraction ||
        currentStep.requiredAction == null) {
      _pointerListener?.detach();
      return;
    }

    if (_pointerListener == null) {
      _pointerListener = TargetPointerListener(
        targetRects: rects,
        tracker: _tracker,
      );
      _pointerListener!.attach();
    } else {
      _pointerListener!.targetRects = rects;
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || widget.controller.isPaused) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.controller.skip();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      widget.controller.next();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (widget.controller.canGoBack) {
        widget.controller.previous();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (_targetRects.isEmpty || _tooltipRect == null) {
      return const SizedBox.shrink();
    }

    final theme = widget.theme;
    final primaryColor = theme.resolvePrimaryColor(context);
    final config = widget.controller.config;
    final tooltipRect = _tooltipRect!;
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;
    final animationType =
        currentStep.animationType ?? config.animationType;

    return Semantics(
      label:
          'Onboarding tour step ${widget.controller.currentIndex + 1} '
          'of ${widget.controller.totalSteps}',
      hint: currentStep.description,
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SpotlightHitTest(
                holeRects: _targetRects,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: SpotlightLayer(
                    targetRects: _targetRects,
                    style: spotlightStyle,
                    primaryColor: primaryColor,
                  ),
                ),
              ),
              PositionedTourTooltip(
                targetRect: tooltipRect,
                preferredPosition: currentStep.tooltipPosition,
                theme: theme,
                title: currentStep.title,
                description: currentStep.description,
                lottieAsset: currentStep.lottieAsset,
                animationType: animationType,
                customTooltip: currentStep.customTooltip != null
                    ? _wrapCustomTooltip(currentStep.customTooltip!, theme)
                    : null,
                keyboardInset: keyboardInset,
              ),
              if (widget.controller.isPaused)
                const ModalBarrier(
                  dismissible: false,
                  color: Color(0x66000000),
                ),
              Positioned(
                left: mediaQuery.padding.left + 16,
                right: mediaQuery.padding.right + 16,
                bottom: mediaQuery.padding.bottom + keyboardInset + 16,
                child: RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.resolveBackgroundColor(context)
                          .withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(theme.borderRadius),
                      boxShadow: theme.tooltipShadow,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (config.showProgress)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ListenableBuilder(
                              listenable: widget.controller,
                              builder: (context, _) {
                                return StepIndicator(
                                  type: config.indicatorType,
                                  currentIndex:
                                      widget.controller.currentIndex,
                                  totalSteps: widget.controller.totalSteps,
                                  stepCounter:
                                      widget.controller.stepCounter,
                                  progress: widget.controller.progress,
                                  progressPercent:
                                      widget.controller.progressPercent,
                                  theme: theme,
                                );
                              },
                            ),
                          ),
                        TourNavigationBar(
                          controller: widget.controller,
                          theme: theme,
                          showNext: config.showNextButton,
                          showBack: config.showBackButton,
                          showSkip: config.showSkipButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapCustomTooltip(Widget child, SpotlightTourTheme theme) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: theme.tooltipPadding,
      decoration: BoxDecoration(
        color: theme.resolveBackgroundColor(context),
        borderRadius: BorderRadius.circular(theme.borderRadius),
        boxShadow: theme.tooltipShadow,
      ),
      child: child,
    );
  }
}
