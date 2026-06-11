import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/tour_step.dart';
import 'tour_json_exception.dart';
import 'tour_json_parser.dart';

/// Loads tour definitions from JSON assets or strings.
abstract final class TourJsonLoader {
  TourJsonLoader._();

  /// Loads tour steps from a Flutter asset path.
  static Future<List<TourStep>> loadAsset(
    String assetPath, {
    required Map<String, GlobalKey> keyRegistry,
    Map<String, Future<bool> Function()>? validatorRegistry,
  }) async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      return loadString(
        jsonString,
        keyRegistry: keyRegistry,
        validatorRegistry: validatorRegistry,
      );
    } on TourJsonException {
      rethrow;
    } on FlutterError catch (error) {
      throw TourJsonException('Failed to load asset "$assetPath": $error');
    }
  }

  /// Parses tour steps from a JSON string.
  static List<TourStep> loadString(
    String jsonString, {
    required Map<String, GlobalKey> keyRegistry,
    Map<String, Future<bool> Function()>? validatorRegistry,
  }) {
    try {
      final decoded = json.decode(jsonString);
      return loadMap(
        decoded,
        keyRegistry: keyRegistry,
        validatorRegistry: validatorRegistry,
      );
    } on TourJsonException {
      rethrow;
    } on FormatException catch (error) {
      throw TourJsonException('Invalid JSON: ${error.message}');
    }
  }

  /// Parses tour steps from a decoded JSON map.
  static List<TourStep> loadMap(
    dynamic map, {
    required Map<String, GlobalKey> keyRegistry,
    Map<String, Future<bool> Function()>? validatorRegistry,
  }) {
    if (map is! Map<String, dynamic>) {
      throw const TourJsonException('Root JSON value must be an object.');
    }
    return TourJsonParser.parseMap(
      map,
      keyRegistry: keyRegistry,
      validatorRegistry: validatorRegistry,
    );
  }
}
