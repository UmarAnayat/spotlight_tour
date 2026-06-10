import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A full-screen layer that blocks pointer events except inside [holeRect].
class SpotlightHitTest extends SingleChildRenderObjectWidget {
  const SpotlightHitTest({
    super.key,
    required this.holeRect,
    required super.child,
  });

  final Rect holeRect;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSpotlightHitTest(holeRect: holeRect);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSpotlightHitTest renderObject,
  ) {
    renderObject.holeRect = holeRect;
  }
}

class RenderSpotlightHitTest extends RenderProxyBox {
  RenderSpotlightHitTest({required Rect holeRect}) : _holeRect = holeRect;

  Rect _holeRect;

  Rect get holeRect => _holeRect;

  set holeRect(Rect value) {
    if (_holeRect == value) return;
    _holeRect = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_holeRect.contains(position)) {
      return false;
    }
    return super.hitTest(result, position: position);
  }
}
