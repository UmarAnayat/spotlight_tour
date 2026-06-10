import 'package:flutter/widgets.dart';

import '../models/spotlight_style.dart';

/// Resolves a [GlobalKey] to a padded spotlight [Rect] in global coordinates.
class TargetResolver {
  TargetResolver._();

  /// Returns the global bounding rect for [key], expanded by [style.padding].
  ///
  /// Returns `null` when the target is not yet laid out.
  static Rect? resolve(GlobalKey key, SpotlightStyle style) {
    final context = key.currentContext;
    if (context == null) return null;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final padding = style.padding;

    return Rect.fromLTWH(
      offset.dx - padding,
      offset.dy - padding,
      size.width + padding * 2,
      size.height + padding * 2,
    );
  }
}
