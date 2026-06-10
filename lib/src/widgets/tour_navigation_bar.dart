import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/spotlight_tour_controller.dart';
import '../theme/spotlight_tour_theme.dart';

/// Default Next, Back, and Skip controls for a tour step.
class TourNavigationBar extends StatelessWidget {
  const TourNavigationBar({
    super.key,
    required this.controller,
    required this.theme,
    required this.showNext,
    required this.showBack,
    required this.showSkip,
  });

  final SpotlightTourController controller;
  final SpotlightTourTheme theme;
  final bool showNext;
  final bool showBack;
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final canAdvance = controller.canAdvance;
        final canGoBack = controller.canGoBack;
        final isLastStep =
            controller.currentIndex >= controller.totalSteps - 1;

        if (theme.useCupertino) {
          return _buildCupertino(
            context,
            canAdvance: canAdvance,
            canGoBack: canGoBack,
            isLastStep: isLastStep,
          );
        }

        return _buildMaterial(
          context,
          canAdvance: canAdvance,
          canGoBack: canGoBack,
          isLastStep: isLastStep,
        );
      },
    );
  }

  Widget _buildMaterial(
    BuildContext context, {
    required bool canAdvance,
    required bool canGoBack,
    required bool isLastStep,
  }) {
    final primary = theme.resolvePrimaryColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBack)
          TextButton(
            onPressed: canGoBack ? controller.back : null,
            child: const Text('Back'),
          )
        else
          const SizedBox(width: 64),
        if (showSkip)
          TextButton(
            onPressed: controller.skip,
            child: Text(
              'Skip',
              style: TextStyle(color: theme.resolveSecondaryTextColor(context)),
            ),
          )
        else
          const SizedBox.shrink(),
        if (showNext)
          FilledButton(
            onPressed: canAdvance ? () => controller.next() : null,
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withValues(alpha: 0.35),
            ),
            child: Text(isLastStep ? 'Done' : 'Next'),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildCupertino(
    BuildContext context, {
    required bool canAdvance,
    required bool canGoBack,
    required bool isLastStep,
  }) {
    final primary = theme.resolvePrimaryColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBack)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: canGoBack ? controller.back : null,
            child: const Text('Back'),
          )
        else
          const SizedBox(width: 64),
        if (showSkip)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: controller.skip,
            child: Text(
              'Skip',
              style: TextStyle(
                color: theme.resolveSecondaryTextColor(context),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        if (showNext)
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            onPressed: canAdvance ? () => controller.next() : null,
            color: canAdvance ? primary : primary.withValues(alpha: 0.35),
            child: Text(isLastStep ? 'Done' : 'Next'),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
