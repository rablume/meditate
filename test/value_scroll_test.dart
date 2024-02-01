import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditate/widgets/value_scroll.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    const length = 5;
    var value = 1;
    final setValue = (val) => value = val;

    await tester.pumpWidget(MaterialApp(
        home: ValueScroll(length: length, value: value, setValue: setValue)));

    // Create the Finders.
    final valueFinder = find.text(value.toString());

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(valueFinder, findsOneWidget);
  });
}
