import 'package:flutter/widgets.dart';

import '../models/spotlight_style.dart';

/// Resolves [GlobalKey] targets to padded spotlight rects in global coordinates.
class TargetResolver {
  TargetResolver._();

  /// Returns the global bounding rect for [key], expanded by [style.padding].
  ///
  /// Returns `null` when the target is not yet laid out.
  static Rect? resolve(GlobalKey key, SpotlightStyle style) {
    return resolveKey(key, style);
  }

  /// Returns the global bounding rect for [key], expanded by [style.padding].
  static Rect? resolveKey(GlobalKey key, SpotlightStyle style) {
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

  /// Resolves all [keys] to rects. Omits keys that are not yet laid out.
  static List<Rect> resolveAll(
    List<GlobalKey> keys,
    SpotlightStyle style,
  ) {
    final rects = <Rect>[];
    for (final key in keys) {
      final rect = resolveKey(key, style);
      if (rect != null) {
        rects.add(rect);
      }
    }
    return rects;
  }

  /// Returns a bounding rect that contains all [rects].
  static Rect? boundingRect(List<Rect> rects) {
    if (rects.isEmpty) return null;
    Rect bounds = rects.first;
    for (var i = 1; i < rects.length; i++) {
      bounds = bounds.expandToInclude(rects[i]);
    }
    return bounds;
  }
}
