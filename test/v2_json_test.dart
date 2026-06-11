import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  group('TourJsonLoader', () {
    final searchKey = GlobalKey();
    final cartKey = GlobalKey();

    test('loadString parses valid JSON', () {
      const json = '''
{
  "steps": [
    {
      "id": "search",
      "title": "Search Products",
      "description": "Tap search button",
      "requiredAction": "tap",
      "tooltipPosition": "bottom",
      "shape": "circle",
      "padding": 12,
      "borderRadius": 16,
      "animationType": "bounce"
    }
  ]
}
''';

      final steps = TourJsonLoader.loadString(
        json,
        keyRegistry: {'search': searchKey},
      );

      expect(steps, hasLength(1));
      expect(steps.first.title, 'Search Products');
      expect(steps.first.requiredAction, RequiredAction.tap);
      expect(steps.first.tooltipPosition, TooltipPosition.bottom);
      expect(steps.first.spotlightStyle?.shape, SpotlightShape.circle);
      expect(steps.first.animationType, TooltipAnimationType.bounce);
    });

    test('loadMap resolves validatorId', () {
      final steps = TourJsonLoader.loadMap(
        {
          'steps': [
            {
              'id': 'cart',
              'title': 'Cart',
              'validatorId': 'has_items',
            },
          ],
        },
        keyRegistry: {'cart': cartKey},
        validatorRegistry: {
          'has_items': () async => true,
        },
      );

      expect(steps.first.validator, isNotNull);
    });

    test('throws TourJsonException for invalid enum', () {
      expect(
        () => TourJsonLoader.loadMap(
          {
            'steps': [
              {
                'id': 'search',
                'requiredAction': 'swipe',
              },
            ],
          },
          keyRegistry: {'search': searchKey},
        ),
        throwsA(isA<TourJsonException>()),
      );
    });

    test('throws TourJsonException for missing steps', () {
      expect(
        () => TourJsonLoader.loadMap({}, keyRegistry: {}),
        throwsA(isA<TourJsonException>()),
      );
    });

    test('loadMap supports multiple targetIds', () {
      final filterKey = GlobalKey();
      final steps = TourJsonLoader.loadMap(
        {
          'steps': [
            {
              'id': 'search',
              'targetIds': ['search', 'filter'],
              'title': 'Toolbar',
            },
          ],
        },
        keyRegistry: {
          'search': searchKey,
          'filter': filterKey,
        },
      );

      expect(steps.first.resolvedTargetKeys, hasLength(2));
    });
  });
}
