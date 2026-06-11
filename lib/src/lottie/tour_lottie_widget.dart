import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Displays a looping Lottie animation inside a tour tooltip.
class TourLottieWidget extends StatelessWidget {
  /// Creates a [TourLottieWidget].
  const TourLottieWidget({
    super.key,
    required this.assetPath,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.contain,
  });

  /// Asset path to the Lottie JSON file.
  final String assetPath;

  /// Animation width.
  final double width;

  /// Animation height.
  final double height;

  /// Box fit behavior.
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: Lottie.asset(
          assetPath,
          fit: fit,
          repeat: true,
          animate: true,
          frameRate: FrameRate.max,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
