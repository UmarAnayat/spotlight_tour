import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/spotlight_tour_theme.dart';

/// Built-in progress indicator for a tour step.
class TourProgress extends StatelessWidget {
  const TourProgress({
    super.key,
    required this.stepCounter,
    required this.progress,
    required this.progressPercent,
    required this.theme,
  });

  final String stepCounter;
  final double progress;
  final String progressPercent;
  final SpotlightTourTheme theme;

  @override
  Widget build(BuildContext context) {
    final primary = theme.resolveProgressColor(context);
    final secondary = theme.resolveSecondaryTextColor(context);

    if (theme.useCupertino) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stepCounter,
            style: TextStyle(
              fontSize: 13,
              color: secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: CupertinoColors.systemGrey5.resolveFrom(context),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Progress: $progressPercent',
            style: TextStyle(fontSize: 12, color: secondary),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stepCounter,
          style: theme.resolveDescriptionStyle(context).copyWith(
                fontWeight: FontWeight.w600,
                color: secondary,
              ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(theme.borderRadius / 2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: primary.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(primary),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Progress: $progressPercent',
          style: theme.resolveDescriptionStyle(context).copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
