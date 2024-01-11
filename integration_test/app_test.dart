import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:meditate/main.dart';
import 'package:provider/provider.dart';

import 'package:meditate/constants.dart' as Constants;
import 'package:meditate/utils.dart' as Utils;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the start button, verify timer', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
          child: const MyApp(),
        ),
      );

      // Verify the counter starts at default timer seconds.
      expect(find.text(Utils.formatDuration(Constants.DEFAULT_TIMER_SECONDS)),
          findsOneWidget);
      expect(find.text(Constants.RESET_TEXT).hitTestable(), findsNothing);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      // Finds the start button to tap on.
      final start = find.byIcon(Icons.play_arrow);

      // Emulate a tap on the start button.
      await tester.tap(start);

      // Trigger a frame.
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(
          find.text(Utils.formatDuration(Constants.DEFAULT_TIMER_SECONDS - 1)),
          findsOneWidget);
      expect(find.text(Constants.RESET_TEXT), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz).hitTestable(), findsNothing);
      expect(find.byIcon(Icons.pause), findsOneWidget);

      // Emulate a tap on the page
      await tester.tap(
          find.text(Utils.formatDuration(Constants.DEFAULT_TIMER_SECONDS - 1)));
      await tester.pumpAndSettle();

      expect(
          find
              .text(Utils.formatDuration(Constants.DEFAULT_TIMER_SECONDS - 1))
              .hitTestable(),
          findsNothing);
      expect(find.text(Constants.RESET_TEXT).hitTestable(), findsNothing);
      expect(find.byIcon(Icons.more_horiz).hitTestable(), findsNothing);
      expect(find.byIcon(Icons.pause).hitTestable(), findsNothing);

      // Emulate a tap on the page
      await tester.tap(find.byKey(Key('AppBody')));
      await tester.pumpAndSettle();

      expect(
          find.text(Utils.formatDuration(Constants.DEFAULT_TIMER_SECONDS - 1)),
          findsOneWidget);
      expect(find.text(Constants.RESET_TEXT), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz).hitTestable(), findsNothing);
      expect(find.byIcon(Icons.pause), findsOneWidget);

      await tester.pumpAndSettle(
          Duration(seconds: Constants.DEFAULT_TIMER_SECONDS - 1));

      expect(find.text('00:00'), findsOneWidget);
      expect(find.text(Constants.RESET_TEXT), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);

      await tester.pumpAndSettle(Duration(seconds: 60));

      expect(find.text('-1:00'), findsOneWidget);
      expect(find.text(Constants.RESET_TEXT), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });
}
