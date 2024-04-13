import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditate/widgets/value_scroll.dart';

void main() {
  testWidgets('ValueScroll displays value on screen', (tester) async {
    // Arrange
    const length = 100;
    var value = 1;
    setValue(val) => value = val;
    final valueScrollWidget =
        ValueScroll(length: length, value: value, setValue: setValue);

    await tester.pumpWidget(MaterialApp(home: valueScrollWidget));

    // Act
    final valueFinder = find.text(value.toString());

    // Assert
    expect(valueFinder, findsOneWidget);

    // Act
    final itemFinder = find.text((length - 1).toString());
    final scrollFinder = find.byWidget(valueScrollWidget);
    await tester.dragUntilVisible(itemFinder, scrollFinder, const Offset(0, -500));

    // Assert
    // Verify that the item contains the correct text.
    expect(itemFinder, findsOneWidget);
  });
}
