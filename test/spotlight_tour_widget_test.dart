import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_tour/spotlight_tour.dart';

void main() {
  group('SpotlightTour widget integration', () {
    testWidgets('starts tour and shows overlay with tooltip', (tester) async {
      final searchKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                      key: searchKey,
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    SpotlightTour.start(
                      context,
                      steps: [
                        TourStep(
                          targetKey: searchKey,
                          title: 'Search',
                          description: 'Tap to search.',
                        ),
                      ],
                    );
                  },
                  child: const Icon(Icons.play_arrow),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(SpotlightTour.isActive, isTrue);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Tap to search.'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('next button advances step counter', (tester) async {
      final key1 = GlobalKey();
      final key2 = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SpotlightTour.start(
                  context,
                  steps: [
                    TourStep(targetKey: key1, title: 'First'),
                    TourStep(targetKey: key2, title: 'Second'),
                  ],
                );
              });

              return Scaffold(
                body: Column(
                  children: [
                    SizedBox(key: key1, width: 100, height: 50),
                    SizedBox(key: key2, width: 100, height: 50),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Step 1 of 2'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Step 2 of 2'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('stop dismisses active tour', (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SpotlightTour.start(
                  context,
                  steps: [TourStep(targetKey: key, title: 'Hello')],
                );
              });
              return Scaffold(body: SizedBox(key: key, width: 50, height: 50));
            },
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(SpotlightTour.isActive, isTrue);

      SpotlightTour.stop();
      await tester.pump();
      await tester.pump();

      expect(SpotlightTour.isActive, isFalse);
    });
  });
}
