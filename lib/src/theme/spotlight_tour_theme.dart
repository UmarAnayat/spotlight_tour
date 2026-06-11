import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/tooltip_animation_type.dart';

/// Visual theme for spotlight tour overlays, tooltips, and controls.
class SpotlightTourTheme {
  /// Creates a [SpotlightTourTheme].
  const SpotlightTourTheme({
    this.primaryColor,
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.borderRadius = 16,
    this.tooltipPadding = const EdgeInsets.all(16),
    this.tooltipShadow = const [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
    this.titleStyle,
    this.descriptionStyle,
    this.buttonTextStyle,
    this.progressColor,
    this.indicatorColor,
    this.indicatorInactiveColor,
    this.tooltipAnimationType = TooltipAnimationType.fade,
    this.animationDuration = const Duration(milliseconds: 320),
    this.animationCurve = Curves.easeOutCubic,
    this.useMaterial3 = true,
    this.useCupertino = false,
  });

  /// Material 3 preset theme.
  factory SpotlightTourTheme.material3({Color? primaryColor}) {
    return SpotlightTourTheme(
      primaryColor: primaryColor,
      useMaterial3: true,
      useCupertino: false,
    );
  }

  /// Cupertino (iOS) preset theme.
  factory SpotlightTourTheme.cupertino({Color? primaryColor}) {
    return SpotlightTourTheme(
      primaryColor: primaryColor ?? CupertinoColors.activeBlue,
      useMaterial3: false,
      useCupertino: true,
    );
  }

  /// Accent color for buttons, borders, and progress.
  final Color? primaryColor;

  /// Tooltip background color.
  final Color? backgroundColor;

  /// Primary text color inside tooltips.
  final Color? textColor;

  /// Secondary text color for descriptions.
  final Color? secondaryTextColor;

  /// Corner radius for tooltips and buttons.
  final double borderRadius;

  /// Internal padding for default tooltips.
  final EdgeInsets tooltipPadding;

  /// Drop shadow behind tooltips.
  final List<BoxShadow> tooltipShadow;

  /// Title text style override.
  final TextStyle? titleStyle;

  /// Description text style override.
  final TextStyle? descriptionStyle;

  /// Navigation button text style override.
  final TextStyle? buttonTextStyle;

  /// Progress bar active color.
  final Color? progressColor;

  /// Step indicator active color.
  final Color? indicatorColor;

  /// Step indicator inactive color.
  final Color? indicatorInactiveColor;

  /// Default tooltip animation type.
  final TooltipAnimationType tooltipAnimationType;

  /// Default tooltip animation duration.
  final Duration animationDuration;

  /// Default tooltip animation curve.
  final Curve animationCurve;

  /// Use Material 3 widgets and typography.
  final bool useMaterial3;

  /// Use Cupertino widgets and typography.
  final bool useCupertino;

  /// Resolves [primaryColor] from context when not explicitly set.
  Color resolvePrimaryColor(BuildContext context) {
    if (primaryColor != null) return primaryColor!;
    if (useCupertino) return CupertinoTheme.of(context).primaryColor;
    return Theme.of(context).colorScheme.primary;
  }

  /// Resolves tooltip background color.
  Color resolveBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    if (useCupertino) {
      return CupertinoColors.systemBackground.resolveFrom(context);
    }
    return Theme.of(context).colorScheme.surface;
  }

  /// Resolves primary text color.
  Color resolveTextColor(BuildContext context) {
    if (textColor != null) return textColor!;
    if (useCupertino) {
      return CupertinoColors.label.resolveFrom(context);
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Resolves secondary text color.
  Color resolveSecondaryTextColor(BuildContext context) {
    if (secondaryTextColor != null) return secondaryTextColor!;
    if (useCupertino) {
      return CupertinoColors.secondaryLabel.resolveFrom(context);
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  /// Resolves progress indicator color.
  Color resolveProgressColor(BuildContext context) {
    return progressColor ?? resolvePrimaryColor(context);
  }

  /// Resolves active indicator dot color.
  Color resolveIndicatorColor(BuildContext context) {
    return indicatorColor ?? resolvePrimaryColor(context);
  }

  /// Resolves inactive indicator dot color.
  Color resolveIndicatorInactiveColor(BuildContext context) {
    return indicatorInactiveColor ??
        resolveSecondaryTextColor(context).withValues(alpha: 0.25);
  }

  /// Resolves navigation button text style.
  TextStyle resolveButtonTextStyle(BuildContext context) {
    if (buttonTextStyle != null) return buttonTextStyle!;
    return TextStyle(
      fontSize: useCupertino ? 17 : 14,
      fontWeight: FontWeight.w600,
      color: resolvePrimaryColor(context),
    );
  }

  /// Resolves title [TextStyle].
  TextStyle resolveTitleStyle(BuildContext context) {
    if (titleStyle != null) return titleStyle!;
    if (useCupertino) {
      return TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: resolveTextColor(context),
        letterSpacing: -0.4,
      );
    }
    final theme = Theme.of(context);
    return (useMaterial3
            ? theme.textTheme.titleMedium
            : theme.textTheme.titleLarge)
        ?.copyWith(
          color: resolveTextColor(context),
          fontWeight: FontWeight.w600,
        ) ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: resolveTextColor(context),
        );
  }

  /// Resolves description [TextStyle].
  TextStyle resolveDescriptionStyle(BuildContext context) {
    if (descriptionStyle != null) return descriptionStyle!;
    if (useCupertino) {
      return TextStyle(
        fontSize: 15,
        color: resolveSecondaryTextColor(context),
        height: 1.35,
      );
    }
    final theme = Theme.of(context);
    return (useMaterial3
            ? theme.textTheme.bodyMedium
            : theme.textTheme.bodyLarge)
        ?.copyWith(color: resolveSecondaryTextColor(context)) ??
        TextStyle(
          fontSize: 15,
          color: resolveSecondaryTextColor(context),
        );
  }

  /// Returns a copy with the given fields replaced.
  SpotlightTourTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? secondaryTextColor,
    double? borderRadius,
    EdgeInsets? tooltipPadding,
    List<BoxShadow>? tooltipShadow,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? buttonTextStyle,
    Color? progressColor,
    Color? indicatorColor,
    Color? indicatorInactiveColor,
    TooltipAnimationType? tooltipAnimationType,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? useMaterial3,
    bool? useCupertino,
  }) {
    return SpotlightTourTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      borderRadius: borderRadius ?? this.borderRadius,
      tooltipPadding: tooltipPadding ?? this.tooltipPadding,
      tooltipShadow: tooltipShadow ?? this.tooltipShadow,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      progressColor: progressColor ?? this.progressColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorInactiveColor:
          indicatorInactiveColor ?? this.indicatorInactiveColor,
      tooltipAnimationType:
          tooltipAnimationType ?? this.tooltipAnimationType,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useCupertino: useCupertino ?? this.useCupertino,
    );
  }
}
