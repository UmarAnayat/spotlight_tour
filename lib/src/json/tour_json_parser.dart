import 'package:flutter/widgets.dart';

import '../models/required_action.dart';
import '../models/spotlight_shape.dart';
import '../models/spotlight_style.dart';
import '../models/tooltip_animation_type.dart';
import '../models/tooltip_position.dart';
import '../models/tour_step.dart';
import 'tour_json_exception.dart';

/// Parses JSON maps into [TourStep] lists.
class TourJsonParser {
  TourJsonParser._();

  /// Parses a root JSON [map] into tour steps.
  static List<TourStep> parseMap(
    Map<String, dynamic> map, {
    required Map<String, GlobalKey> keyRegistry,
    Map<String, Future<bool> Function()>? validatorRegistry,
  }) {
    final stepsRaw = map['steps'];
    if (stepsRaw == null) {
      throw const TourJsonException(
        'Missing required key "steps".',
        path: 'steps',
      );
    }
    if (stepsRaw is! List) {
      throw const TourJsonException(
        '"steps" must be a list.',
        path: 'steps',
      );
    }
    if (stepsRaw.isEmpty) {
      throw const TourJsonException(
        '"steps" must contain at least one step.',
        path: 'steps',
      );
    }

    return List<TourStep>.generate(stepsRaw.length, (index) {
      final stepRaw = stepsRaw[index];
      final path = 'steps[$index]';
      if (stepRaw is! Map<String, dynamic>) {
        throw TourJsonException(
          'Each step must be an object.',
          path: path,
        );
      }
      return _parseStep(
        stepRaw,
        path: path,
        keyRegistry: keyRegistry,
        validatorRegistry: validatorRegistry,
      );
    });
  }

  static TourStep _parseStep(
    Map<String, dynamic> json, {
    required String path,
    required Map<String, GlobalKey> keyRegistry,
    Map<String, Future<bool> Function()>? validatorRegistry,
  }) {
    final id = _optionalString(json, 'id', path: path);
    final targetId = _optionalString(json, 'targetId', path: path);
    final keyId = targetId ?? id;
    if (keyId == null) {
      throw TourJsonException(
        'Each step requires "id" or "targetId" for key lookup.',
        path: path,
      );
    }

    final singleKey = keyRegistry[keyId];
    if (singleKey == null) {
      throw TourJsonException(
        'No GlobalKey registered for "$keyId".',
        path: '$path.id',
      );
    }

    List<GlobalKey>? targetKeys;
    final targetIds = json['targetIds'];
    if (targetIds != null) {
      if (targetIds is! List) {
        throw TourJsonException(
          '"targetIds" must be a list of strings.',
          path: '$path.targetIds',
        );
      }
      targetKeys = targetIds.map((rawId) {
        if (rawId is! String) {
          throw TourJsonException(
            'Each targetId must be a string.',
            path: '$path.targetIds',
          );
        }
        final key = keyRegistry[rawId];
        if (key == null) {
          throw TourJsonException(
            'No GlobalKey registered for "$rawId".',
            path: '$path.targetIds',
          );
        }
        return key;
      }).toList();
    }

    final requiredAction = _parseRequiredAction(
      json['requiredAction'],
      path: '$path.requiredAction',
    );

    final validatorId = _optionalString(json, 'validatorId', path: path);
    Future<bool> Function()? validator;
    if (validatorId != null) {
      validator = validatorRegistry?[validatorId];
      if (validator == null) {
        throw TourJsonException(
          'No validator registered for "$validatorId".',
          path: '$path.validatorId',
        );
      }
    }

    final style = _parseSpotlightStyle(json, path: path);

    return TourStep(
      id: id,
      targetKey: singleKey,
      targetKeys: targetKeys,
      title: _optionalString(json, 'title', path: path),
      description: _optionalString(json, 'description', path: path),
      requiredAction: requiredAction,
      validator: validator,
      spotlightStyle: style,
      tooltipPosition: _parseTooltipPosition(
        json['tooltipPosition'],
        path: '$path.tooltipPosition',
      ),
      lottieAsset: _optionalString(json, 'lottieAsset', path: path),
      animationType: _parseAnimationType(
        json['animationType'],
        path: '$path.animationType',
      ),
    );
  }

  static SpotlightStyle? _parseSpotlightStyle(
    Map<String, dynamic> json, {
    required String path,
  }) {
    final hasShape = json.containsKey('shape');
    final hasPadding = json.containsKey('padding');
    final hasBorderRadius = json.containsKey('borderRadius');
    if (!hasShape && !hasPadding && !hasBorderRadius) return null;

    return SpotlightStyle(
      shape: _parseShape(json['shape'], path: '$path.shape'),
      padding: _parseDouble(json['padding'], path: '$path.padding') ?? 8,
      borderRadius:
          _parseDouble(json['borderRadius'], path: '$path.borderRadius') ?? 12,
    );
  }

  static String? _optionalString(
    Map<String, dynamic> json,
    String key, {
    required String path,
  }) {
    final value = json[key];
    if (value == null) return null;
    if (value is! String) {
      throw TourJsonException(
        '"$key" must be a string.',
        path: '$path.$key',
      );
    }
    return value;
  }

  static double? _parseDouble(dynamic value, {required String path}) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    throw TourJsonException('Expected a number.', path: path);
  }

  static RequiredAction? _parseRequiredAction(dynamic value, {required String path}) {
    if (value == null) return null;
    if (value is! String) {
      throw TourJsonException('requiredAction must be a string.', path: path);
    }
    switch (value) {
      case 'tap':
        return RequiredAction.tap;
      case 'doubleTap':
        return RequiredAction.doubleTap;
      case 'longPress':
        return RequiredAction.longPress;
      default:
        throw TourJsonException(
          'Unknown requiredAction "$value".',
          path: path,
        );
    }
  }

  static SpotlightShape _parseShape(dynamic value, {required String path}) {
    if (value == null) return SpotlightShape.roundedRectangle;
    if (value is! String) {
      throw TourJsonException('shape must be a string.', path: path);
    }
    switch (value) {
      case 'circle':
        return SpotlightShape.circle;
      case 'rectangle':
        return SpotlightShape.rectangle;
      case 'roundedRectangle':
        return SpotlightShape.roundedRectangle;
      default:
        throw TourJsonException('Unknown shape "$value".', path: path);
    }
  }

  static TooltipPosition _parseTooltipPosition(
    dynamic value, {
    required String path,
  }) {
    if (value == null) return TooltipPosition.auto;
    if (value is! String) {
      throw TourJsonException('tooltipPosition must be a string.', path: path);
    }
    switch (value) {
      case 'top':
        return TooltipPosition.top;
      case 'bottom':
        return TooltipPosition.bottom;
      case 'left':
        return TooltipPosition.left;
      case 'right':
        return TooltipPosition.right;
      case 'auto':
        return TooltipPosition.auto;
      default:
        throw TourJsonException(
          'Unknown tooltipPosition "$value".',
          path: path,
        );
    }
  }

  static TooltipAnimationType? _parseAnimationType(
    dynamic value, {
    required String path,
  }) {
    if (value == null) return null;
    if (value is! String) {
      throw TourJsonException('animationType must be a string.', path: path);
    }
    switch (value) {
      case 'fade':
        return TooltipAnimationType.fade;
      case 'slide':
        return TooltipAnimationType.slide;
      case 'scale':
        return TooltipAnimationType.scale;
      case 'bounce':
        return TooltipAnimationType.bounce;
      default:
        throw TourJsonException(
          'Unknown animationType "$value".',
          path: path,
        );
    }
  }
}
