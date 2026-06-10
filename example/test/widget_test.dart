import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SpotlightTourExampleApp());
    expect(find.text('Spotlight Tour Demo'), findsOneWidget);
    expect(find.text('Start Tour'), findsOneWidget);
  });
}
