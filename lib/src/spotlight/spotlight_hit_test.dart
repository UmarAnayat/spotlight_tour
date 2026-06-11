import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A full-screen layer that blocks pointer events except inside hole rect(s).
class SpotlightHitTest extends SingleChildRenderObjectWidget {
  /// Creates a hit-test layer with the given [holeRects].
  const SpotlightHitTest({
    super.key,
    required this.holeRects,
    required super.child,
  });

  /// Hole rectangles where pointer events pass through.
  final List<Rect> holeRects;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSpotlightHitTest(holeRects: holeRects);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSpotlightHitTest renderObject,
  ) {
    renderObject.holeRects = holeRects;
  }
}

class RenderSpotlightHitTest extends RenderProxyBox {
  RenderSpotlightHitTest({required List<Rect> holeRects})
      : _holeRects = List<Rect>.from(holeRects);

  List<Rect> _holeRects;

  List<Rect> get holeRects => _holeRects;

  set holeRects(List<Rect> value) {
    _holeRects = List<Rect>.from(value);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    for (final rect in _holeRects) {
      if (rect.contains(position)) {
        return false;
      }
    }
    return super.hitTest(result, position: position);
  }
}
